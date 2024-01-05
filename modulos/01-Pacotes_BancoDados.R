# Instalando pacotes

## Opcao 1: atraves de "packages" no canto inferior direito (instalamos car)

## Opcao 2:
install.packages("dplyr")

## Opcao 3: (comando: veja se o pacote existe, caso contrario instale)
if(!require(dplyr))
  install.packages("dplyr")


#################### Carregando pacotes ####################

library(car)
require(dplyr)



############### Carregando o banco de dados ###############

# Passo 1: selecionar o diretorio de trabalho (working directory)


## Opcao 1 - Manualmente: Session > Set Working Directory > Choose Directory

## Opcao 2:
setwd("/cloud/project")


# Passo 2: carregar o banco de dados

dados <- read.csv('dataset.csv', sep = ',', 
                  stringsAsFactors = T, fileEncoding = "latin1")


## Outra opcao:
dados <- read.csv2('Banco de Dados 2.csv', stringsAsFactors = T,
                   fileEncoding = "latin1")



## Funcoes para visualizar o banco de dados:
View(dados)
glimpse(dados)
