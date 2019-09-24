[![Travis build status](https://travis-ci.org/kasaai/pc-pricing-tutorial.svg?branch=master)](https://travis-ci.org/kasaai/pc-pricing-tutorial)

[Slack](https://slack.kasa.ai) (#pricing-tutorial)

# P&C Pricing Tutorial

The goal of this project is to build an end-to-end reproducible example of a ratemaking project in R, in the form of a book. The target audience includes students, actuaries, and data scientists who are interested in learning about insurance pricing or porting their existing workflows. As much as possible, we'll provide reproducible code for the technical bits, including data manipulation, exploratory data analysis, modeling, validation, implementation, and report writing. Significant simplifications from real life (due to lack of details in the dataset, for example) will be noted. We'll follow modeling best practices, but also point out incorrect/suboptimal workflows that are prevalent.

# Package Dependencies

To install the necessary packages to run the code in this repo, you can restore the library using renv as follows: 

```r
if (!requireNamespace("remotes"))
  install.packages("remotes")

remotes::install_github("rstudio/renv")
renv::restore()
```

## Contributing

Interested in joining in on the fun? Look at the [issues](https://github.com/kasaai/pc-pricing-tutorial/issues) page to see what tasks need help and check out [contributing guidelines](https://github.com/kasaai/pc-pricing-tutorial/blob/master/CONTRIBUTING.md). Not familiar with R but want to lend your actuarial expertise? Please feel free to comment on issues to share your thoughts or open new issues to let us know how we can do things better!

-----

Please note that this project is released with a [Contributor Code of
Conduct](https://github.com/kasaai/quests/blob/master/CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.
