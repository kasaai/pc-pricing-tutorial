# Gets data from release

download_dir <- path(here::here(), "external_data") 
piggyback::pb_download("Autoseg2012B.zip", dest = download_dir)

unzip(
  file.path(download_dir, "Autoseg2012B.zip"), 
  exdir = file.path(download_dir, "Autoseg2012B")
)


