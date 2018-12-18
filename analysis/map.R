library(tidyverse)
library(sf)
library(pricingtutorial)
library(leaflet)

exposures_by_hasc <- risks_table_mapped %>%
  mutate(hasc = paste0("BR.", substr(region, 1, 2))) %>%
  group_by(hasc) %>%
  summarize(exposures = sum(exposure))

bra_layer1 <- sf::st_read("external_data/gadm36_BRA_gpkg/gadm36_BRA.gpkg", layer = "gadm36_BRA_1")

brazil <- bra_layer1 %>%
  left_join(exposures_by_hasc, by = c(HASC_1 = "hasc"))

bins <- c(0, 10^3,10^4, 10^5, 10^6, Inf)
pal <- colorBin("YlOrRd", domain = brazil$exposures, bins = bins)

brazil %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~pal(exposures),
    weight = 2,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 5,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE)
  ) %>%
  setView(lng = -53.034713, lat =  -9.269617, zoom = 4)
