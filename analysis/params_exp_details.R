#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

addParam <- JJHmisc::genParamAdder("../writeup/params_exp_details.tex")



df.openings.all <- readRDS("../etl/transformed/openings.rds") %>%
    filter( !bad
           & visibility != "private"
           & num_applications > 0)

df.openings <- df.openings.all %>% filter(is.first.opening)

allocations <- df.openings %>%
    filter(group != "G1: P/Q Choice Optional") %>%
    with(., table(ambigious.arm, contractor.shown)/nrow(.)) %>% multiply_by(100) %>% round(1)

addParam("\\AmbigShown", allocations[[2, 2]])
addParam("\\AmbigNotShown", allocations[[2, 1]])
addParam("\\ExpShown", allocations[[1, 2]])
addParam("\\ExpNotShown", allocations[[1, 1]])

allocations <- df.openings %>%
    filter(group != "G1: P/Q Choice Optional") %>%
    with(., table(ambigious.arm, contractor.shown)) 

addParam("\\AmbigShownN", allocations[[2, 2]] %>% formatC(big.mark = ","))
addParam("\\AmbigNotShownN", allocations[[2, 1]] %>% formatC(big.mark = ","))
addParam("\\ExpShownN", allocations[[1, 2]] %>% formatC(big.mark = ","))
addParam("\\ExpNotShownN", allocations[[1, 1]] %>% formatC(big.mark = ","))


date.end <- df.openings %$% allocated_ts %>% as.Date  %>% max %>% as.character
addParam("\\expEnd", date.end)

date.start <- df.openings %$% allocated_ts %>% as.Date  %>% min %>% as.character
addParam("\\expStart", date.start)


df.openings %>% nrow %>% formatC(big.mark = ",") %>% addParam("\\totalOpeningCount", .)

df.openings.all %>% nrow %>% formatC(big.mark = ",") %>% addParam("\\totalOpeningCountMultiple", .)
