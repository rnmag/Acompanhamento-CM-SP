# Este script centraliza todas as verificações feitas no site da Câmara dos Ve-
# readores, simplificando o processo de automatização

# Pacotes utilizados pelos scripts
library(remotes)
library(emayili) # remotes::install_github("datawookie/emayili")
library(dplyr)
library(rvest)
library(here)
library(stringi)
library(rowr)

here()

# Checar e atualizar todas as Comissões Permanentes, assim como a Mesa Diretora
source("acompanha_comissoes.R")
rm(list = ls())

# Checar e atualizar todas as lideranças partidárias, assim como o líder de go-
# verno
source("acompanha_liderancas.R")
rm(list = ls())

# Checar e atualizar todos os vereadores em exercício, assim como seus respecti-
# vos partidos
source("acompanha_vereadores.R")
rm(list = ls())
