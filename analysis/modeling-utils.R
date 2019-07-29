freq_sev_glm <- function(split) {
  train_set <- analysis(split)
  validation_set <- assessment(split)
  
  m1_frequency <- glm(
    claim_count ~ region + sex + age_range + 
      log_average_insured_amount + log1p_vehicle_age + make + 
      offset(log(exposure)),
    data = train_set,
    family = "poisson"
  )
  
  train_set_severity <- train_set %>%
    filter(claim_amount > 0) %>%
    mutate(severity = claim_amount / claim_count)
  
  # `glm2` for better convergence
  m1_severity <- glm2::glm2(
    severity ~ region + sex + age_range + 
      log_average_insured_amount + log1p_vehicle_age + make,
    data = train_set_severity,
    weights = train_set_severity$claim_count,
    family = Gamma(link = "log")
  )
  
  relativities_frequency <- tidy(m1_frequency, exponentiate = TRUE)
  relativities_severity <- tidy(m1_severity, exponentiate = TRUE)
  
  # Check to see factor levels matching for two models
  select(relativities_frequency, term) %>%
    anti_join(select(relativities_severity, term), by = "term") %>% 
    assertr::verify(nrow(.) == 0)
  
  predicted_frequency <- predict(m1_frequency, validation_set, type = "response")
  predicted_severity <- predict(m1_severity, validation_set, type = "response")
  predicted_loss <- predicted_frequency * predicted_severity
  
  validation_set_preds <- validation_set %>% 
    mutate(predicted_claim_amount = predicted_loss)
  
  # record results in a tibble
  tibble(
    rel_freq = list(relativities_frequency),
    rel_sev = list(relativities_severity),
    predictions = list(predicted_loss),
    metrics = list(bind_rows(
      yardstick::rmse(validation_set_preds, claim_amount, predicted_claim_amount, na_rm = FALSE),
      yardstick::rsq(validation_set_preds, claim_amount, predicted_claim_amount, na_rm = FALSE)
    ))
  )
}