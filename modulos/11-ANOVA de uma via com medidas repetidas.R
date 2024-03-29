
##################### ANOVA de uma via com medidas repetidas ####################


# Passo 1: Carregar os pacotes que ser�o usados

if(!require(dplyr)) install.packages("dplyr")
library(dplyr)                                
if(!require(ez)) install.packages("ez") 
library(ez)
if(!require(reshape)) install.packages("reshape") 
library(reshape) 
if(!require(rstatix)) install.packages("rstatix") 
library(rstatix)

# Passo 2: Carregar o banco de dados

# Importante: selecionar o diret�rio de trabalho (working directory)
# Isso pode ser feito manualmente: Session > Set Working Directory > Choose Directory

dados <- read.csv2('Banco de Dados 7.csv', stringsAsFactors = T,
                   fileEncoding = "latin1")    # Carregamento do arquivo csv
View(dados)                                    # Visualiza��o dos dados em janela separada
glimpse(dados)                                 # Visualiza��o de um resumo dos dados



# Passo 3: Alterar o formato do banco de dados de "wide" para "long" (pacote: reshape)

# Reestruturando o banco de dados

dadosl <- melt(dados,
               id = "ID",
               measured = c("Professor1", "Professor2", "Professor3", "Professor4"))

View(dadosl)

# Renomeando as colunas do novo banco
colnames(dadosl) = c("ID", "Professor", "Nota")

# Ordenando as colunas pelo sujeito experimental
dadosl <- sort_df(dadosl, vars = "ID")


glimpse(dadosl)

# Transformando a vari�vel ID em fator
dadosl$ID <- factor(dadosl$ID)



# Passo 4: Checar os pressupostos de normalidade e aus�ncia de outliers (pacote: rstatix)

# Verificando a presen�a de outliers por grupo
dadosl %>% group_by(Professor) %>% 
  identify_outliers(Nota)


# Verificando a normalidade por grupo
dadosl %>% group_by(Professor) %>% 
  shapiro_test(Nota)


# Passo 5: Constru��o do modelo da ANOVA com medidas repetidas (pacote: ez)

mod.ANOVA <- ezANOVA(data = dadosl,
                     dv = Nota,
                     wid = ID,
                     within = Professor,
                     detailed = TRUE,
                     type = 3)

# dv = vari�vel dependente
# wid = vari�vel de identifica��o do sujeito
# within = vari�vel independente de medidas repetidas
# type = tipo da soma dos quadrados (default � o tipo II, tipo III � o padr�o no SPSS)


# Passo 5: Analisando os resultados do modelo
mod.ANOVA

# Obs.: Libera o teste de esfericidade de Mauchly, e as corre��es
#       de Greenhouse-Geisser e Huynh-Feldt


# Passo 6: Testes de post-hoc
pairwise.t.test(dadosl$Nota, dadosl$Professor, paired = TRUE,
                p.adjust.method = "bonferroni")



# Passo 7 (opcional): An�lise descritiva dos dados (pacote: rstatix)
dadosl %>% group_by(Professor) %>% 
  get_summary_stats(Nota, type = "mean_sd")

boxplot(Nota ~ Professor, data = dadosl, ylab = "Notas", xlab = "Professor")


