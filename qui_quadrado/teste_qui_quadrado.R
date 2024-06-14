if (!require("plyr"))               install.packages("plyr")
if (!require("dplyr"))              install.packages("dplyr")
if (!require("questionr"))          install.packages("questionr")

dados <- read.csv("atributos_transportes.csv")

# recategorização das variáveis

# pergunta 6
dados$medidas_desempenho <- revalue(dados$medidas_desempenho, replace = c("1" = "Discordo totalmente",
                                                                          "2" = "Discordo",
                                                                          "3" = "Concordo",
                                                                          "4" = "Concordo totalmente",
                                                                          "5" ="Não sei"))

# pergunta 7
dados$medidas_utilizacao <- as.character(as.numeric(dados$medidas_utilizacao))
dados$medidas_utilizacao <- revalue(dados$medidas_utilizacao, replace = c("1" = "Discordo totalmente",
                                                                          "2" = "Discordo",
                                                                          "3" = "Concordo",
                                                                          "4" = "Concordo totalmente",
                                                                          "5" ="Não sei"))

# pergunta 8
dados$medidas_eficiencia <- revalue(dados$medidas_eficiencia, replace = c("1" = "Discordo totalmente",
                                                                          "2" = "Discordo",
                                                                          "3" = "Concordo",
                                                                          "4" = "Concordo totalmente",
                                                                          "5" ="Não sei"))

# pergunta 9
dados$medidas_desempenho_ambiente <- revalue(dados$medidas_desempenho_ambiente, replace = c("1" = "Discordo totalmente",
                                                                                            "2" = "Discordo",
                                                                                            "3" = "Concordo",
                                                                                            "4" = "Concordo totalmente",
                                                                                            "5" ="Não sei"))

# pergunta 10
dados$medidas_utilizacao_estrutura <- revalue(dados$medidas_utilizacao_estrutura, replace = c("1" = "Discordo totalmente",
                                                                                              "2" = "Discordo",
                                                                                              "3" = "Concordo",
                                                                                              "4" = "Concordo totalmente",
                                                                                              "5" ="Não sei"))

# pergunta 11
dados$medidas_eficiencia_energia <- revalue(dados$medidas_eficiencia_energia, replace = c("1" = "Discordo totalmente",
                                                                                          "2" = "Discordo",
                                                                                          "3" = "Concordo",
                                                                                          "4" = "Concordo totalmente",
                                                                                          "5" ="Não sei"))

# pergunta 19
dados$educacao <- revalue(dados$educacao, replace = c("Primeiro ciclo (4º ano)" = "Primeiro ciclo",
                                                      "Ciclo intermédio (9º ano)" = "Ciclo intermédio",
                                                      "Nível Secundário (12º ano)" = "Nível Secundário",
                                                      "Nível Universitário (Licenciatura, Mestrado/ Doutoramento)"= "Nível Universitário"))

# definindo os limites dos intervalos de classe
breaks <- seq(18, 87, by = 7)

# categorizando as idades de acordo com os intervalos
dados$idade_classes <- cut(dados$idade, breaks, right = FALSE, include.lowest = TRUE)

dados$idade_classes <- revalue(dados$idade_classes, replace = c("[18,25)" = "18-24",
                                                                "[25,32)" = "25-31",
                                                                "[32,39)" = "32-38",
                                                                "[39,46)" = "39-45",
                                                                "[46,53)" = "46-52", 
                                                                "[53,60)" = "53-59",
                                                                "[60,67)" = "60-66", 
                                                                "[67,74)" = "67-73"))

dados$idade_classes <- revalue(dados$idade_classes, replace = c("[74,81]" = "74-80"))
dados$idade_classes = as.character(dados$idade_classes)

dados <- dados %>%
  mutate(idade_classes = ifelse(is.na(idade_classes), "[81-87]", idade_classes))

dados$idade_classes <- revalue(dados$idade_classes, replace = c("[81-87]" = "81-87"))

# como o tamanho amostral das idades acima de 67 anos se mostrou muito pequeno, 
# foram feitas recategorizações juntando grupos com idades superiores ou iguais a 67 anos
dados$idade_classes <- revalue(dados$idade_classes, replace = c("67-73" = "+ 67"))
dados$idade_classes <- revalue(dados$idade_classes, replace = c("74-80" = "+ 67"))
dados$idade_classes <- revalue(dados$idade_classes, replace = c("81-87" = "+ 67"))
table(dados$idade_classes)

# tabela cruzada e teste qui-quadrado: Idade x Medidas de desempenho
teste1 <- table(dados$idade_classes, dados$medidas_desempenho)
chisq.test(teste1)

# tabela cruzada e teste qui-quadrado: Área x Medidas de desempenho
teste2 <- table(dados$area, dados$medidas_desempenho)
chisq.test(teste2)

# tabela cruzada e teste qui-quadrado: Nível de educação x Disponibilidade de pagamento
teste3 <- table(dados$educacao, dados$disponibilidade_pagamento)
chisq.test(teste3)

# análise dos resíduos
chisq.residuals(teste3, digits = 2, std = TRUE)
