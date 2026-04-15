#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

outcome.min <- log(0.25)
outcome.max <- log(100)

df.apps <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(outcome = lhourly_rate_snap)

models <- HotTowelR::appPoolPercentiles(df.apps,
                                        "lhourly_rate_snap",
                                        log(0.25),
                                        log(100))

out.file <-  "../writeup/tables/profile_rate_percentiles.tex"
HotTowelR::ProfileRatePercentiles(models, out.file)

