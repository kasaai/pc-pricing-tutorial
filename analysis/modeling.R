library(rsample)
source("analysis/modeling-utils.R")

# Keep personal auto categories
modeling_data2 <- modeling_data %>%
  filter(
    # See https://github.com/kasaai/pc-pricing-tutorial/issues/88
    vehicle_category %in% c(
      "Passeio importado",
      "Passeio nacional",
      "Pick-up (nacional e importado)"
    ),
    # This filters out "Jurídica" which means "enterprise"
    sex %in% c("Feminino", "Masculino"),
    # See https://github.com/kasaai/pc-pricing-tutorial/issues/89
    average_insured_amount > 0
  ) %>% 
  mutate(log1p_vehicle_age = log1p(vehicle_age),
         log_average_insured_amount = log(average_insured_amount))

# Perform initial split into training and testing/holdout
splits <- initial_split(modeling_data2, prop = 4 / 5)
training_data <- training(splits)

# k-fold CV on the training data
#   using 2 for development, should bump up to 10
cv_obj <- vfold_cv(training_data, v = 2)
cv_obj$results <- map(cv_obj$splits, freq_sev_glm)
