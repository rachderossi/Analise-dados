if (!require("plyr"))               install.packages("plyr")
if (!require("dplyr"))              install.packages("dplyr")
if (!require("questionr"))          install.packages("questionr")

escola_A <- read_csv("dados_escolas - escola_A.csv")

pergunta_controle <- escola_A %>% 
  select(grupo, tempo, pergunta, resposta_aberta) %>% 
  filter(pergunta == 26 | pergunta == 27 | pergunta == 28 | pergunta == 29 | pergunta == 30, grupo == "controle",tempo == "antes")

pergunta_experimento <- escola_A %>% 
  select(grupo, tempo, pergunta, resposta_aberta) %>% 
  filter(pergunta == 26 | pergunta == 27 | pergunta == 28 | pergunta == 29 | pergunta == 30, grupo == "experimento",tempo == "antes")

# Calcular as contagens de respostas corretas e incorretas em cada grupo
controle_corretas <- sum(pergunta_controle$resposta_aberta == 1)
controle_incorretas <- sum(pergunta_controle$resposta_aberta == 0)

experimento_corretas <- sum(pergunta_experimento$resposta_aberta == 1)
experimento_incorretas <- sum(pergunta_experimento$resposta_aberta == 0)

# Realizar o teste exato de Fisher
fisher.test(matrix(c(controle_corretas, controle_incorretas,
                     experimento_corretas, experimento_incorretas), ncol = 2))

pergunta_controle <- escola_A %>% 
  select(grupo, tempo, pergunta, resposta_aberta) %>% 
  filter(pergunta == 26 | pergunta == 27 | pergunta == 28 | pergunta == 29 | pergunta == 30, grupo == "controle",tempo == "depois")

pergunta_experimento <- escola_A %>% 
  select(grupo, tempo, pergunta, resposta_aberta) %>% 
  filter(pergunta == 26 | pergunta == 27 | pergunta == 28 | pergunta == 29 | pergunta == 30, grupo == "experimento",tempo == "depois")

# Calcular as contagens de respostas corretas e incorretas em cada grupo
controle_corretas <- sum(pergunta_controle$resposta_aberta == 1)
controle_incorretas <- sum(pergunta_controle$resposta_aberta == 0)

experimento_corretas <- sum(pergunta_experimento$resposta_aberta == 1)
experimento_incorretas <- sum(pergunta_experimento$resposta_aberta == 0)

# Realizar o teste exato de Fisher
fisher.test(matrix(c(controle_corretas, controle_incorretas,
                     experimento_corretas, experimento_incorretas), ncol = 2))
