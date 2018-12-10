### Style

New code should follow the tidyverse [style guide](http://style.tidyverse.org).

### Analysis writeup

If you decide to use RMarkdown for a specific task, put the `.Rmd` souce in `analysis/`, use `github_document` as the output (if it doesn't have interactive visualizations), and select  "Knit from directory." The `.md` files generated can then be previewed on GitHub.

### Helper functions

If you define reusable functions in your analysis workflow, it is recommended that you include them in the **pricingtutorial** companion package, which also lives in this repo. Add the functions to `R/` and document them appropriately, and include tests as appropriate. See [R Packages](http://r-pkgs.had.co.nz/) for more information on R packages.

### Changes to article

The latest version of the tutorial is hosted at [https://pricing-tutorial.netlify.com/](https://pricing-tutorial.netlify.com/). To make changes:

1. Fork the repo and create a new branch.
2. Modify `manuscript/article.Rmd`.
3. Run the build script `manuscript/build_article_preview.R`.
4. If you're happy with what you see in `manuscript/public/index.html`, send a PR.

Once the PR is created, a preview version should be deployed and you'll be able to see it in the build details.

### New to Git/GitHub?

Check out [http://happygitwithr.com/](http://happygitwithr.com/). Also feel free to ask questions in the [gitter channel](https://gitter.im/kasa-official/pc-pricing-tutorial).