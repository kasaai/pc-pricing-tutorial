freq_sev_glm <- function(split) {
  
  train_set <- analysis(split)
  report_year <- 2012
  
  rec <- make_recipe(train_set, report_year) %>%
    prep(train_set, strings_as_factors = FALSE, retain = TRUE)
  
  train_set <- juice(rec)
  validation_set <- bake(rec, assessment(split))
  
  m1_frequency <- glm2::glm2(
    claim_count ~ region + sex + age_range + 
      log_average_insured_amount + log1p_vehicle_age + make + 
      offset(log(exposure)),
    data = train_set,
    family = "poisson",
    control = list(trace = TRUE, maxit = 50)
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
    family = Gamma(link = "log"),
    control = list(trace = TRUE, maxit = 50)
  )
  
  relativities_frequency <- broom::tidy(m1_frequency, exponentiate = TRUE)
  relativities_severity <- broom::tidy(m1_severity, exponentiate = TRUE)
  
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

make_recipe <- function(data, report_year) {
  recipe(data, ~ .) %>%
    step_mutate(
      make = sub(" .*$", "", vehicle_group),
      # TODO try to understand `vehicle_year` of 0 and > 2012
      vehicle_age = pmin(pmax(!!report_year - vehicle_year, 0), 35)
    ) %>%
    step_other(make, threshold = 0.01) %>%
    step_string2factor(region, sex, age_range, vehicle_category) %>%
    step_mutate(
      average_insured_amount = average_insured_amount / 1000,
      region = forcats::fct_explicit_na(region),
      make = forcats::fct_explicit_na(make),
      vehicle_category = forcats::fct_explicit_na(vehicle_category),
      log1p_vehicle_age = log1p(vehicle_age),
      log_average_insured_amount = log(average_insured_amount)
    )
}