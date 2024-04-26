nivel_bancarizacao <- read_excel("nivel_bancarizacao.xls", 
                                 col_types = c("text", "text", "numeric", 
                                               "numeric", "numeric", "numeric"))

# teledensidade estadual de celulares pós-pagos
teledensidade_estad <-nivel_bancarizacao$POS_PAGOS/nivel_bancarizacao$POPULACAO
round(teledensidade_estad, digits = 4)

# municipal population adjustment coefficient
CP <- ifelse(nivel_bancarizacao$POPULACAO < 5000, 5,
             ifelse(nivel_bancarizacao$POPULACAO > 5000 & nivel_bancarizacao$POPULACAO <20000, 10,
                    ifelse(nivel_bancarizacao$POPULACAO > 20000 & nivel_bancarizacao$POPULACAO <100000, 15,
                           ifelse(nivel_bancarizacao$POPULACAO > 100000 & nivel_bancarizacao$POPULACAO <500000, 20,
                                  ifelse(nivel_bancarizacao$POPULACAO > 500000, 25, NA)))))

# probabilidade de conversão (em porcentagem)
prob_conversao <- (nivel_bancarizacao$IDHM^CP)*(teledensidade_estad/1.5)*100

# número de clientes convertidos
clientes_conv <- (nivel_bancarizacao$POPULACAO*prob_conversao)/100
round(clientes_conv, digits = 1)

library(data.table)
clientes_conv <- data.table(MUNICIPIO = nivel_bancarizacao$MUNICIPIO,
                            ESTADO = nivel_bancarizacao$ESTADO,
                            POPULACAO =nivel_bancarizacao$POPULACAO,
                            NIVEL_BANCARIZACAO = nivel_bancarizacao$BANCARIZACAO,
                            CLIENTES_CONVERTIDOS = clientes_conv) 

# arquivo excel
library(xlsx)
write.xlsx(clientes_conv, "entrega.final.xls")
