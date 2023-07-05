source("carrega.R")
source("wf_experiment.R")


run_machine <- function(filename, dataset, base_model, sw_size, input_size, train_size, test_size, ranges, filter, preprocess, augment, ro=TRUE) {
  create_directories()
  result <- NULL
  exp_template <- wf_experiment("", base_model = base_model, sw_size = sw_size, input_size = input_size, train_size = train_size, 
                                filter = filter,  preprocess = preprocess, augment = augment, ranges = ranges) 
  if (ro)
    suffix <- "ro"
  else
    suffix <- "sa"
  for (j in (1:length(dataset))) {
    myexp <- exp_template
    myexp$name <- names(dataset)[j]
    x <- dataset[[j]]
    myexp <- train(myexp, x)  
    steps_ahead <- 1    
    for (j in 1:test_size) {
      if (!ro)
        steps_ahead <- j    
      myexp <- test(myexp, x, test_pos = train_size + 1, test_size = j, steps_ahead = steps_ahead, ro=ro)  
      result <- rbind(result, myexp$result)
    }
    save(result, file=filename)
  }
  return(result)  
}


base_model = ts_elm()
ranges <- list(nhid = 1:20, actfun=c('sig', 'radbas', 'tribas', 'relu', 'purelin'))

result_elm_an_is <- run_machine(dataset = dataset[2],
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
save(result_elm_an_is, file="saved/result_elm_an_is.RData")
