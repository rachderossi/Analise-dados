nivel_bancarizacao <- read_excel("nivel_bancarizacao.xls", 
                                 col_types = c("text", "text", "numeric", 
                                               "numeric", "numeric", "numeric"))

# state teledensity of postpaid cell phones
teledensidade_estad <-nivel_bancarizacao$POS_PAGOS/nivel_bancarizacao$POPULACAO
round(teledensidade_estad, digits = 4)

# municipal population adjustment coefficient
CP <- ifelse(nivel_bancarizacao$POPULACAO < 5000, 5,
             ifelse(nivel_bancarizacao$POPULACAO > 5000 & nivel_bancarizacao$POPULACAO <20000, 10,
                    ifelse(nivel_bancarizacao$POPULACAO > 20000 & nivel_bancarizacao$POPULACAO <100000, 15,
                           ifelse(nivel_bancarizacao$POPULACAO > 100000 & nivel_bancarizacao$POPULACAO <500000, 20,
                                  ifelse(nivel_bancarizacao$POPULACAO > 500000, 25, NA)))))

# conversion probability (in percent)
prob_conversao <- (nivel_bancarizacao$IDHM^CP)*(teledensidade_estad/1.5)*100

# number of converted customers
clientes_conv <- (nivel_bancarizacao$POPULACAO*prob_conversao)/100
round(clientes_conv, digits = 1)

library(data.table)
clientes_conv <- data.table(MUNICIPIO = nivel_bancarizacao$MUNICIPIO,
                            ESTADO = nivel_bancarizacao$ESTADO,
                            POPULACAO =nivel_bancarizacao$POPULACAO,
                            NIVEL_BANCARIZACAO = nivel_bancarizacao$BANCARIZACAO,
                            CLIENTES_CONVERTIDOS = clientes_conv) 

# transform into excel file
library(xlsx)
write.xlsx(clientes_conv, "entrega.final.xls")