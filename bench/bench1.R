## Comparing old pure-R implementation of check routine to new C one,
## regarding output provided (should be the same) and timing (1 execution,
## i know, just to have an idea).  Data is a 2385170 length vector of
## fiscal codes. 
Sys.time()
library(ifctools)
library(car)
library(microbenchmark)
source("oldsrc/fc_check.R")

## load vector of fiscal codes (cf)
load("data/codici_fiscali_test.rda")
length(cf)
## do tests with both the algorithms
microbenchmark(fc <- fc_check(cf),
               wf <- ifctools::wrong_fc(cf),
               times = 1)

table(fc, wf, useNA="if")
## only 1 difference in a fc of length 9 (fc_check gives NA, wrong_fc gives
## TRUE, which is better) 
sessionInfo()
