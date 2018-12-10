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