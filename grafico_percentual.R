if (!require("readxl"))             install.packages("readxl")
if (!require("plyr"))               install.packages("plyr")
if (!require("ggplot2"))            install.packages("ggplot2")

# tabela de frequência
table1::table1(~., data = dados)

# primeiro precisamos agrupar os valores para tornar nossa amostra mais representativa (houve apenas algumas respostas para pessoas com mais de 41 anos)
dados[dados$Idade == "Entre_41_e_50", 2] = "Mais 41"
dados[dados$Idade == "Entre_51_e_60", 2] = "Mais 41"
dados[dados$Idade == "Entre_61_e_70", 2] = "Mais 41"
dados[dados$Idade == "Mais_de_71", 2] = "Mais 41"

# então podemos construir um data frame com as variáveis x e y
idade_conceito <- data.frame(prop.table(table(dados$Idade, dados$ConceitoEfluente),1))

# transformando em fator para preservar atributos de rótulos de variáveis e valores
idade_conceito$Var2<-as.factor(idade_conceito$Var2)

idade_conceito$Var2<- factor(idade_conceito$Var2,
                             levels = c("Nao_sabe",
                                        "Tem_ideia",
                                        "Sabe"))

# substitua por novos valores
idade_conceito$var2_cat<-revalue(idade_conceito$Var2, replace = c("Nao_sabe" = "Não sabe",
                                                                  "Sabe" = "Sabe",
                                                                  "Tem_ideia" = "Tem ideia"))

idade_conceito$Var2 <-as.numeric(as.character(idade_conceito$Var2))

# transformando em fator para preservar atributos de rótulos de variáveis e valores
idade_conceito$Var1<-as.factor(idade_conceito$Var1)


idade_conceito$Var1<- factor(idade_conceito$Var1,
                             levels = c("Entre_15_e_20", 
                                        "Entre_21_e_25" ,
                                        "Entre_26_e_30" ,
                                        "Entre_31_e_40", 
                                        "Mais 41"))

# substitua por novos valores
idade_conceito$var1_cat<-revalue(idade_conceito$Var1, replace = c("Entre_15_e_20" = "15-20", 
                                                                  "Entre_21_e_25" = "21-25",
                                                                  "Entre_26_e_30" = "26-30",
                                                                  "Entre_31_e_40" ="31-40", 
                                                                  "Mais 41" = "+ 41"))

idade_conceito$Var1 <-as.numeric(as.character(idade_conceito$Var1))

# construindo um gráfico percentual com ggplot2
ggplot(idade_conceito, aes(x = var1_cat, y=Freq, fill =var2_cat ))+
  geom_bar( width = 0.8, position = position_dodge(width = 0.9), stat = "identity")+ 
  labs(x="Idade (anos)", y=" ", fill = " ") +
  ggtitle("Conceito de efluente") +
  scale_y_continuous(labels = scales::percent)
