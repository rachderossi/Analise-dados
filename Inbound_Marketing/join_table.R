library(readxl)
dados_eletronico <- read_excel("C:/Users/Administrador/Desktop/Conversão_clientes/PAE.xlsx") # change

dados_postos <- read_excel("C:/Users/Administrador/Desktop/Conversão_clientes/POSTOS.xlsx") # change

dados_agencias <- read_excel("C:/Users/Administrador/Desktop/Conversão_clientes/AGENCIAS.xlsx") # change

# agrupa por município
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

# join 
library(data.table)
nova_tabela <- rbindlist(list(tabela_agencias,tabela_eletronico,tabela_postos), fill = FALSE) 
tabela_final <- aggregate(. ~MUNICIPIO, data = nova_tabela, FUN = sum)

# arquivo excel
library(xlsx)
write.xlsx(tabela_final, "freq_municipio.xls") 
