if (!require("readr"))              install.packages("readr")
if (!require("plyr"))               install.packages("plyr")
if (!require("scales"))             install.packages("scales")
if (!require("ggplot2"))            install.packages("ggplot2")
if (!require("table1"))             install.packages("table1")
if (!require("DescTools"))          install.packages("DescTools")
if (!require("summarytools"))       install.packages("summarytools")
if (!require("magrittr"))           install.packages("magrittr") 
if (!require("knitr"))              install.packages("knitr")
if (!require("questionr"))          install.packages("questionr")
if (!require("dplyr"))              install.packages("dplyr")
if (!require("hrbrthemes"))         install.packages("hrbrthemes")
if (!require("tidyr"))              install.packages("tidyr")
if (!require("stringr"))            install.packages("stringr")
if (!require("plm"))                install.packages("plm")
if (!require("GGally"))             install.packages("GGally")
if (!require("caret"))              install.packages("caret")
if (!require("car"))                install.packages("car")

# Abrindo as bases de dados
mod <- read_csv("dados_mod_final.csv", col_types = cols(
  pais = col_character(),
  sigla = col_character(),
  regiao = col_character(),
  ano = col_character(),
  mortes = col_double(),
  democracia = col_double(),
  pib = col_double(),
  populacao = col_double(),
  despesas = col_double(),
  variavel_dependente = col_double()
)) 

mod$populacao <- scale(mod$populacao)

# Remover linhas com NA em qualquer coluna
dados_ols_sem_na <- na.omit(mod)

modelo_ols <- subset(dados_ols_sem_na, select = c(variavel_dependente, mortes, democracia, 
                                                  pib, populacao, despesas, pais,regiao, ano))

modelo_ols$dummy <- ifelse(modelo_ols$variavel_dependente == 1, 1, 0)

# Ajustar o modelo ols com efeitos fixos de tempo
ols <- plm(dummy ~ mortes + democracia + populacao,  
           data = modelo_ols, index = c("regiao", "ano"), model = "within")

summary(ols)
summary(fixef(ols))


# Ajustar o modelo gls com efeitos aleatórios de tempo
gls <- plm(dummy ~ mortes + democracia +  populacao, 
           data = modelo_ols, index = c("regiao", "ano"), model = "random")

summary(gls)

# Comparar os resultados
phtest(ols,gls)