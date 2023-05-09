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

data <- NULL
data <- rbind(data, result_mlp_prep_is)
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



