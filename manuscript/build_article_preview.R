rmarkdown::render(
  "manuscript/article.Rmd", 
  output_file = "index.html", 
  output_dir = "manuscript/public"
)
invisible(file.copy("manuscript/static/index.js", "manuscript/public/index_files/index.js", overwrite = TRUE))
invisible(file.copy("manuscript/static/styles.css", "manuscript/public/index_files/styles.css", overwrite = TRUE))