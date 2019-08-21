library(tidyverse)
library(recipes)
library(tfdatasets)
library(keras)
source("analysis/data-prep.R")
report_year <- 2012

# Get a small subset since we're focused on the deployment aspect
train_set <- training_data %>% 
  sample_n(10000)

# Prep recipe on training set
rec <- recipe(train_set, ~.) %>%
  step_mutate(
    make = sub(" .*$", "", vehicle_group),
    vehicle_age = pmin(pmax(!!report_year - vehicle_year, 0), 35)
  ) %>%
  step_other(make, threshold = 0.01) %>%
  step_string2factor(region, sex, age_range, vehicle_category) %>%
  step_mutate(
    average_insured_amount = average_insured_amount / 1000,
    region = fct_explicit_na(region),
    make = fct_explicit_na(make),
    vehicle_category = fct_explicit_na(vehicle_category)
  ) %>%
  prep(train_set, strings_as_factors = FALSE, retain = TRUE)

predictors <- c("sex", "age_range", "vehicle_age", "make", "vehicle_category",
                "region", "average_insured_amount")
# feature columns don't handle factors well currently
train_set <- juice(rec) %>% 
  mutate_if(is.factor, as.character) %>% 
  bind_cols(select(train_set, claim_amount, exposure)) %>% 
  mutate(exposure = exposure + 0.5, # see #81
         loss_per_exposure = claim_amount / exposure)

# Construct feature spec
feat_spec <- train_set %>% 
  feature_spec(x = predictors, y = "loss_per_exposure") %>% 
  step_numeric_column(vehicle_age, average_insured_amount, 
                      normalizer_fn = scaler_standard()) %>% 
  step_categorical_column_with_vocabulary_list(
    sex, age_range, vehicle_category, region, make
  ) %>%
  step_indicator_column(sex, age_range, vehicle_category) %>%
  step_embedding_column(region, make) %>%
  fit()

toy_model <- keras_model_sequential(list(
  layer_dense_features(feature_columns = feat_spec$dense_features()),
  layer_dense(units = 10, activation = "relu"),
  layer_dense(units = 1, activation = "relu")
))

toy_model %>% 
  compile(optimizer = optimizer_adam(lr = 0.1), loss = "mse")

history <- toy_model %>% 
  fit(x = select(train_set, predictors), 
      y = train_set$loss_per_exposure, 
      sample_weight = train_set$exposure,
      batch_size = 10000, epochs = 100)
plot(history)

# `save_model_hdf5()` isn't working properly with feature columns yet, so we
#   use this for serializing
tensorflow::tf$keras$models$save_model(toy_model, filepath = "model_artifacts/toy_model", 
                                       save_format = "tf")

# we'll also want to remove the data frame, see
#  https://github.com/tidymodels/butcher/issues/132
saveRDS(rec, "model_artifacts/recipe.rds")

# Prediction ----

# in new R session

library(tensorflow)
library(dplyr)
library(keras)
library(recipes)
library(forcats)

if (!dir.exists("model_artifacts")) {
  piggyback::pb_download("model_artifacts.tar.gz", repo = "kasaai/pc-pricing-tutorial")
  untar("model_artifacts.tar.gz")
}

toy_model_loaded <- tensorflow::tf$keras$models$load_model("model_artifacts/toy_model")
recipe_loaded <- readRDS("model_artifacts/recipe.rds")

incoming <- '{"vehicle_group":["GM CHEVROLET CELTA 1.0"],"vehicle_year":[2005],
"region":["SC - Oeste"],"sex":["Masculino"],"age_range":["Entre 18 e 25 anos"],
"vehicle_category":["Passeio nacional"],"average_insured_amount":[18179]}'

new_data <- jsonlite::fromJSON(incoming) %>% 
  as.data.frame() %>% 
  bake(recipe_loaded, .) %>% 
  mutate_if(is.factor, as.character)
predict(toy_model_loaded, new_data)
