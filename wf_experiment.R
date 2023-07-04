library(daltoolbox)
library(tspredit)
library(stringi)
library(dplyr)
library(stringr)

create_directories <- function() {
  if (!file.exists('hyper'))
    dir.create('hyper')
  if (!file.exists('graphics'))
    dir.create('graphics')
  if (!file.exists('results'))
    dir.create('results')
}

describe <- function(obj) {
  if (is.null(obj))
    return("")
  else
    return(as.character(class(obj)[1]))
}

run_arima <- function(dataset, train_size, test_size, ro=TRUE) {
  create_directories()
  base_model <- ts_arima()
  result <- NULL
  for (j in (1:length(dataset))) {
    myexp <- wf_experiment(names(dataset)[j], base_model, sw_size = 0, input_size = c(1), train_size = train_size, 
                           filter = ts_aug_none(), preprocess = list(ts_aug_none()), augment = list(ts_aug_none()), ranges = NULL) 
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
      save(result, file=sprintf("results/%s-ro.rdata", describe(myexp$base_model)))
    }
    else {
      results_sa <- NULL
      #steps ahead
      for (j in 1:test_size) {
        myexp <- test(myexp, x, test_pos = train_size + 1, test_size = j, steps_ahead = j, ro = FALSE)  
        results_sa <- rbind(results_sa, myexp$result)
      }
      result <- rbind(result, results_sa)
      save(result, file=sprintf("results/%s-sa.rdata", describe(myexp$base_model)))
    }
  }
  return(result)
}

run_machine <- function(dataset, base_model, sw_size, input_size, train_size, test_size, ranges, filter, preprocess, augment, ro=TRUE) {
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
    save(result, file=sprintf("results/%s-%s.rdata", describe(exp_template), suffix))
  }
  return(result)  
}

# class wf_experiment

wf_experiment <- function(name, base_model, sw_size, input_size, train_size, filter, preprocess, augment, ranges) {
  obj <- dal_transform()
  obj$name <- name
  obj$base_model <- base_model
  obj$sw_size <- sw_size
  obj$input_size <- input_size
  obj$desc_input_size <- stri_paste(as.character(input_size), collapse='_')  
  obj$train_size <- train_size
  obj$filter <- filter 
  obj$preprocess <- preprocess
  obj$desc_preprocess <- stri_paste(sapply(preprocess, function(x) { as.character(describe(x)) }), collapse='_')  
  obj$augment <- augment
  obj$desc_augment <- stri_paste(sapply(augment, function(x) { as.character(describe(x)) }), collapse='_')  
  obj$ranges <- ranges
  
  class(obj) <- append("wf_experiment", class(obj))    
  return(obj)
}

train <- function(obj, ...) {
  UseMethod("train")
}

train.default <- function(obj) {
  return(obj)
}

test <- function(obj, ...) {
  UseMethod("test")
}

test.default <- function(obj) {
  return(obj)
}

describe.wf_experiment <- function(obj) {
  result <- sprintf("%s-%d-%d-%s-%s-%s-%s", describe(obj$base_model), obj$sw_size, obj$train_size, 
                    obj$desc_input_size, obj$desc_augment, obj$desc_preprocess, obj$desc_augment)
  if(obj$name != "")
    result <- sprintf("%s-%s", obj$name, result)
  return (result)
}

