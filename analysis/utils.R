#' Read Autoseg File
#' 
#' @param file Path to file.
#' @param ... Additional arguments passed to `readr::read_delim()`.
#' @export
read_autoseg <- function(file, ...) {
  vroom::vroom(
    file, delim = ";", 
    locale = vroom::locale(decimal_mark = ",", encoding = "ISO-8859-1"), 
    ...
  )
}

#' Download AutoSeg Data
#'
#' @param periods a character vector of time periods to download 
#' @param dest_dir a folder to save downloaded data to. Will be created if
#' folder does not exist 
#' @param keep_zip if FALSE (default) the downloaded zip files are deleted after
#' they are uncompressed
#'
#' @export
download_data <- function(periods, dest_dir, keep_zip = FALSE) {
  
  if(!fs::dir_exists(dest_dir)) {
    
    fs::dir_create(dest_dir)
    
  }
  
  url_pattern <- "http://www2.susep.gov.br/redarq.asp?arq=Autoseg{period}%2ezip"
  
  download_params <- tibble::tibble(period = periods)
  
  download_urls <- glue::glue_data(.x = download_params, url_pattern)
  
  purrr::walk(download_urls, 
              download_file, 
              dest_dir = dest_dir, 
              keep_zip = keep_zip)  
  
}


#' Download Aut0Seg File from URL
#'
#' @param x url to download the file from
#' @param dest_dir folder to save downloaded file to
#' @param keep_zip if FALSE (default) the downloaded zip file will be deleted
#' after it has been uncompressed
#'
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