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

auto2_vei <- read_autoseg("data/Autoseg2012B/auto2_vei.csv", col_types = "cccc") %>%
  rename(
    code = CODIGO,
    model_details = DESCRICAO,
    model = GRUPO,
    vehicle_group_code = COD_GRUPO
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

auto_cau <- read_autoseg("data/Autoseg2012B/auto_cau.csv", col_types = "cc") %>%
  rename(
    code = CODIGO,
    cause = CAUSA
  )

auto2_grupo <- read_autoseg("data/Autoseg2012B/auto2_grupo.csv", col_types = "cc") %>%
  rename(vehicle_group_code = grpid,
         vehicle_group_description = descricao
  )

policy_table_mapped <- policy_table %>%
  left_join(auto_cat, by = c(COD_TARIF = "code")) %>%
  left_join(auto_reg, by = c(REGIAO = "code")) %>%
  left_join(auto2_vei, by = c(COD_MODELO = "code")) %>%
  left_join(auto_sexo, by = c(SEXO = "code")) %>%
  left_join(auto_idade, by = c(IDADE = "code")) %>%
  rename(
    vehicle_year = ANO_MODELO,
    data_year = ENVIO,
    exposure = EXPOSICAO1,
    premium = PREMIO1
  ) %>%
  select(
    # stuff we mapped
    -COD_TARIF, -REGIAO, -COD_MODELO, -SEXO, -IDADE, -vehicle_group_code,
    # stuff we don't need
    -EXPOSICAO2, -PREMIO2, -IS_MEDIA,
  ) %>%
  rename_at(
    vars(matches("^(FREQ_SIN|INDENIZ)")),
    function(x) {
      str_split(x, "(?=[0-9])") %>%
        map_chr(function(splitted) {
          value_type <- if (splitted[[1]] == "FREQ_SIN") "claim_count" else "claim_amount"
          cause <- switch(
            splitted[[2]],
            "1" = "theft",
            "2" = "collision_partial",
            "3" = "collision_total_loss",
            "4" = "fire",
            "9" = "other"
          )
          paste(value_type, cause, sep = "_")
        })
    }
  ) %>%
  mutate_if(is.character, trimws)
