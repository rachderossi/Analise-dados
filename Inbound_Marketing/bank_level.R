library(readxl)
freq_municipio <- read_excel("freq_municipio.xls")
freq_municipio$X = NULL

populacao <-  read_excel("pop.xlsx", col_types = c("text", "text", "numeric"))

IDHM <- read_excel("IDHM.xlsx")

library(tidyverse)
library(magrittr)

# convert to uppercase
populacao %<>% 
  mutate_if(is.character, toupper)

IDHM %<>% 
  mutate_if(is.character, toupper)

# function to remove string accents
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

# drop accents
populacao %<>% 
  mutate_if(is.character, RemoveAcentos)

IDHM %<>% 
  mutate_if(is.character, RemoveAcentos)

# join databases through common municipalities
library(dplyr)
nova_tabela<-inner_join(freq_municipio,populacao,IDHM,by="MUNICIPIO")

# creating banking level
nivel_bancarizacao = (nova_tabela$n)/(nova_tabela$POPULACAO)

round(nivel_bancarizacao, digits = 5)

library(data.table)
nivel_bancarizacao <- data.table(MUNICIPIO = nova_tabela$MUNICIPIO,
                                 ESTADO = nova_tabela$ESTADO,
                                 POPULACAO =nova_tabela$POPULACAO,
                                 BANCARIZACAO = nivel_bancarizacao,
                                 IDHM = IDHM$IDHM) 

# selecting the 1000 most unbanked cities
tabela_final <- arrange(nivel_bancarizacao,sort(BANCARIZACAO))
tabela_final[order(tabela_final)]

library(dplyr)
cidades <- tabela_final[1:1000,]

# transform into excel file
library(xlsx)
write.xlsx(cidades, "nivel_bancarizacao.xls") 