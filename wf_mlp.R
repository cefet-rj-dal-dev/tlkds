source("carrega.R")
source("wf_experiment.R")
library(nnet)

base_model = ts_mlp()
base_model$log <- FALSE
ranges <- list(size = 1:10, decay = seq(0, 1, 1/9), maxit=10000)

if (TRUE) {
  result_mlp_prep_is <- run_machine(dataset = dataset[2],
                                    base_model = base_model,
                                    sw_size = 8,
                                    input_size = 3:7,
                                    train_size = 56,
                                    test_size = 4,
                                    ranges = ranges,
                                    filter = ts_filter(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                    preprocess = list(ts_an(), ts_gminmax(), ts_swminmax()), #ts_an(), ts_ane(), ts_gminmax(), ts_swminmax()
                                    augment = list(ts_augment()), #jitter(), wormhole(), stretch(), shrink(), flip()
                                    ro = TRUE,
                                    silent = TRUE)
  save(result_mlp_prep_is, file="saved/result_mlp_prep_is.RData")
}

if (FALSE) {
  result_mlp_diff_is <- run_machine(dataset = dataset,
                                    base_model = base_model,
                                    sw_size = 8,
                                    input_size = 3:7,
                                    train_size = 56,
                                    test_size = 4,
                                    ranges = ranges,
                                    filter = ts_filter(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                    preprocess = list(ts_diff()), #ts_an(), ts_ane(), ts_gminmax(), ts_swminmax()
                                    augment = list(ts_augment()), #jitter(), wormhole(), stretch(), shrink(), flip()
                                    ro = TRUE,
                                    silent = TRUE)
  save(result_mlp_diff_is, file="saved/result_mlp_diff_is.RData")
  
  result_mlp_an_is <- run_machine(dataset = dataset,
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
  save(result_mlp_an_is, file="saved/result_mlp_an_is.RData")
  
  result_mlp_gminmax_is <- run_machine(dataset = dataset,
                                       base_model = base_model,
                                       sw_size = 8,
                                       input_size = 3:7,
                                       train_size = 56,
                                       test_size = 4,
                                       ranges = ranges,
                                       filter = ts_filter(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                       preprocess = list(ts_gminmax()), #ts_an(), ts_ane(), ts_gminmax(), ts_swminmax()
                                       augment = list(ts_augment()), #jitter(), wormhole(), stretch(), shrink(), flip()
                                       ro = TRUE,
                                       silent = TRUE)
  save(result_mlp_gminmax_is, file="saved/result_mlp_gminmax_is.RData")
  
  result_mlp_swminmax_is <- run_machine(dataset = dataset,
                                        base_model = base_model,
                                        sw_size = 8,
                                        input_size = 3:7,
                                        train_size = 56,
                                        test_size = 4,
                                        ranges = ranges,
                                        filter = ts_filter(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                        preprocess = list(ts_swminmax()), #ts_an(), ts_ane(), ts_gminmax(), ts_swminmax()
                                        augment = list(ts_augment()), #jitter(), wormhole(), stretch(), shrink(), flip()
                                        ro = TRUE,
                                        silent = TRUE)
  save(result_mlp_swminmax_is, file="saved/result_mlp_swminmax_is.RData")
  
  
  result_mlp_swminmax_jitter <- run_machine(dataset = dataset,
                                            base_model = base_model,
                                            sw_size = 8,
                                            input_size = 3:7,
                                            train_size = 56,
                                            test_size = 4,
                                            ranges = ranges,
                                            filter = ts_filter(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                            preprocess = list(ts_swminmax()), #ts_an(), ts_ane(), ts_gminmax(), ts_swminmax()
                                            augment = list(jitter()), #jitter(), wormhole(), stretch(), shrink(), flip()
                                            ro = TRUE,
                                            silent = TRUE)
  save(result_mlp_swminmax_jitter, file="saved/result_mlp_swminmax_jitter.RData")
  
  
  result_mlp_swminmax_stretch <- run_machine(dataset = dataset,
                                             base_model = base_model,
                                             sw_size = 8,
                                             input_size = 3:7,
                                             train_size = 56,
                                             test_size = 4,
                                             ranges = ranges,
                                             filter = ts_filter(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                             preprocess = list(ts_swminmax()), #ts_an(), ts_ane(), ts_gminmax(), ts_swminmax()
                                             augment = list(stretch()), #jitter(), wormhole(), stretch(), shrink(), flip()
                                             ro = TRUE,
                                             silent = TRUE)
  save(result_mlp_swminmax_stretch, file="saved/result_mlp_swminmax_stretch.RData")
}


