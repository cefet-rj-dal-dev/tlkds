source("graphics.R")
library(ggplot2)
library(dplyr)
library(reshape)
library(RColorBrewer)


colors <- brewer.pal(4, 'Set1')

# setting the font size for all charts
font <- theme(text = element_text(size=16))


load("saved/result_mlp_prep_is.RData")
load("saved/result_mlp_diff_is.RData")
load("saved/result_mlp_an_is.RData")
load("saved/result_mlp_gminmax_is.RData")
load("saved/result_mlp_swminmax_is.RData")
load("saved/result_mlp_swminmax_jitter.RData")
load("saved/result_mlp_swminmax_stretch.RData")

load("saved/result_elm_an_is.RData")
load("saved/result_rfr_an_is.RData")
load("saved/result_svm_an_is.RData")
#load("saved/result_conv1d_an_is.RData")
#load("saved/result_lstm_an_is.RData")

data <- NULL
data <- rbind(data, result_mlp_diff_is)
data <- rbind(data, result_mlp_an_is)
data <- rbind(data, result_mlp_gminmax_is)
data <- rbind(data, result_mlp_swminmax_is)
data <- data |>  dplyr::filter(test_size == 4) |> dplyr::arrange(name, method, model, test_size, smape_test)

data$name <- factor(data$name, levels=c("brazil_k2o", "brazil_n", "brazil_p2o5"), labels=c("K2O", "N", "P2O5"))
data$preprocess <- factor(data$preprocess, levels=c("ts_swminmax", "ts_diff", "ts_an", "ts_gminmax"), labels=c("sw min-max", "diff", "an", "min-max"))
data <- data |> group_by(name, preprocess) |> summarize(test=mean(smape_test))

cdata <- cast(data, name ~ preprocess, mean)
head(cdata)
grf <- plot.groupedbar(cdata, colors=colors[1:4]) + font
plot(grf)

data <- NULL
data <- rbind(data, result_mlp_swminmax_is)
data <- rbind(data, result_mlp_swminmax_jitter)
data <- rbind(data, result_mlp_swminmax_stretch)
data <- data |>  dplyr::filter(test_size == 4) |> dplyr::arrange(name, method, model, test_size, smape_test)


data <- NULL
data <- rbind(data, result_mlp_an_is)
data <- rbind(data, result_elm_an_is)
data <- rbind(data, result_rfr_an_is)
data <- rbind(data, result_svm_an_is)
#data <- rbind(data, result_conv1d_an_is)
#data <- rbind(data, result_lstm_an_is)
data <- data |>  dplyr::filter(test_size == 4) |> dplyr::arrange(name, method, model, test_size, smape_test)



