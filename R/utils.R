#' Read Autoseg File
#' 
#' @param file Path to file.
#' @param ... Additional arguments passed to `readr::read_delim()`.
#' @export
read_autoseg <- function(file, ...) {
  readr::read_delim(
    file, delim = ";", 
    locale = readr::locale(decimal_mark = ",", encoding = "ISO-8859-1"), 
    ...
  )
}

download_data <- function(periods, dest_dir) {

  if(!fs::dir_exists(dest_dir)) {
    
    fs::dir_create(dest_dir)
    
  }
  
  url_pattern <- "http://www2.susep.gov.br/redarq.asp?arq=Autoseg{period}%2ezip"
  
  download_params <- tibble::tibble(period = periods)
  
  download_urls <- glue::glue_data(.x = download_params, url_pattern)
  
  purrr::walk(download_urls, download_file, dest_dir = dest_dir)  
  
}

download_file <- function(x, dest_dir, keep_zip = FALSE) {
  
  dest_file <- stringr::str_extract(URLdecode(x), pattern = "(?<==).+$")
  full_path <- fs::path(dest_dir, dest_file)
  exdir_path <-  stringr::str_extract(full_path, pattern = ".*?(?=\\.zip$)")
  
  if (fs::file_exists(full_path) || fs::dir_exists(exdir_path)) {
    data_dir <- stringr::str_extract(dest_file, pattern = ".*?(?=\\.zip$)")
    message(glue("{data_dir} data already downloaded"))
    return(NULL)
  
  }
  
  download.file(x, destfile = full_path)
  unzip(full_path, exdir = exdir_path)
  
  if (!keep_zip) {
  
    fs::file_delete(full_path)
    
  }
}