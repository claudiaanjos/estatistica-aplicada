#################### Carregando pacotes ####################

if(!require(dplyr)){install.packages("dplyr")}

library(dplyr)


############### Carregando o banco de dados ###############

# Passo 1: selecionar o diretorio de trabalho (working directory)


## Opcao 1 - Manualmente: Session > Set Working Directory > Choose Directory

## Opcao 2:
setwd("/cloud/project")


# Passo 2: carregar o banco de dados

dados <- read.csv('02-dataset.csv', sep = ',',
                  fileEncoding = "latin1")

## Outra opcao:
dados <- read.csv2('02-dataset.csv', fileEncoding = "latin1")


############### Visualizando o banco de dados ###############

View(dados)
glimpse(dados)


############### Ajustando as variaveis ###############

# Transformando Genero em fator:

dados$Genero <- factor(dados$Genero, label = c("M", "F"), levels = c(0, 1))


# Transformando Grau de Instrucao em fator:

dados$Grau_de_Instruçao <- factor(dados$Grau_de_Instruçao,
                                  label = c("Fundamental", "Medio", "Superior"),
                                  levels = 0:2, order = T) # ordenaçao = True


# Codificando valores ausentes (missing values):

dados[dados==-999] <- NA

# Salvar como CSV

write.csv(dados, "03-dataset.csv", row.names = FALSE)
