# Gets data from release

download_dir <- file.path("external_data") 
piggyback::pb_download("Autoseg2012B.zip", 
                       repo = "kasaai/pc-pricing-tutorial",
                       dest = download_dir,
                       overwrite = FALSE)

if (!dir.exists("external_data/Autoseg2012B")) {
  unzip(
    file.path(download_dir, "Autoseg2012B.zip"), 
    exdir = file.path(download_dir, "Autoseg2012B")
  )
}
