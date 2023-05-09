source("carrega.R")
source("wf_experiment.R")
library(reticulate)

source("https://raw.githubusercontent.com/cefet-rj-dal/tspred-it/main/examples/ts_conv1d.R")
reticulate::source_python("https://raw.githubusercontent.com/cefet-rj-dal/tspred-it/main/examples/ts_conv1d.py")

base_model = ts_conv1d()
base_model$log <- FALSE
ranges <- list(epochs=10000)

result_conv1d_swminmax_is <- run_machine(dataset = dataset[2],
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
save(result_conv1d_swminmax_is, file="saved/result_conv1d_swminmax_is.RData")


