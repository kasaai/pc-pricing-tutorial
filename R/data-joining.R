library(tidyverse)

read_autoseg <- function(file, col_types = NULL, n_max = Inf, na = c("", "NA")) {
  readr::read_delim(
    file, delim = ";", 
    locale = locale(decimal_mark = ",", encoding = "ISO-8859-1"), 
    col_types = col_types,
    n_max = n_max,
    na = na
  )
}

policy_table <- read_autoseg(
  "data/Autoseg2012B/arq_casco_comp.csv",
  col_types = cols(
    COD_TARIF = col_character(),
    REGIAO = col_character(),
    COD_MODELO = col_character(),
    ANO_MODELO = col_integer(),
    SEXO = col_character(),
    IDADE = col_character(),
    EXPOSICAO1 = col_double(),
    PREMIO1 = col_double(),
    EXPOSICAO2 = col_double(),
    PREMIO2 = col_double(),
    IS_MEDIA = col_double(),
    FREQ_SIN1 = col_double(),
    INDENIZ1 = col_double(),
    FREQ_SIN2 = col_double(),
    INDENIZ2 = col_double(),
    FREQ_SIN3 = col_double(),
    INDENIZ3 = col_double(),
    FREQ_SIN4 = col_double(),
    INDENIZ4 = col_double(),
    FREQ_SIN9 = col_double(),
    INDENIZ9 = col_double(),
    ENVIO = col_character()
  ),
  na = c("", "    ", "0   ")
)

auto_cat <- read_autoseg("data/Autoseg2012B/auto_cat.csv", col_types = "cc") %>%
  rename(
    code = CODIGO,
    vehicle_category = CATEGORIA
  )

auto_reg <- read_autoseg("data/Autoseg2012B/auto_reg.csv") %>%
  rename(
    code = CODIGO,
    region = DESCRICAO
  )

auto2_vei <- read_autoseg("data/Autoseg2012B/auto2_vei.csv") %>%
  rename(
    code = CODIGO,
    make_model = DESCRICAO,
    make = GRUPO,
    make_code = COD_GRUPO
  )

auto_sexo <- read_autoseg("data/Autoseg2012B/auto_sexo.csv") %>%
  rename(
    code = codigo,
    sex = descricao
  )

auto_idade <- read_autoseg("data/Autoseg2012B/auto_idade.csv", col_types = "cc") %>%
  rename(
    code = codigo,
    age_range = descricao
  )

auto_cau <- read_autoseg("data/Autoseg2012B/auto_cau.csv", col_types = "cc")
auto_cob <- read_autoseg("data/Autoseg2012B/auto_cob.csv", col_types = "cc")
auto2_grupo <- read_autoseg("data/Autoseg2012B/auto2_grupo.csv", col_types = "cc")

policy_table %>%
  left_join(auto_cat, by = c(COD_TARIF = "code")) %>%
  left_join(auto_reg, by = c(REGIAO = "code")) %>%
  left_join(auto2_vei, by = c(COD_MODELO = "code")) %>%
  left_join(auto_sexo, by = c(SEXO = "code")) %>%
  
  left_join(auto_idade, by = c(IDADE = "code")) %>%
  rename(
    vehicle_year = ANO_MODELO,
    data_year = ENVIO
  ) %>%
  select(-COD_TARIF, -REGIAO, -COD_MODELO, -SEXO, -IDADE) %>%
  mutate_if(is.character, trimws) %>%
  glimpse()
