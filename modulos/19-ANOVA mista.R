
##################### ANOVA mista ####################


# Passo 1: Carregar os pacotes que ser�o usados

if(!require(dplyr)) install.packages("dplyr")
library(dplyr)                                
if(!require(ez)) install.packages("ez") 
library(ez)
if(!require(rstatix)) install.packages("rstatix") 
library(rstatix)
if(!require(reshape)) install.packages("reshape") 
library(reshape)
if(!require(car)) install.packages("car") 
library(car)
if(!require(emmeans)) install.packages("emmeans") 
library(emmeans)
if(!require(ggplot2)) install.packages("ggplot2") 
library(ggplot2)


# Passo 2: Carregar o banco de dados

# Importante: selecionar o diret�rio de trabalho (working directory)
# Isso pode ser feito manualmente: Session > Set Working Directory > Choose Directory

dados <- read.csv2('Banco de Dados 7.4.csv', stringsAsFactors = T,
                   fileEncoding = "latin1")   # Carregamento do arquivo csv
View(dados)                                   # Visualiza��o dos dados em janela separada
glimpse(dados)                                # Visualiza��o de um resumo dos dados

summary(dados)


# Passo 3: Alterar o formato do banco de dados de "wide" para "long"

# Reestruturando o banco de dados

dadosl <- reshape(dados, direction="long",
                  idvar = "ID",
                  varying = list(c("TG.1","TG.2","TG.3","TG.4","TG.5"),
                                 c("Peso.1","Peso.2","Peso.3","Peso.4","Peso.5")),
                  v.names = c("TG", "Peso"),
                  timevar = "Tempo")

# Ordenando as colunas pelo sujeito experimental
dadosl <- sort_df(dadosl, vars = "ID")

glimpse(dadosl)

# Transformando as vari�veis ID e Tempo em fator
dadosl$ID <- factor(dadosl$ID)
dadosl$Tempo <- factor(dadosl$Tempo)


# Passo 4: Checar os pressupostos de normalidade e aus�ncia de outliers (pacote: rstatix)

# Verificando a presen�a de outliers por grupo
boxplot(TG ~ G�nero:Tempo, dadosl)


# Verificando a normalidade por grupo
dadosl %>% group_by(G�nero, Tempo) %>% 
  shapiro_test(TG)


# Verificando a homogeneidade de vari�ncias
leveneTest(TG ~ G�nero, dadosl)


# Passo 5: Constru��o do modelo da ANOVA com medidas repetidas (pacote: ez)

mod.ANOVA <- ezANOVA(data = dadosl,
                     dv = .(TG),
                     wid = .(ID),
                     within = .(Tempo),
                     between = .(G�nero),
                     detailed = TRUE,
                     type = 3)

# dv = vari�vel dependente
# wid = vari�vel de identifica��o do sujeito
# within = vari�vel independente de medidas repetidas
# between = vari�vel independente entre sujeitos
# between_covariates = covari�vel
# type = tipo da soma dos quadrados (default � o tipo II, tipo III � o padr�o no SPSS)


# Passo 5: Analisando os resultados do modelo

# options(scipen = 999)  

mod.ANOVA

# Obs.: Libera o teste de esfericidade de Mauchly, e as corre��es
#       de Greenhouse-Geisser e Huynh-Feldt


# Passo 6: Visualiza��o das diferen�as
ggplot(dadosl, aes(x = Tempo, y = TG, group = G�nero, color = G�nero)) +
  geom_line(stat = "summary", fun.data = "mean_se", size = 0.8) +
  geom_point(stat = "summary", fun = "mean") +
  geom_errorbar(stat = "summary", fun.data = "mean_se", width = 0.2)



# Passo 7: Testes de post-hoc

CompTempo <- dadosl %>% group_by(G�nero) %>%
  emmeans_test(TG ~ Tempo, p.adjust.method = "bonf")
View(CompTempo)
# Outra op��o: corre��o de Sidak

CompGen <- dadosl %>% group_by(Tempo) %>%
  emmeans_test(TG ~ G�nero, p.adjust.method = "bonferroni")
View(CompGen)


# Passo 8 (opcional): An�lise descritiva dos dados (pacote: rstatix)
dadosl %>% group_by(Tempo, G�nero) %>% 
  get_summary_stats(TG, type = "mean_sd")

