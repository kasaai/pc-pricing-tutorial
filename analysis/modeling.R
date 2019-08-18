library(recipes)
library(furrr)
source("analysis/modeling-utils.R")

# k-fold CV on the training data
#   using 2 for development, should bump up to 10
cv_obj <- vfold_cv(training_data, v = 2)


plan(multiprocess)
cv_obj$results <- future_map(cv_obj$splits, freq_sev_glm, .progress = TRUE)

