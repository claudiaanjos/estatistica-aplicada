
######################### Correla��o Linear Bivariada #########################


# Passo 1: Carregar os pacotes que ser�o usados

if(!require(dplyr)) install.packages("dplyr")
library(dplyr)                                
if(!require(ggplot2)) install.packages("ggplot2") 
library(ggplot2)
if(!require(corrplot)) install.packages("corrplot") 
library(corrplot)

# Passo 2: Carregar o banco de dados

# Importante: selecionar o diret�rio de trabalho (working directory)
# Isso pode ser feito manualmente: Session > Set Working Directory > Choose Directory

dados <- read.csv2('Banco de Dados 10.csv', stringsAsFactors = T,
                   fileEncoding = "latin1")   # Carregamento do arquivo csv
View(dados)                                   # Visualiza��o dos dados em janela separada
glimpse(dados)                                # Visualiza��o de um resumo dos dados



# Passo 3: Verifica��o dos pressupostos para a correla��o de Pearson

## Normalidade (Shapiro-Wilk):
shapiro.test(dados$Ansiedade)
shapiro.test(dados$Nota)


## Presen�a de outliers:
boxplot(dados$Ansiedade)
boxplot(dados$Nota)


## Rela��o linear entre as vari�veis:
plot(dados$Ansiedade, dados$Nota)



# Passo 4: Verifica��o dos pressupostos nos res�duos

## Constru��o do modelo:
mod_reg <- lm(Nota ~ Ansiedade, dados)


## An�lise gr�fica:
par(mfrow=c(1,2))
plot(mod_reg, which=c(1,3))
par(mfrow=c(1,1))


### Gr�fico 1: valores previstos x res�duos
#### Permite verificar se h� homogeneidade de vari�ncias (homocedasticidade) - res�duos
# distribu�dos de acordo com um padr�o aproximadamente retangular;
#### Permite verificar se a rela��o entre as vari�veis � linear - linha vermelha
# aproximadamente horizontal;

### Gr�fico 3: valores previstos x res�duos padronizados
#### Permite verificar se h� outliers - valores de res�duos padronizados acima de 3 ou
# abaixo de -3;



# Passo 5: Realiza��o da correla��o

## Correla��o Linear de Pearson (coeficiente = r):
cor.test(dados$Nota, dados$Ansiedade, method = "pearson")


## Correla��o de Postos de Spearman (coeficiente = r�):
cor.test(dados$Nota, dados$Ansiedade, method = "spearman")


## Correla��o Tau de Kendall (coeficiente = tau):
cor.test(dados$Nota, dados$Ansiedade, method = "kendall")


# Passo 6: Gr�fico de dispers�o
ggplot(dados, aes(x = Ansiedade, y = Nota)) +
  labs(x = "Ansiedade pr�-prova", y = "Desempenho na prova") +
  geom_point(size = 1.8) +
  theme_classic()



# Passo 7 (opcional): Matrizes de correla��o

## Criando a matriz:
matriz <- cor(dados[2:4], method = "pearson")
View(matriz)

## Arredondando para duas casas decimais:
matriz <- round(cor(dados[2:4], method = "pearson"), 2)
View(matriz)


## Criando uma matriz visual (pacote corrplot)

corrplot(matriz, method = "number")


### Op��es de m�todos: method = circle, color, pie
### Op��es de tipos: type = upper, lower
### Ordenar: order = hclust

corrplot(matriz, method = "color", 
         type = "upper", order = "hclust", 
         addCoef.col = "black", # adiciona o coeficiente � matriz
         tl.col = "black", tl.srt = 45, # cor e rota��o do nome das vari�veis
         diag = FALSE # n�o mostrar a diagonal principal
         )

#### http://www.sthda.com/english/wiki/visualize-correlation-matrix-using-correlogram



