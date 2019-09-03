### Contributing

**Please drop by the `#pc-pricing-tutorial` channel in Slack ([slack.kasa.ai](https://slack.kasa.ai)) if you have questions about these instructions, and feel free to suggest improvements.**

The book is written using [bookdown](https://bookdown.org/) and the workflow is managed using [drake](https://docs.ropensci.org/drake/). Before attempting to build the book, you want to make sure 1) you have the raw data files, and 2) you have the correct packages installed. The data files can be obtained by running the `analysis/data-fetch.R` script. To install the packages, you can utilize [renv](https://rstudio.github.io/renv/):

```r
if (!requireNamespace("remotes"))
  install.packages("remotes")

remotes::install_github("rstudio/renv")
renv::restore()
```

Then, you can source the `make.R` script to build the book.

Each chapter of the book has an `.Rmd` file associated with it which contains prose. When proposing changes, you'll need to make sure dependencies are properly created in the drake plan in `analysis/plan.R`. The way to declare data dependencies for the `book` target is to include `drake::loadd()` or `drake::readd()` calls in `index.Rmd`; this ensures that the necessary objects are created before we try to render the book.

The latest preview draft of the book is available at [ratemake.com](https://ratemake.com) which is continuously deployed from `master`. Currently, there are no previs for PRs, but Travis should pass before merging.

### Style

New code should follow the tidyverse [style guide](http://style.tidyverse.org).

### New to Git/GitHub?

Check out [http://happygitwithr.com/](http://happygitwithr.com/). Also feel free to ask questions in Slack at [slack.kasa.ai](https://slack.kasa.ai).