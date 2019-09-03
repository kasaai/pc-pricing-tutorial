read_raw_data_excerpts <- function(data_dir) {
  arq_casco_comp <- read_excerpt(
    tbl = "arq_casco_comp", data_dir = data_dir
  )
  
  arq_casco3_comp <- read_excerpt(
    tbl = "arq_casco3_comp", data_dir = data_dir
  )
  
  arq_casco4_comp <- read_excerpt(
    tbl = "arq_casco4_comp", data_dir = data_dir
  )
  
  premreg <- read_excerpt(
    tbl = "PremReg", data_dir = data_dir
  )
  
  sinreg <- read_excerpt(
    tbl = "SinReg", data_dir = data_dir
  )
  
  list(
    arq_casco_comp = arq_casco_comp,
    arq_casco3_comp = arq_casco3_comp,
    arq_casco4_comp = arq_casco4_comp,
    premreg = premreg,
    sinreg = sinreg
  )
}

read_raw_data <- function(data_dir) {
  auto_cat <- read_autoseg(
    path(data_dir, "auto_cat.csv"),
    col_types = "cc",
  ) %>% 
    rename(
      vehicle_category_code = CODIGO,
      vehicle_category = CATEGORIA
    )
  
  auto_cau <- read_autoseg(
    path(data_dir, "auto_cau.csv"),
    col_types = "cc"
    ) %>% 
    rename(
      peril_code = CODIGO,
      peril = CAUSA
    )
  
  auto_cep <- read_autoseg(
    path(data_dir,"auto_cep.csv")
  )
  
  
  auto_cidade <- read_autoseg(
    path(data_dir,"auto_cidade.csv")
  )
  auto_cob <- read_autoseg(
    path(data_dir,"auto_cob.csv")
  )
  
  auto_idade <- read_autoseg(
    path(data_dir,"auto_idade.csv"),
    col_types = "cc"
  ) %>% 
    rename(
      age_code = codigo,
      age_range = descricao
    )
  
  auto_reg <- read_autoseg(
    path(data_dir,"auto_reg.csv"),
    col_types = "cc"
    ) %>% 
    rename(
      region_code = CODIGO,
      region = DESCRICAO
    )
  
  auto_sexo <- read_autoseg(
    path(data_dir,"auto_sexo.csv"),
    col_types = "cc"
    ) %>% 
    rename(
      sex_code = codigo,
      sex = descricao
    )
  
  auto2_grupo <- read_autoseg(
    path(data_dir,"auto2_grupo.csv"),
    col_types = "cc"
    ) %>% 
    rename(vehicle_group_code = grpid,
           vehicle_group_description = descricao
    )
    
  auto2_vei <- read_autoseg(
    path(data_dir,"auto2_vei.csv"),
    col_types = "cccc"
  ) %>% 
    rename(
      vehicle_code = CODIGO,
      vehicle_description = DESCRICAO,
      vehicle_group = GRUPO,
      vehicle_group_code = COD_GRUPO
    )
  
  risks_table <- read_autoseg(
    path(data_dir, "arq_casco_comp.csv"),
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
  ) %>%
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
    ) 
  
  list(
    auto_cat = auto_cat,
    auto_cau = auto_cau,
    auto_cep = auto_cep,
    auto_cidade = auto_cidade,
    auto_cob = auto_cob,
    auto_idade = auto_idade,
    auto_reg = auto_reg,
    auto_sexo = auto_sexo,
    auto2_grupo = auto2_grupo,
    auto2_vei = auto2_vei,
    risks_table = risks_table
  )
}

prep_modeling_data <- function(raw_data) {
  risks_table_mapped <- raw_data$risks_table %>%
    left_join(raw_data$auto_cat, by = "vehicle_category_code") %>%
    left_join(raw_data$auto_reg, by = "region_code") %>%
    left_join(raw_data$auto2_vei, by = "vehicle_code") %>%
    left_join(raw_data$auto_sexo, by = "sex_code") %>%
    left_join(raw_data$auto_idade, by = "age_code") %>%
    left_join(raw_data$auto2_grupo, by = "vehicle_group_code") %>%
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
    select(-starts_with("claim_count_"), -starts_with("claim_amount_")) %>% 
    mutate(exposure = exposure + 0.5, # see #81
           loss_per_exposure = claim_amount / exposure)
  
  modeling_data
}