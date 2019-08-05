source("analysis/utils.R")
library(tidyverse)

# Read the main policy table,
#  specifying column types explicitly.
risks_table <- read_autoseg(
  "external_data/Autoseg2012B/arq_casco_comp.csv",
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
  # ANO_MODELO contains these invalid values which we treat as NA
  na = c("", "    ", "0   ")
)

auto_cat <- read_autoseg("external_data/Autoseg2012B/auto_cat.csv", col_types = "cc")
auto_reg <- read_autoseg("external_data/Autoseg2012B/auto_reg.csv", col_types = "cc")
auto2_vei <- read_autoseg("external_data/Autoseg2012B/auto2_vei.csv", col_types = "cccc")
auto_sexo <- read_autoseg("external_data/Autoseg2012B/auto_sexo.csv", col_types = "cc")
auto_idade <- read_autoseg("external_data/Autoseg2012B/auto_idade.csv", col_types = "cc")
auto_cau <- read_autoseg("external_data/Autoseg2012B/auto_cau.csv", col_types = "cc")
auto2_grupo <- read_autoseg("external_data/Autoseg2012B/auto2_grupo.csv", col_types = "cc")

# Translations

auto_cat <- auto_cat %>%
  rename(
    vehicle_category_code = CODIGO,
    vehicle_category = CATEGORIA
  )

auto_reg <- auto_reg %>%
  rename(
    region_code = CODIGO,
    region = DESCRICAO
  )

auto2_vei <- auto2_vei %>%
  rename(
    vehicle_code = CODIGO,
    vehicle_description = DESCRICAO,
    vehicle_group = GRUPO,
    vehicle_group_code = COD_GRUPO
  )

auto_sexo <- auto_sexo %>%
  rename(
    sex_code = codigo,
    sex = descricao
  )

auto_idade <- auto_idade %>%
  rename(
    age_code = codigo,
    age_range = descricao
  )

auto_cau <- auto_cau %>%
  rename(
    peril_code = CODIGO,
    peril = CAUSA
  )

auto2_grupo <- auto2_grupo %>%
  rename(vehicle_group_code = grpid,
         vehicle_group_description = descricao
  )

risks_table <- risks_table %>%
  rename(
    vehicle_category_code = COD_TARIF,
    region_code = REGIAO,
    vehicle_code = COD_MODELO,
    sex_code = SEXO,
    age_code = IDADE,
    vehicle_year = ANO_MODELO,
    data_year = ENVIO,
    exposure = EXPOSICAO1,
    premium = PREMIO1,
    average_insured_amount = IS_MEDIA
  ) %>%
  rename_at(
    # Translate count/amount and perils
    vars(matches("^(FREQ_SIN|INDENIZ)")),
    function(x) {
      str_split(x, "(?=[0-9])") %>%
        map_chr(function(splitted) {
          value_type <- if (splitted[[1]] == "FREQ_SIN") "claim_count" else "claim_amount"
          peril <- switch(
            splitted[[2]],
            "1" = "theft",
            "2" = "collision_partial",
            "3" = "collision_total_loss",
            "4" = "fire",
            "9" = "other"
          )
          paste(value_type, peril, sep = "_")
        })
    }
  ) %>% 
  # Remove unused columns
  select(-EXPOSICAO2, -PREMIO2)


# Joins

risks_table_mapped <- risks_table %>%
  left_join(auto_cat, by = "vehicle_category_code") %>%
  left_join(auto_reg, by = "region_code") %>%
  left_join(auto2_vei, by = "vehicle_code") %>%
  left_join(auto_sexo, by = "sex_code") %>%
  left_join(auto_idade, by = "age_code") %>%
  left_join(auto2_grupo, by = "vehicle_group_code") %>%
  select(-ends_with("_code")) %>%
  mutate_if(is.character, trimws)

modeling_data <- risks_table_mapped %>% 
  filter(
    # See https://github.com/kasaai/pc-pricing-tutorial/issues/88
    vehicle_category %in% c(
      "Passeio importado",
      "Passeio nacional",
      "Pick-up (nacional e importado)"
    ),
    # This filters out "Jurídica" which means "enterprise/legal"
    sex %in% c("Feminino", "Masculino"),
    # See https://github.com/kasaai/pc-pricing-tutorial/issues/89
    average_insured_amount > 0
  ) %>% 
  # Response variables, aggregate all perils
  mutate(
    claim_count = rowSums(select(., starts_with("claim_count_"))),
    claim_amount = rowSums(select(., starts_with("claim_amount_")))
  ) %>% 
  select(-starts_with("claim_count_"), -starts_with("claim_amount_"))