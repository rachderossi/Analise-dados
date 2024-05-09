  library(basedosdados)
  library(readr)
  library(dplyr)
  library(ggplot2)
  library(hrbrthemes)
  
  set_billing_id("dadosibge")
  
  query <- "SELECT * FROM `basedosdados.br_mdr_snis.municipio_agua_esgoto`"
  
  path <- "/Users/raquelrossi/Downloads/dados_ibge.csv"
  
  download(query, path=path)
  
  # base de dados 
  dados2021 <- read_csv("dados_ibge.csv")
  
  # cria uma nova base de dados apenas das colunas de interesse
  dados_esgoto <- dados2021 %>% 
    select(ano, sigla_uf, populacao_atentida_esgoto) %>% 
    filter(ano == 2010 | ano == 2021)
  
  # agrupar e somar a população atendida com esgoto
  dados_agrupados <- dados_esgoto %>%
    group_by(ano, sigla_uf) %>%
    summarise(populacao_atentida_total = sum(populacao_atentida_esgoto, na.rm = TRUE))
  
  # cria nova coluna região
  dados_agrupados$regiao <- NA
  
  dados_agrupados$regiao <- ifelse(dados_agrupados$sigla_uf == 'AC' | dados_agrupados$sigla_uf == 'AP' | dados_agrupados$sigla_uf == 'AM' | 
                                     dados_agrupados$sigla_uf == 'PA' | dados_agrupados$sigla_uf == 'RO' | dados_agrupados$sigla_uf == 'RR' |
                                     dados_agrupados$sigla_uf == 'TO' , "Norte", dados_agrupados$regiao)
  
  dados_agrupados$regiao <- ifelse(dados_agrupados$sigla_uf == 'MA' | dados_agrupados$sigla_uf == 'PI' | dados_agrupados$sigla_uf == 'CE' |
                                     dados_agrupados$sigla_uf == 'RN' | dados_agrupados$sigla_uf == 'PB' | dados_agrupados$sigla_uf == 'PE' |
                                     dados_agrupados$sigla_uf == 'AL' | dados_agrupados$sigla_uf == 'SE' | dados_agrupados$sigla_uf == 'BA',"Nordeste", dados_agrupados$regiao)
  
  dados_agrupados$regiao <- ifelse(dados_agrupados$sigla_uf == 'SP' | dados_agrupados$sigla_uf == 'RJ' | dados_agrupados$sigla_uf == 'MG' |
                                     dados_agrupados$sigla_uf == 'ES', "Sudeste", dados_agrupados$regiao)
  
  dados_agrupados$regiao <- ifelse(dados_agrupados$sigla_uf == 'RS' | dados_agrupados$sigla_uf == 'SC' | dados_agrupados$sigla_uf == 'PR', "Sul", dados_agrupados$regiao)
  
  
  dados_agrupados$regiao <- ifelse(dados_agrupados$sigla_uf == 'DF' | dados_agrupados$sigla_uf == 'GO' | dados_agrupados$sigla_uf == 'MT' |
                                     dados_agrupados$sigla_uf == 'MS', "Centro-Oeste", dados_agrupados$regiao)
  
  
  # criando data frame com a populacao de cada ano
  dados_populacao <- data.frame(
    Estado = c("SP", "MG", "RJ", "BA", "RS", "PR", "PE", "CE", "PA", "MA", "SC", "GO", "PB", "ES", "AM", "RN", "AL", "PI", "MT", "DF", "MS", "SE", "RO", "TO", "AC", "AP", "RR"),
    Populacao2010 = c(41262199, 19597330, 15989929, 14016906, 10693929, 10444526, 8796448, 8452381, 7581051, 6574789, 6248436, 6003788, 3766528, 3514952, 3483985, 3168027, 3120494, 3118360, 3035122, 2570160, 2449024, 2068017, 1562409, 1383445, 733559, 669526, 450479),
    Populacao2021 = c(46649132, 21411923, 17463349, 14985284, 11466630, 11597484, 9674793, 9240580, 8777124, 7153262, 7338473, 7206589, 4059905, 4108508, 4269995, 3560903, 3365351, 3289290, 3567234, 3094325, 2839188, 2338474, 1815278, 1607363, 906876, 877613, 652713))
  
  # renomear a coluna 'Estado' para 'sigla_uf' para corresponder à coluna na base de dados agrupados
  colnames(dados_populacao)[colnames(dados_populacao) == "Estado"] <- "sigla_uf"
  
  # juntar as duas bases de dados pela coluna 'sigla_uf'
  dados_agrupados <- merge(dados_agrupados, dados_populacao[, c("sigla_uf", "Populacao2010")], by = "sigla_uf")
  
  
  # substituir os valores da coluna Populacao2021 de acordo com cada sigla_uf e ano
  dados_agrupados$Populacao2021 <- NA
  dados_agrupados$Populacao2010 <- NA
  
  dados_agrupados$Populacao2021 <- ifelse(dados_agrupados$ano == 2021, 
                                          dados_populacao$Populacao2021[match(dados_agrupados$sigla_uf, c("SP", "MG", "RJ", "BA", "RS", "PR", "PE", "CE", "PA", "MA", "SC", "GO", "PB", "ES", "AM", "RN", "AL", "PI", "MT", "DF", "MS", "SE", "RO", "TO", "AC", "AP", "RR"))],
                                          dados_agrupados$Populacao2021)
  
  dados_agrupados$Populacao2010 <- ifelse(dados_agrupados$ano == 2010, 
                                          dados_populacao$Populacao2010[match(dados_agrupados$sigla_uf, c("SP", "MG", "RJ", "BA", "RS", "PR", "PE", "CE", "PA", "MA", "SC", "GO", "PB", "ES", "AM", "RN", "AL", "PI", "MT", "DF", "MS", "SE", "RO", "TO", "AC", "AP", "RR"))],
                                          dados_agrupados$Populacao2010)
  
  
  # função para juntar as duas últimas colunas
  dados_agrupados$populacao <- ifelse(is.na(dados_agrupados$Populacao2010), dados_agrupados$Populacao2021, dados_agrupados$Populacao2010)
  
  # remover as colunas Populacao2010 e Populacao2021
  dados_agrupados <- dados_agrupados[, -c(5:6)]
  
  # somar população e população atendida total de regiões com o mesmo nome e ano
  dados_agrupados_soma <- dados_agrupados %>%
    group_by(regiao, ano) %>%
    summarise(populacao = sum(populacao, na.rm = TRUE),
              populacao_atendida_total = sum(populacao_atentida_total, na.rm = TRUE))
  
  # calculando as somas para o Brasil
  dados_brasil <- dados_agrupados_soma %>%
    filter(regiao != "Brasil") %>%
    group_by(ano) %>%
    summarise(populacao = sum(populacao, na.rm = TRUE),
              populacao_atendida_total = sum(populacao_atendida_total, na.rm = TRUE)) %>%
    mutate(regiao = "Brasil")
  
  # adicionando os dados do Brasil à base de dados original
  dados_agrupados_soma <- bind_rows(dados_agrupados_soma, dados_brasil)
  dados_agrupados_soma <- arrange(dados_agrupados_soma, regiao, ano)
  
  # calcular a proporção de população total atendida com esgotamento
  dados_agrupados_soma$proporcao <- NA
  dados_agrupados_soma$proporcao <- round((dados_agrupados_soma$populacao_atendida_total/ dados_agrupados_soma$populacao)*100,1)
  
  # convertendo a variável ano para fator para fazr o gráfico de barras agrupadas
  dados_agrupados_soma$ano <- as.character(as.numeric(dados_agrupados_soma$ano))
  
  # definindo a ordem desejada das regiões
  ordem_regiao <- c("Brasil", "Norte", "Nordeste", "Sudeste", "Sul", "Centro-Oeste")
  
  # cria o gráfico de barras agrupadas 
  ggplot(dados_agrupados_soma, aes(x = factor(regiao, levels = ordem_regiao), y = proporcao , fill = ano)) +
    geom_bar(position = "dodge", stat = "identity") +
    geom_text(aes(label = proporcao), position = position_dodge(width = 0.9), vjust = -0.5) + # adiciona os valores das barras
    scale_fill_manual(values = c("#061352", "#E49A00"), name= NULL) +  
    ggtitle("Proporção de população total atendida com esgotamento sanitário, segundo 
    as Grandes Regiões - 2010/2021") +
    theme(plot.title = element_text(hjust = 0.5),
          panel.grid.major = element_blank(), # removendo grade principal
          panel.grid.minor = element_blank()) + # removendo grade secundária
    xlab("Regiões") +
    ylab("Proporção (%)") +
    guides(fill = guide_legend(title = NULL)) 
