source("carrega.R")
source("wf_experiment.R")

base_model = ts_mlp()
ranges <- list(size = 1:10, decay = seq(0, 1, 1/9), maxit=10000)

result_mlp_an_is <- run_machine(dataset = dataset[2],
                                base_model = base_model,
                                sw_size = 8,
                                input_size = 3:7,
                                train_size = 56,
                                test_size = 4,
                                ranges = ranges,
                                filter = ts_fil_none(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                preprocess = list(ts_norm_an()), #ts_norm_an(), ts_norm_ean(), ts_norm_gminmax(), ts_norm_swminmax()
                                augment = list(ts_aug_none()), #ts_aug_jitter(), ts_aug_wormhole(), ts_aug_stretch(), ts_aug_shrink(), ts_aug_flip()
                                ro = TRUE)
save(result_mlp_an_is, file="saved/result_mlp_an_is.RData")

result_mlp_gminmax_diff <- run_machine(dataset = dataset[2],
                                     base_model = base_model,
                                     sw_size = 8,
                                     input_size = 3:7,
                                     train_size = 56,
                                     test_size = 4,
                                     ranges = ranges,
                                     filter = ts_fil_none(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                     preprocess = list(ts_norm_diff()), #ts_norm_an(), ts_norm_ean(), ts_norm_gminmax(), ts_norm_swminmax()
                                     augment = list(ts_aug_none()), #ts_aug_jitter(), ts_aug_wormhole(), ts_aug_stretch(), ts_aug_shrink(), ts_aug_flip()
                                     ro = TRUE)
save(result_mlp_gminmax_diff, file="saved/result_mlp_gminmax_diff.RData")

result_mlp_gminmax_is <- run_machine(dataset = dataset[2],
                                  base_model = base_model,
                                  sw_size = 8,
                                  input_size = 3:7,
                                  train_size = 56,
                                  test_size = 4,
                                  ranges = ranges,
                                  filter = ts_fil_none(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                  preprocess = list(ts_norm_gminmax()), #ts_norm_an(), ts_norm_ean(), ts_norm_gminmax(), ts_norm_swminmax()
                                  augment = list(ts_aug_none()), #ts_aug_jitter(), ts_aug_wormhole(), ts_aug_stretch(), ts_aug_shrink(), ts_aug_flip()
                                  ro = TRUE)
save(result_mlp_gminmax_is, file="saved/result_mlp_gminmax_is.RData")

result_mlp_swminmax_is <- run_machine(dataset = dataset[2],
                                     base_model = base_model,
                                     sw_size = 8,
                                     input_size = 3:7,
                                     train_size = 56,
                                     test_size = 4,
                                     ranges = ranges,
                                     filter = ts_fil_none(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                     preprocess = list(ts_norm_swminmax()), #ts_norm_an(), ts_norm_ean(), ts_norm_gminmax(), ts_norm_swminmax()
                                     augment = list(ts_aug_none()), #ts_aug_jitter(), ts_aug_wormhole(), ts_aug_stretch(), ts_aug_shrink(), ts_aug_flip()
                                     ro = TRUE)
save(result_mlp_swminmax_is, file="saved/result_mlp_swminmax_is.RData")


result_mlp_swminmax_jitter <- run_machine(dataset = dataset[2],
                                      base_model = base_model,
                                      sw_size = 8,
                                      input_size = 3:7,
                                      train_size = 56,
                                      test_size = 4,
                                      ranges = ranges,
                                      filter = ts_fil_none(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                      preprocess = list(ts_norm_swminmax()), #ts_norm_an(), ts_norm_ean(), ts_norm_gminmax(), ts_norm_swminmax()
                                      augment = list(ts_aug_jitter()), #ts_aug_jitter(), ts_aug_wormhole(), ts_aug_stretch(), ts_aug_shrink(), ts_aug_flip()
                                      ro = TRUE)
save(result_mlp_swminmax_jitter, file="saved/result_mlp_swminmax_jitter.RData")

result_mlp_swminmax_strech <- run_machine(dataset = dataset[2],
                                          base_model = base_model,
                                          sw_size = 8,
                                          input_size = 3:7,
                                          train_size = 56,
                                          test_size = 4,
                                          ranges = ranges,
                                          filter = ts_fil_none(), #ts_smooth(), ts_awareness(0.80), ts_aware_smooth(0.80)
                                          preprocess = list(ts_norm_swminmax()), #ts_norm_an(), ts_norm_ean(), ts_norm_gminmax(), ts_norm_swminmax()
                                          augment = list(ts_aug_stretch()), #ts_aug_jitter(), ts_aug_wormhole(), ts_aug_stretch(), ts_aug_shrink(), ts_aug_flip()
                                          ro = TRUE)
save(result_mlp_swminmax_strech, file="saved/result_mlp_swminmax_strech.RData")

