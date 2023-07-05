source("carrega.R")
source("wf_experiment.R")

base_model = ts_conv1d()
ranges <- list(epochs=10000)

result_conv1d_an_is <- run_machine(dataset = dataset[2],
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
save(result_conv1d_an_is, file="saved/result_conv1d_an_is.RData")

