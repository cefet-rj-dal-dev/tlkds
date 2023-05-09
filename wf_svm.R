source("carrega.R")
source("wf_experiment.R")
library(e1071)

base_model = ts_svm()
base_model$log <- FALSE
ranges <- list(kernel=c("radial", "poly", "linear", "sigmoid"), epsilon=seq(0, 1, 0.1), cost=seq(20, 100, 20))

result_svm_swminmax_is <- run_machine(dataset = dataset[2],
                                      base_model = base_model,
                                      sw_size = 8,
                                      input_size = 3:7,
                                      train_size = 56,
                                      test_size = 4,
                                      ranges = ranges,
                                      filter = ts_filter(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                      preprocess = list(ts_an()), #ts_an(), ts_ane(), ts_gminmax(), ts_swminmax()
                                      augment = list(ts_augment()), #jitter(), wormhole(), stretch(), shrink(), flip()
                                      ro = TRUE,
                                      silent = TRUE)

