#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

## restricted to application sent to first openings in the ambiguous arm 
df.apps <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(outcome = log(1 + prior_earnings))

models <- HotTowelR::appPoolPercentiles(df.apps, "lprior_earnings", log(1), Inf)

out.file <-  "../writeup/tables/past_earnings_percentiles.tex"
HotTowelR::PastEarningsPercentiles(models, out.file)

