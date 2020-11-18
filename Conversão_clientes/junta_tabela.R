library(readxl)
dados_eletronico <- read_excel("C:/Users/Administrador/Downloads/PAE.xlsx")

dados_postos <- read_excel("C:/Users/Administrador/Downloads/POSTOS.xlsx")

dados_agencias <- read_excel("C:/Users/Administrador/Downloads/AGENCIAS.xlsx")

# agrupa por municipio
library(dplyr)
tabela_eletronico <- dados_eletronico %>%
  group_by(MUNICIPIO) %>%
  count()

tabela_postos <- dados_postos %>%
  group_by(MUNICIPIO) %>%
  count()

tabela_agencias <- dados_agencias %>%
  group_by(MUNICIPIO) %>%
  count()

# junta tabelas
library(data.table)
nova_tabela <- rbindlist(list(tabela_agencias,tabela_eletronico,tabela_postos), fill = FALSE) 
tabela_final <- aggregate(. ~MUNICIPIO, data = nova_tabela, FUN = sum)

# transfomando em arquivo excel
library(xlsx)
write.xlsx(tabela_final, "freq_municipio.xls") 