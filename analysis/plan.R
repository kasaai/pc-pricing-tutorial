data_dir <- fs::path(here::here(), "external_data", "Autoseg2012B")

plan <- drake_plan(
  raw_data_excerpts = read_raw_data_excerpts(data_dir),
  raw_data = read_raw_data(data_dir),
  modeling_data = prep_modeling_data(raw_data),
  # Perform initial split into training and testing/holdout
  splits = rsample::initial_split(modeling_data, prop = 4 / 5),
  training_data = rsample::training(splits),
  book = callr::r(
    function(...) bookdown::render_book(...),
    args = list(
      input = drake::knitr_in("index.Rmd"),
      output_format = "bookdown::gitbook",
      quiet = TRUE
    )
  )
)