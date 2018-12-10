Polygon Mapping
================

``` r
library(tidyverse)
library(sf)
library(pricingtutorial)

auto_reg <- read_autoseg("external_data/Autoseg2012B/auto_reg.csv")

bra_layer1 <- sf::st_read("external_data/gadm36_BRA_gpkg/gadm36_BRA.gpkg", layer = "gadm36_BRA_1")
```

    ## Reading layer `gadm36_BRA_1' from data source `/Users/kevinykuo/Dropbox/Projects/pc-pricing-tutorial/external_data/gadm36_BRA_gpkg/gadm36_BRA.gpkg' using driver `GPKG'
    ## Simple feature collection with 27 features and 10 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: -73.98971 ymin: -33.74708 xmax: -28.84694 ymax: 5.264878
    ## epsg (SRID):    4326
    ## proj4string:    +proj=longlat +datum=WGS84 +no_defs

``` r
state_mapping <- data_frame(hasc = as.character(bra_layer1$HASC_1)) %>%
  left_join(
    auto_reg %>%
      mutate(hasc = paste0("BR.", substr(DESCRICAO, 1, 2))),
    by = "hasc"
  )

state_mapping
```

    ## # A tibble: 41 x 3
    ##    hasc  CODIGO DESCRICAO            
    ##    <chr> <chr>  <chr>                
    ##  1 BR.AC 35     AC - Acre            
    ##  2 BR.AL 26     AL - Alagoas         
    ##  3 BR.AP 32     AP - Amapá           
    ##  4 BR.AM 31     AM - Amazonas        
    ##  5 BR.BA 21     BA - Bahia           
    ##  6 BR.CE 27     CE - Ceará           
    ##  7 BR.DF 38     DF - Brasília        
    ##  8 BR.ES 20     ES - Espírito Santo  
    ##  9 BR.GO 39     GO - Goiás           
    ## 10 BR.GO 41     GO - Sudeste de Goiás
    ## # ... with 31 more rows
