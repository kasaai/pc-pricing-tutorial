source("analysis/packages.R")
source("analysis/utils.R")
source("analysis/functions-data.R")

library(tidyverse)
library(recipes)
library(tfdatasets)
library(keras)
library(forcats)

data_dir <- fs::path(here::here(), "external_data", "Autoseg2012B")

raw_data <- read_raw_data(data_dir)
modeling_data <- prep_modeling_data(raw_data)


# Perform initial split into training and testing/holdout
set.seed(2019)
splits <- rsample::initial_split(modeling_data, prop = 4 / 5)
training_data <- rsample::training(splits)
training_splits <- training_data %>% rsample::initial_split(prop = 3/4)
analysis_data <- rsample::training(training_splits)
assessment_data <- rsample::testing(training_splits)

testing_data <- rsample::testing(splits)

report_year <- 2012

rec <- recipe(analysis_data, ~.) %>%
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
  prep(analysis_data, strings_as_factors = FALSE, retain = TRUE)


predictors <- c("sex", "age_range", "vehicle_age", "make", 
                "vehicle_category",
                "region"
                )

# feature columns don't handle factors well currently
analysis_data <- juice(rec) %>% 
  mutate_if(is.factor, as.character) %>% 
  select(c(predictors, "exposure", "loss_per_exposure"))

assessment_data <- bake(rec, assessment_data) %>% 
  mutate_if(is.factor, as.character) %>% 
  select(c(predictors, "exposure", "loss_per_exposure"))

testing_data <- bake(rec, testing_data) %>% 
  mutate_if(is.factor, as.character) %>% 
  select(c(predictors, "exposure", "loss_per_exposure"))

# Construct feature spec
feat_spec <- analysis_data %>% 
  feature_spec(x = predictors, y = "loss_per_exposure") %>% 
  step_numeric_column(vehicle_age, #average_insured_amount, 
                      normalizer_fn = scaler_standard()) %>% 
  step_categorical_column_with_vocabulary_list(
    sex, age_range, vehicle_category, region, make
  ) %>%
  step_indicator_column(sex, age_range, vehicle_category) %>%
  step_embedding_column(region, make) %>%
  fit()

toy_model <- keras_model_sequential(list(
  layer_dense_features(feature_columns = feat_spec$dense_features()),
  layer_dense(units = 64, activation = "relu"),
  layer_dense(units = 64, activation = "relu"),
  layer_dense(units = 1, activation = "softplus")
))

toy_model %>% 
  compile(optimizer = optimizer_adam(lr = 0.1), loss = "mse", metric = "mse")

history <- toy_model %>% 
  fit(x = select(analysis_data, predictors), 
      y = analysis_data$loss_per_exposure,
      sample_weight = analysis_data$exposure,
      validation_data = list(
        assessment_data %>% select(predictors),
        assessment_data$loss_per_exposure,
        assessment_data$exposure
      ),
      batch_size = 10000, epochs = 50,
      callbacks = list(
        callback_early_stopping(patience = 5, restore_best_weights = TRUE)
      )
    )

keras::save_model_tf(toy_model, "internal/toy-model", overwrite = TRUE)
