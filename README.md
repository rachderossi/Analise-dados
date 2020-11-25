# Análise de dados
Algumas análises de dados usando bases de dados reais ou do Kaggle. Aqui também teremos dashboards criados com o Google Data Studio, as análises são feitas no R.

## Dashboard Avaliações de Ramen

Avaliações de Ramen:  https://datastudio.google.com/s/iIH-z-u8TB4

## Projeto Conversão de clientes
O lançamento de um novo produto inovador que irá ajudar a população a ter acesso a serviços bancários através de smartphones está chegando. O objetivo é converter 1.000 clientes nas cidades mais desbancarizadas do Brasil. 

Ações para identificar as cidades para a campanha:

1) Classificar as cidades brasileira pelo nível de bancarização.
2) Estimar o número de clientes convertidos em cada cidade.

A base de dados final deverá conter:

- Nome da Cidade
- Estado
- População
- Nível de bancarização
- Clientes Convertidos

## Roteiro da análise conversão de clientes

Bancos de dados utilizados:

- POSTOS: Banco de dados do número de postos de atendimento.
- PAE: Banco de dados do número de postos de atendimento eletrônico.
- AGENCIAS: Banco de dados do número de agências.
- pop: Banco de dados da população por município.
- freq_municipio: Banco de dados da soma de Número de agências + Número de Postos de Atendimento + Número Postos de Atendimento eletrônico por município.
- nível_bancarizacao: Banco de dados com o nível de bancarização, IDHM e número de pós pagos por município.
- IDHM: Banco de dados com o IDHM de cada município.
- entrega.final: Banco de dados final com o nome da cidade, Estado, população, nível de bancarização e clientes convertidos.

1°) Criei um arquivo no R chamado junta_tabela, onde juntei as bases de dados POSTOS, PAE, AGÊNCIAS agrupados por município para ter em uma só tabela da soma do Número de agências + Número de Postos de Atendimento + Número Postos de Atendimento eletrônico.

2°) Criei outro arquivo no R chamado nivel_bancarizacao, onde juntei as bases de dados freq._municipio, pop e IDHM agrupadas por município. Antes de fazer o agrupamento precisei colocar todos os municípios em letra maiúscula e sem acentos, pois como as bases vieram de locais diferentes precisei padronizar tudo. Após o agrupamento criei uma nova variável chamada de nível bancarização e então uma tabela com as variáveis: município, estado, população, bancarização e IDHM. Por último selecionei as 1000 cidades mais desbancarizadas e ordenei em ordem crescente.

3°) O último arquivo do R chamado prob_conversao utiliza a tabela nível_bancarizacao que contem todas as variáveis necessárias para saber a probabilidade de conversão. Após criei as variáveis teledensidade estadual de celulares pós pagos, coeficiente de ajuste populacional municipal e probabilidade de conversão (em porcentagem). Por último criei a variável de interesse que é o número de clientes convertidos, criando uma tabela com: município, Estado, população, nível bancarização e clientes convertidos. A tabela do Excel chamada entrega.final é a que contém a lista com o número mínimo de cidades necessárias para atingir o objetivo com as informações de cada cidade.

## Projeto Segmentação de clientes
O objetivo da equipe é construir um modelo preditivo que irá produzir o maior lucro para o próxima campanha de marketing direto, prevista para o próximo mês. A nova campanha, visa vender um novo gadget para o banco de dados do cliente. Para construir o modelo, uma campanha piloto envolvendo 2.240 clientes foi realizada. Os clientes foram selecionados aleatoriamente e contatados por telefone sobre a aquisição do gadget. Durante os meses seguintes, os clientes que compraram o oferta foram devidamente rotuladas. A taxa de sucesso da campanha foi de 15%. O objetivo da equipe é desenvolver um modelo que preveja o comportamento do cliente e o aplique ao restante da base de clientes. Esperançosamente, o modelo permitirá que a empresa escolha os clientes com maior probabilidade de comprar a oferta, deixando de fora os não respondentes, tornando a próxima campanha altamente rentável. Além disso, além de maximizar o lucro da campanha, o CMO está interessado em compreensão para estudar as características dos clientes que estão dispostos a comprar o gadget.

O conjunto de dados contém características sociodemográficas e firmográficas sobre 2.240 clientes que foram contatados. Além disso, ele contém uma bandeira para os clientes que responderam à campanha, comprando o produto.

- Nesse projeto é feito o cálculo RFM para poder entender como os clientes devem ser classificados
- Após é feito um modelo preditivo de classificação usando o algoritmo de Naive Bayes

Segmentação de clientes: https://datastudio.google.com/s/kNhlueV5Abk
