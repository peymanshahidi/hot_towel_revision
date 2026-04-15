#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

outcome.min <- log(0.25)
outcome.max <- log(100)

df.apps <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(outcome = log(hr_charge_rate))


models <- models <- HotTowelR::appPoolPercentiles(df.apps, "lhr_charge_rate", log(0.25), log(100))

out.file <-  "../writeup/tables/wage_bid_percentiles.tex"
HotTowelR::WageBidPercentiles(models, out.file)
JJHmisc::writeImage(HotTowelR::CreatePlot(models, "Log wage bid"),
                    "wage_bid_reg_viz", width = 7, height = 3, path = plots.path)


models <- HotTowelR::appPoolPercentiles(df.apps,
                                        "lhourly_rate_snap",
                                        log(0.25),
                                        log(100))

out.file <-  "../writeup/tables/profile_rate_percentiles.tex"
HotTowelR::ProfileRatePercentiles(models, out.file)

