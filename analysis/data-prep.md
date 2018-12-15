Data Prep
================
2018-12-07

This document keeps track of ongoing efforts to understand the datasets.
We’ll update this as we go along.

## Access

The data can be downloaded from
<http://www2.susep.gov.br/menuestatistica/Autoseg/principal.aspx>. We’ll
be using the first half of 2012 to start, since that’s the first time
period where CSVs (as opposed to MS Access files) are available. The
convention we’ll use in this repo is that we’ll put the uncompressed
directory in `data/`, so the path to a file would be, for example,
`data/Autoseg2012B/arq_casco_comp.csv`. The uncompressed directory
contains the following files:

    Autoseg2012B/
    ├── AjudaAutoseg.chm
    ├── PremReg.csv
    ├── SinReg.csv
    ├── arq_casco3_comp.csv
    ├── arq_casco4_comp.csv
    ├── arq_casco_comp.csv
    ├── auto2_grupo.csv
    ├── auto2_vei.csv
    ├── auto_cat.csv
    ├── auto_cau.csv
    ├── auto_cep.csv
    ├── auto_cidade.csv
    ├── auto_cob.csv
    ├── auto_idade.csv
    ├── auto_reg.csv
    └── auto_sexo.csv

From the documentation and Google Translate we have

    Description of tables:
    Main Tables:
    arq_casco - contains exposure data, premiums, claims and insured amount for the CASCO overhead, classified by the Key Category Rate / Region / Model / Year / Sex / Age Range;
    arq_casco3 - contains exposure data, premiums and claims for the CASCO overhang, classified by the Key Rate Category / CEP / Model / Year key;
    arq_casco4 - contains exposure data, premiums and claims for the CASCO overhang, classified by the Key Rate Category / City / Model / Year;
    premreg - regional distribution of prizes; and
    sinreg - regional distribution of claims.
    Auxiliary Tables:
    auto2_vei - contains FIPE code and description of each vehicle model, in addition to the group code to which it belongs;
    auto2_group - code and description of model groups;
    auto_cat - description code of tariff categories;
    auto_cau - code and description of causes of accidents;
    auto_cep - correlates the CEP with cities and regions of circulation;
    auto_cob - code and description of covers;
    auto_idade - code and description of age groups;
    auto_reg - code and description of regions of circulation;
    auto_sexo - code and description of sex (male, female, legal); and
    auto_city - code and name of cities.

## Policies table

According to the dataset documentation, we’ll want to use
`arq_casco_comp.csv` since it’s the only one with any policyholder
characteristics. The first few lines of the table
    are

    ## [1] "COD_TARIF;REGIAO;COD_MODELO;ANO_MODELO;SEXO;IDADE;EXPOSICAO1;PREMIO1;EXPOSICAO2;PREMIO2;IS_MEDIA;FREQ_SIN1;INDENIZ1;FREQ_SIN2;INDENIZ2;FREQ_SIN3;INDENIZ3;FREQ_SIN4;INDENIZ4;FREQ_SIN9;INDENIZ9;ENVIO"
    ## [2] "1;04;004227-7;2005;M;1;0,479452066123486;1300,90734863281;0;0;18179,4684634343;0;0;0;0;0;0;0;0;0;0;2012B"                                                                                             
    ## [3] "1;04;004227-7;2005;M;2;0,556164383888245;315,80322265625;0;0;17955,1573819861;0;0;0;0;0;0;0;0;0;0;2012B"                                                                                              
    ## [4] "1;04;004227-7;2005;M;3;0,895890414714813;370,79118347168;0;0;17753,8408586194;0;0;0;0;0;0;0;0;0;0;2012B"

We’ll need to understand what each column means before we can properly
ingest the data.

## Mapping tables

The data bundle also comes with many auxiliary tables which we’ll need
for mapping the codes in the policy dataset. Below are excerpts of each
of the tables.

### auto\_cat

| CODIGO | CATEGORIA                               |
| -----: | :-------------------------------------- |
|      1 | Passeio nacional                        |
|      2 | Passeio importado                       |
|      3 | Pick-up (nacional e importado)          |
|      4 | Veículo de Carga (nacional e importado) |
|      5 | Motocicleta (nacional e importado)      |
|      6 | Ônibus (nacional e importado)           |
|      7 | Utilitários (nacional e importado)      |
|      9 | Outros                                  |

### auto\_cau

| CODIGO | CAUSA               |
| -----: | :------------------ |
|      1 | Roubo ou furto      |
|      2 | Colisão parcial     |
|      3 | Colisão Perda Total |
|      4 | Incêndio            |
|      9 | Outros              |

### auto\_cep

