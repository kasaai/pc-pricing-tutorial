library(recipes)

report_year <- 2012

rec <- recipe(risks_table_mapped, ~ .) %>%
  step_mutate(
    make = sub(" .*$", "", vehicle_group),
    # TODO try to understand `vehicle_year` of 0 and > 2012
    vehicle_age = pmin(pmax(!!report_year - vehicle_year, 0), 35)
  ) %>%
  step_other(make, threshold = 0.01) %>%
  step_string2factor(region, sex, age_range, vehicle_category) %>%
  step_mutate(
    region = fct_explicit_na(region),
    make = fct_explicit_na(make),
    exposure = exposure + 0.5 # see #81
  ) %>% 
  prep(risks_table_mapped, strings_as_factors = FALSE, retain = FALSE)

modeling_data <- bake(rec, risks_table_mapped) %>%
  mutate_at(c("region", "make", "vehicle_category"), fct_explicit_na) %>%
  group_by(region, sex, age_range, vehicle_age, make, vehicle_category) %>% 
  # Add up exposures, claim counts, and claim amounts
  summarize_at(vars(starts_with("claim_count"), starts_with("claim_amount"), "exposure"), sum) %>%
  ungroup() %>%
  # Aggregate all perils
  gather("variable", "value", starts_with("claim_count"), starts_with("claim_amount")) %>% 
  extract(variable, c("variable"), "(claim_count|claim_amount)") %>%
  group_by(region, sex, age_range, vehicle_age, make, vehicle_category, variable, exposure) %>%
  summarize(value = sum(value)) %>%
  spread(variable, value)

