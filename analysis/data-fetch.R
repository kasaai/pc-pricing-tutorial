
library(tidyverse)
library(fs)
library(pricingtutorial)


download_dir <- path(here::here(), "external_data") 

time_periods <- c("2012B", "2013A")

download_data(time_periods, download_dir)

