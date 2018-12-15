Raw Table Excerpts
================
2018-12-14

## Auxiliary tables

Excerpts of auxiliary tables are provided below.

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
