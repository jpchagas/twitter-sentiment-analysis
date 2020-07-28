 
library(testthat)
#library(shinytest)
source("Fibo.R")
test_results <- test_dir("tests/", reporter="summary")