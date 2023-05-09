library(devtools)
#devtools::install_github("cefet-rj-dal/tspred-it", force = TRUE, dep = FALSE, upgrade = "never")
library(tspredit)

data(fertilizers)

ts <- ts_data(fertilizers$brazil_n, sw = 8)

samp <- ts_sample(ts, test_size = 4)

io_train <- ts_projection(samp$train)

library(elmNNRcpp)
tune <- ts_maintune(preprocess = list(ts_swminmax()),
    input_size = c(3:7),
    base_model = ts_elm(),
    augment = list(ts_augment())
  )
ranges <- list(nhid = 1:20, 
               actfun=c('sig', 'radbas', 'tribas', 'relu', 'purelin'))
model <- fit(tune, 
             x = io_train$input, 
             y = io_train$output, 
             ranges)

adjust <- predict(model, io_train$input)
ev_adjust <- evaluation.tsreg(io_train$output, adjust)
print(ev_adjust$metrics$smape)


io_test <- ts_projection(samp$test)
prediction <- predict(model, x = io_test$input, steps_ahead = 1)
ev_test <- evaluation.tsreg(io_test$output, prediction)
print(ev_test$metrics$smape)


hyper <- attr(model,"hyperparameters")