train.wf_experiment <- function(obj, x) {
  x <- x[1:obj$train_size]
  x <- na.omit(x) 
  
  obj$train <- x[obj$sw_size:length(x)]
  obj$obs <- as.character(obj$train)
  if (length(names(obj$train)) > 0)
    obj$obs <- names(obj$train)[length(obj$train)]
  
  xw <- ts_data(as.vector(x), obj$sw_size)
  xw <- transform(obj$filter, xw)
  xy <- ts_projection(xw)      
  
  if (obj$sw_size != 0) {
    mytune <- ts_maintune(obj$input_size, obj$base_model, preprocess = obj$preprocess, augment = obj$augment)
    mytune$name <- describe(obj$base_model)
    obj$model <- fit(mytune, xy$input, xy$output, obj$ranges)
    obj$input_size <- obj$model$input_size
    obj$preprocess <- obj$model$preprocess
    obj$augment <- attr(obj$model, "augment")
  } else {
    obj$model <- fit(obj$base_model, x=xy$input, y=xy$output)
    obj$input_size <- 0
    obj$preprocess <- ts_aug_none()
    obj$augment <- ts_aug_none()
  }
  
  xw <- ts_data(as.vector(x), obj$sw_size)
  xy <- ts_projection(xw)      
  
  obj$adjust <- as.vector(predict(obj$model, xy$input))
  obj$ev_adjust <- evaluate(obj$model, as.vector(xy$output), obj$adjust)
  
  hyperparameters <- attr(obj$model, "hyperparameters")
  if (!is.null(hyperparameters))
    save(hyperparameters, file=tolower(sprintf("hyper/%s-hparams.rdata", describe(obj))))
  params <- attr(obj$model, "params")
  if (!is.null(params))
    save(params, file=tolower(sprintf("hyper/%s-params.rdata", describe(obj))))
  
  return(obj)
}

save_image <- function(obj, imagename, header) {
  jpeg(sprintf("graphics/%s", imagename), width = 640, height = 480)
  # 2. Create the plot
  yvalues <- c(obj$train, obj$test)
  xlabels <- 1:length(yvalues)
  if(!is.null(names(yvalues)))
    xlabels <- names(yvalues)
  plot_ts_pred(x = xlabels, y = yvalues, yadj=obj$adjust, ypre=obj$prediction)
  # 3. Close the file
  dev.off()
}

test.wf_experiment <- function(obj, x, test_pos, test_size, steps_ahead = 1, ro = TRUE) {
  obj$test <- x[test_pos:(test_pos+test_size-1)]
  if (obj$sw_size != 0)
    xwt <- ts_data(as.vector(x[(test_pos-obj$sw_size+1):(test_pos+test_size-1)]), obj$sw_size)
  else
    xwt <- ts_data(as.vector(x[test_pos:(test_pos+test_size-1)]), obj$sw_size)
  
  xyt <- ts_projection(xwt)    
  
  output <- as.vector(xyt$output)
  if (steps_ahead == 1)  {
    obj$prediction <- predict(obj$model, x=xyt$input, steps_ahead=steps_ahead)
  }
  else {
    obj$prediction <- predict(obj$model, x=xyt$input[1,], steps_ahead=steps_ahead)
    output <- output[1:steps_ahead]
  }  
  obj$prediction <- as.vector(obj$prediction)
  
  obj$ev_prediction <- evaluate(obj$model, output, obj$prediction)
  
  
  smape_train <- 100*obj$ev_adjust$smape
  smape_test <- 100*obj$ev_prediction$smape
  
  obj$result <- data.frame(name = obj$name, 
                           method = describe(obj$base_model), 
                           model = describe(obj$model), 
                           filter = describe(obj$filter),
                           preprocess = describe(obj$preprocess),
                           input_size = obj$input_size,
                           window_size = obj$sw_size,
                           augment = describe(obj$augment),
                           obs = obj$obs,
                           test_size = test_size,
                           steps_ahead = steps_ahead, 
                           smape_train = smape_train,
                           smape_test = smape_test)
  
  # 1. prepara o arquivo
  if (ro) {
    imagename <- tolower(sprintf("%s-ro%d.jpg", describe(obj), test_size))
    header <- sprintf("%s-ro%d", describe.wf_experiment(obj), test_size)
    save_image(obj, imagename, header)
  } 
  else {
    imagename <- tolower(sprintf("%s-sa%d.jpg", describe(obj), steps_ahead))
    header <- sprintf("%s-sa%d", describe.wf_experiment(obj), steps_ahead)
    save_image(obj, imagename, header)
  }
  return(obj)
}
