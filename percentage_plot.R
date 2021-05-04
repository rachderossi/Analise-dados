if (!require("readxl"))             install.packages("readxl")
if (!require("plyr"))               install.packages("plyr")
if (!require("ggplot2"))            install.packages("ggplot2")

# frequency table
table1::table1(~., data = dados)

# first we need to group values to make our sample more representative (there were only a few responses for people over 41)
dados[dados$Idade == "Entre_41_e_50", 2] = "Mais 41"
dados[dados$Idade == "Entre_51_e_60", 2] = "Mais 41"
dados[dados$Idade == "Entre_61_e_70", 2] = "Mais 41"
dados[dados$Idade == "Mais_de_71", 2] = "Mais 41"

# then we can build a data frame with the variables x and y
idade_conceito <- data.frame(prop.table(table(dados$Idade, dados$ConceitoEfluente),1))

# turn into factor for preserves variable and value label attributes
idade_conceito$Var2<-as.factor(idade_conceito$Var2)

idade_conceito$Var2<- factor(idade_conceito$Var2,
                             levels = c("Nao_sabe",
                                        "Tem_ideia",
                                        "Sabe"))

# replace values with new values
idade_conceito$var2_cat<-revalue(idade_conceito$Var2, replace = c("Nao_sabe" = "Doesn't know",
                                                                  "Sabe" = "Know",
                                                                  "Tem_ideia" = "Has some idea about it"))

idade_conceito$Var2 <-as.numeric(as.character(idade_conceito$Var2))

# turn into factor for preserves variable and value label attributes
idade_conceito$Var1<-as.factor(idade_conceito$Var1)


idade_conceito$Var1<- factor(idade_conceito$Var1,
                             levels = c("Entre_15_e_20", 
                                        "Entre_21_e_25" ,
                                        "Entre_26_e_30" ,
                                        "Entre_31_e_40", 
                                        "Mais 41"))

# replace values with new values
idade_conceito$var1_cat<-revalue(idade_conceito$Var1, replace = c("Entre_15_e_20" = "15-20", 
                                                                  "Entre_21_e_25" = "21-25",
                                                                  "Entre_26_e_30" = "26-30",
                                                                  "Entre_31_e_40" ="31-40", 
                                                                  "Mais 41" = "+ 41"))

idade_conceito$Var1 <-as.numeric(as.character(idade_conceito$Var1))

# building a percentage plot with ggplot2
ggplot(idade_conceito, aes(x = var1_cat, y=Freq, fill =var2_cat ))+
  geom_bar( width = 0.8, position = position_dodge(width = 0.9), stat = "identity")+ 
  labs(x="Age (years)", y=" ", fill = " ") +
  ggtitle("Concept on the subject") +
  scale_y_continuous(labels = scales::percent)
