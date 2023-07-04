source("carrega.R")
#source("wf_experiment.R")
library(daltoolbox)
library(dplyr)
library(stringr)
library(stringi)

#library(daltoolbox)
#library(forecast)
#library(xlsx)
#library(reshape)

load("data/fertilizers.RData")

arima_ro <- run_arima(fertilizers, train_size = 55, test_size = 5, ro=TRUE)
