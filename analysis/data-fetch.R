
library(tidyverse)
library(fs)
library(glue)

url_pattern <- "http://www2.susep.gov.br/redarq.asp?arq=Autoseg{year}{half}%2ezip"

download_params <- tibble(year = c(2013, 2013), half = c("A", "B"))

download_urls <- glue::glue_data(.x = download_params, url_pattern)

download_dir <- path(here::here(), "external_data") 

if(!dir.exists(download_dir)) {
  
  dir.create(download_dir)

} 

download_file <- function(x, dest_dir, keep_zip = FALSE) {
  
  dest_file <- str_extract(URLdecode(x), pattern = "(?<==).+$")
  full_path <- path(dest_dir, dest_file)
  exdir_path <-  str_extract(full_path, pattern = ".*?(?=\\.zip$)")
  
  if (file_exists(full_path) || dir_exists(exdir_path)) {
    data_dir <- str_extract(dest_file, pattern = ".*?(?=\\.zip$)")
    message(glue("{data_dir} data already downloaded"))
    return(NULL)
  
  }
  
  download.file(x, destfile = full_path)
  unzip(full_path, exdir = exdir_path)
  
  if (!keep_zip) {
  
    file_delete(full_path)
    
  }
}

walk(download_urls, download_file, dest_dir = download_dir)

#list.files(download_dir, pattern = "\\.*zip$", full.names = "TRUE") %>% 
#  walk(~ unzip(.x, exdir = str_extract(.x, pattern = ".*?(?=\\.zip$)")))
