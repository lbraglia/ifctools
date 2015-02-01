library(microbenchmark)
library(ifctools)
source("oldsrc/fc_check.R")

## load vector of fiscal codes (cf)
load("data/cf_e_data.rda")
dim(cf)
