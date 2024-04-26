library(readxl)
freq_municipio <- read_excel("freq_municipio.xls")
freq_municipio$X = NULL

populacao <-  read_excel("pop.xlsx", col_types = c("text", "text", "numeric"))

IDHM <- read_excel("IDHM.xlsx")

library(tidyverse)
library(magrittr)

# converte para maiúscula
populacao %<>% 
  mutate_if(is.character, toupper)

IDHM %<>% 
  mutate_if(is.character, toupper)

# função para remover acentos de strings
RemoveAcentos <- function(textoComAcentos) {
  
  if(!is.character(textoComAcentos)){
    on.exit()
  }
  
  letrasComAcentos <- "áéíóúÁÉÍÓÚýÝàèìòùÀÈÌÒÙâêîôûÂÊÎÔÛãõÃÕñÑäëïöüÄËÏÖÜÿçÇ´`^~¨"
  
  letrasSemAcentos <- "aeiouAEIOUyYaeiouAEIOUaeiouAEIOUaoAOnNaeiouAEIOUycC     "
  
  textoSemAcentos <- chartr(
    old = letrasComAcentos,
    new = letrasSemAcentos,
    x = textoComAcentos
  ) 

  return(textoSemAcentos)
}

# remove acentos
populacao %<>% 
  mutate_if(is.character, RemoveAcentos)

IDHM %<>% 
  mutate_if(is.character, RemoveAcentos)

# junte bancos de dados através de municípios comuns
library(dplyr)
nova_tabela<-inner_join(freq_municipio,populacao,IDHM,by="MUNICIPIO")

# criando nível bancário
nivel_bancarizacao = (nova_tabela$n)/(nova_tabela$POPULACAO)

round(nivel_bancarizacao, digits = 5)

library(data.table)
nivel_bancarizacao <- data.table(MUNICIPIO = nova_tabela$MUNICIPIO,
                                 ESTADO = nova_tabela$ESTADO,
                                 POPULACAO =nova_tabela$POPULACAO,
                                 BANCARIZACAO = nivel_bancarizacao,
                                 IDHM = IDHM$IDHM) 

# selecionando as 1000 cidades mais desbancarizadas
tabela_final <- arrange(nivel_bancarizacao,sort(BANCARIZACAO))
tabela_final[order(tabela_final)]

library(dplyr)
cidades <- tabela_final[1:1000,]

# arquivo excel
library(xlsx)
write.xlsx(cidades, "nivel_bancarizacao.xls") 
