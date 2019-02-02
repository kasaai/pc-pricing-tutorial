
library(tidyverse)
library(fs)

#download_dir <- tempdir()

url_pattern <- "http://www2.susep.gov.br/redarq.asp?arq=Autoseg{year}{half}%2ezip"

download_params <- tibble(year = 2012, half = c("B"))

download_urls <- glue::glue_data(.x = download_params, url_pattern)

download_dir <- path(here::here(), "external_data") 

if(!dir.exists(download_dir)) {
  
  dir.create(download_dir)

}

download_file <- function(x, dest_dir) {
  
  dest_file <- str_extract(URLdecode(x), pattern = "(?<==).+$")
  download.file(x, destfile = path(dest_dir, dest_file))
}

walk(download_urls, download_file, dest_dir = download_dir)

list.files(download_dir, pattern = "\\.*zip$", full.names = "TRUE") %>% 
  walk(~ unzip(.x, exdir = str_extract(.x, pattern = ".*?(?=\\.zip$)")))
