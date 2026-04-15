#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)




df.reveal <- readRDS("../etl/transformed/openings.rds") %>%
    filter((G2 | G3) & !is.na(contractor_tier) & is.first.opening)

test <- chisq.test(table(df.reveal$contractor.shown, df.reveal$contractor_tier))

addParam <- JJHmisc::genParamAdder("../writeup/params_chi_square.tex")

addParam("\\pValue", round(test$p.value, 2))

