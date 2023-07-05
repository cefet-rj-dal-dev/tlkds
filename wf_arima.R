source("carrega.R")
source("wf_experiment.R")

load("data/fertilizers.RData")

run_arima <- function(filename, dataset, train_size, test_size, ro=TRUE) {
  create_directories()
  base_model <- ts_arima()
  result <- NULL
  for (j in (1:length(dataset))) {
    myexp <- wf_experiment(names(dataset)[j], base_model, sw_size = 0, input_size = c(1), train_size = train_size, 
                           filter = ts_fil_none(), preprocess = list(ts_aug_none()), augment = list(ts_aug_none()), ranges = NULL) 
    x <- dataset[[j]]
    myexp <- train(myexp, x)  
    if (ro) {
      results_ro <- NULL
      #rolling origin
      for (j in 1:test_size) {
        myexp <- test(myexp, x, test_pos = train_size + 1, test_size = j, steps_ahead = 1, ro = TRUE)  
        results_ro <- rbind(results_ro, myexp$result)
      }
      result <- rbind(result, results_ro)
    }
    else {
      results_sa <- NULL
      #steps ahead
      for (j in 1:test_size) {
        myexp <- test(myexp, x, test_pos = train_size + 1, test_size = j, steps_ahead = j, ro = FALSE)  
        results_sa <- rbind(results_sa, myexp$result)
      }
      result <- rbind(result, results_sa)
    }
  }
  save(result, file=filename)
  return(result)
}

arima_ro <- run_arima(fertilizers, train_size = 55, test_size = 5, ro=TRUE)