| REGSUSEP | CEPINICIAL | CIDADE          | CEP\_FINAL | CODREG | REGDECIRC                     | cepini | cepfim |
| :------- | ---------: | :-------------- | ---------: | -----: | :---------------------------- | -----: | -----: |
| 01       |      90010 | PORTO ALEGRE    |      91920 |      1 | METROPOLITANA DE PORTO ALEGRE |  90010 |  91920 |
| 01       |      92010 | CANOAS          |      92420 |      1 | METROPOLITANA DE PORTO ALEGRE |  92010 |  92420 |
| 01       |      92500 | GUAÍBA          |      92849 |      1 | METROPOLITANA DE PORTO ALEGRE |  92500 |  92849 |
| 01       |      92990 | ELDORADO        |      92999 |      1 | METROPOLITANA DE PORTO ALEGRE |  92990 |  92999 |
| 01       |      93010 | SÃO LEOPOLDO    |      93150 |      1 | METROPOLITANA DE PORTO ALEGRE |  93010 |  93150 |
| 01       |      93180 | PORTÃO          |      93199 |      1 | METROPOLITANA DE PORTO ALEGRE |  93180 |  93199 |
| 01       |      93210 | SAPUCAIA DO SUL |      93230 |      1 | METROPOLITANA DE PORTO ALEGRE |  93210 |  93230 |
| 01       |      93260 | ESTEIO          |      93295 |      1 | METROPOLITANA DE PORTO ALEGRE |  93260 |  93295 |
| 01       |      93310 | NOVO HAMBURGO   |      93548 |      1 | METROPOLITANA DE PORTO ALEGRE |  93310 |  93548 |
| 01       |      93600 | ESTÂNCIA VELHA  |      93699 |      1 | METROPOLITANA DE PORTO ALEGRE |  93600 |  93699 |

### auto\_cidade

| CIDADE              | CODIGO |
| :------------------ | -----: |
| ABADIA DOS DOURADOS |      1 |
| ABADIANIA           |      2 |
| ABAETE              |      3 |
| ABAIARA             |      4 |
| ABAIRA              |      5 |
| ABARE               |      6 |
| ABATIA              |      7 |
| ABDON BATISTA       |      8 |
| ABELARDO LUZ        |      9 |
| ABRE CAMPO          |     10 |

### auto\_cob

| CODIGO | COBERTURA                |
| -----: | :----------------------- |
|      1 | Compreensiva             |
|      2 | Incêndio e roubo         |
|      3 | Incêndio                 |
|      4 | Exclusiva de Perda total |
|      9 | Outros                   |

### auto\_idade

| codigo | descricao          |
| -----: | :----------------- |
|      0 | Não informada      |
|      1 | Entre 18 e 25 anos |
|      2 | Entre 26 e 35 anos |
|      3 | Entre 36 e 45 anos |
|      4 | Entre 46 e 55 anos |
|      5 | Maior que 55 anos  |

### auto\_reg

| CODIGO | DESCRICAO                                |
| :----- | :--------------------------------------- |
| 01     | RS - Met. Porto Alegre e Caxias do Sul   |
| 02     | RS - Demais regiões                      |
| 03     | SC - Met. Florianópolis e Sul            |
| 04     | SC - Oeste                               |
| 05     | SC - Blumenau e demais regiões           |
| 06     | PR - F.Iguaþu-Medianeira-Cascavel-Toledo |
| 07     | PR - Met. Curitiba                       |
| 08     | PR - Demais regiões                      |
| 09     | SP - Vale do Paraíba e Ribeira           |
| 10     | SP - Litoral Norte e Baixada Santista    |

### auto\_sexo

| codigo | descricao      |
| :----- | :------------- |
| M      | Masculino      |
| F      | Feminino       |
| J      | Jurídica       |
| 0      | Sem Informação |

### auto2\_grupo

| grpid | descricao                |
| ----: | :----------------------- |
|     1 | ACURA                    |
|     2 | ADLY MOTOS - TODAS       |
|     3 | AGRALE - MARRUÁ          |
|     4 | AGRALE CAMINHOES - TODOS |
|     5 | AGRALE MOTOS - TODAS     |
|     6 | ALFA ROMEO 145           |
|     7 | ALFA ROMEO 147           |
|     8 | ALFA ROMEO 155           |
|     9 | ALFA ROMEO 156           |
|    10 | ALFA ROMEO 164           |

### auto2\_vei

| CODIGO   | DESCRICAO                                      | GRUPO              | COD\_GRUPO |
| :------- | :--------------------------------------------- | :----------------- | ---------: |
| 007017-3 | Asia Motors - Hi-Topic Van 2.7 Diesel (furgão) | ASIA MOTORS TOPIC  |         17 |
| 007020-3 | Asia Motors - Jipe Rocsta GT 4x4 2.2 Diesel    | ASIA MOTORS JIPE   |         16 |
| 007016-5 | Asia Motors - Topic Carga 2.7 Diesel (furgão)  | ASIA MOTORS TOPIC  |         17 |
| 007014-9 | Asia Motors - Topic Luxo Diesel                | ASIA MOTORS TOPIC  |         17 |
| 007015-7 | Asia Motors - Topic Super Luxo Diesel          | ASIA MOTORS TOPIC  |         17 |
| 007003-3 | Asia Motors - Towner Coach Full                | ASIA MOTORS TOWNER |         18 |
| 007009-2 | Asia Motors - Towner Furgão                    | ASIA MOTORS TOWNER |         18 |
| 007004-1 | Asia Motors - Towner Glass Van                 | ASIA MOTORS TOWNER |         18 |
| 007012-2 | Asia Motors - Towner Luxo                      | ASIA MOTORS TOWNER |         18 |
| 007011-4 | Asia Motors - Towner Multiuso 5p               | ASIA MOTORS TOWNER |         18 |
