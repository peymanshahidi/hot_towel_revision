#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

outcome.min <- -1
outcome.max <-  1

df.apps <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(outcome = (hr_charge_rate - hourly_rate_snap)/(hourly_rate_snap))


models <- models <- HotTowelR::appPoolPercentiles(df.apps, "markup", -1, 1)
out.file <-  "../writeup/tables/markups.tex"
HotTowelR::MarkupPercentiles(models, out.file)
JJHmisc::writeImage(HotTowelR::CreatePlot(models, "Wage Bid Markup"), "markup_reg_viz", width = 7, height = 3,
                    path = plots.path)


