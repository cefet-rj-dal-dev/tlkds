source("carrega.R")
source("wf_experiment.R")
library(daltoolbox)
library(dplyr)
library(stringr)
library(stringi)

#library(daltoolbox)
#library(forecast)
#library(xlsx)
#library(reshape)

arima_ro <- run_arima(train_size = 55, test_size = 5, silent=TRUE, ro=TRUE)
arima_ra <- run_arima(train_size = 55, test_size = 5, silent=TRUE, ro=FALSE)
