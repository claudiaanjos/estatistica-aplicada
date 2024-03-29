
######################### ANOVA de duas vias #########################


# Passo 1: Carregar os pacotes que ser�o usados

if(!require(dplyr)) install.packages("dplyr")
library(dplyr)                                
if(!require(car)) install.packages("car")   
library(car)                                
if(!require(rstatix)) install.packages("rstatix") 
library(rstatix)                                
if(!require(DescTools)) install.packages("DescTools") 
library(DescTools)
if(!require(emmeans)) install.packages("emmeans") 
library(emmeans)
if(!require(ggplot2)) install.packages("ggplot2") 
library(ggplot2)

# Passo 2: Carregar o banco de dados

# Importante: selecionar o diret�rio de trabalho (working directory)
# Isso pode ser feito manualmente: Session > Set Working Directory > Choose Directory

dados <- read.csv2('Banco de Dados 6.csv', stringsAsFactors = T,
                   fileEncoding = "latin1")    # Carregamento do arquivo csv
View(dados)                                    # Visualiza��o dos dados em janela separada
glimpse(dados)                                 # Visualiza��o de um resumo dos dados


summary(dados$Alcool)

dados$Alcool <- factor(dados$Alcool,
                       levels = c("Nenhum",
                                  "2 Canecas",
                                  "4 Canecas"))


# Passo 3: Verifica��o dos pressupostos nos dados brutos

## Verifica��o da normalidade - Shapiro por grupo:
dados %>% group_by(Genero, Alcool) %>% 
  shapiro_test(Memoria)


## Verifica��o da presen�a de outliers por grupo:
boxplot(dados$Memoria ~ dados$Genero:dados$Alcool)

dados %>% group_by(Genero, Alcool) %>% 
  identify_outliers(Memoria)


## Verifica��o da homogeneidade de vari�ncias - teste de Levene (pacote car)
leveneTest(Memoria ~ Genero*Alcool, dados, center = mean)



# Por default, o teste realizado pelo pacote car tem como base a mediana (median)
# O teste baseado na mediana � mais robusto
# Mudado para ser baseado na m�dia (compar�vel ao SPSS)

# Passo 4: Verifica��o dos pressupostos nos res�duos

## Constru��o do modelo:
modelo <- aov(Memoria ~ Genero*Alcool, dados)


## Teste de normalidade para os res�duos:
shapiro.test(modelo$residuals)


## Verifica��o da presen�a de outliers entre os res�duos:
boxplot(modelo$residuals)

dados$Residuos <- modelo$residuals

dados %>% group_by(Genero, Alcool) %>% 
  identify_outliers(Residuos)

dados %>% identify_outliers(Residuos)


## Verifica��o da homogeneidade de vari�ncias - teste de Levene (pacote car)
leveneTest(Residuos ~ Genero*Alcool, dados, center = mean)


# Passo 5: Realiza��o da ANOVA

## Mudan�a no contraste para equivaler ao SPSS:
options(contrasts = c("contr.sum", "contr.poly"))

## Cria��o do modelo:
modelo <- aov(Memoria ~ Genero*Alcool, dados)
# summary(modelo)
Anova(modelo, type = 'III')


# Passo 6: Estimated Marginal Means (Pacote emmeans)

dados %>% group_by(Genero) %>% 
  emmeans_test(Memoria ~ Alcool, p.adjust.method = "bonferroni")
# Outra op��o: corre��o de Sidak

dados %>% group_by(Alcool) %>% 
  emmeans_test(Memoria ~ Genero, p.adjust.method = "bonferroni")



# Passo 7: An�lise do post-hoc (Pacote DescTools)
# Post-hocs permitidos: "hsd", "bonferroni", "lsd", "scheffe", "newmankeuls", "duncan"


# Uso do Duncan
PostHocTest(modelo, method = "duncan")

# Uso do TukeyHSD
PostHocTest(modelo, method = "hsd")

# Uso do Bonferroni
PostHocTest(modelo, method = "bonferroni")


# Passo 8: Gr�fico de intera��o (Pacote ggplot2)

## Com g�neros com cores diferentes
ggplot(dados, aes(x = Alcool, y = Memoria, group = Genero, color = Genero)) +
  geom_line(stat = "summary", fun.data = "mean_se", size = 0.6) +
  geom_point(stat = "summary", fun = "mean") +
  geom_errorbar(stat = "summary", fun.data = "mean_se", width = 0.2)


## Com g�neros com linhas diferentes
ggplot(dados, aes(x = Alcool, y = Memoria, group = Genero)) +
  geom_line(stat = "summary", fun.data="mean_se", size = 0.6, aes(linetype = Genero)) +
  geom_point(stat = "summary", fun = "mean", size = 2, aes(shape = Genero)) +
  geom_errorbar(stat = "summary", fun.data = "mean_se", width = 0.2)



# Passo 9: An�lise descritiva dos dados - Pacote rstatix
dados %>%
  group_by(Genero, Alcool) %>%
  get_summary_stats(Memoria, type = "mean_sd")
