#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)
library(directlabels)


## This doesn't make any sense for the context.

outcome.min <- 1
outcome.max <- 1000

df.q <- data.frame(q = seq(0.05, 0.95, 0.05)) %>%
    mutate(dummy.col = 1)

df.num.apps <- data.frame(readRDS("../etl/transformed/small_applications.rds")) %>%
    filter(ambigious.arm == TRUE) %>%
    filter(is.first.opening == TRUE) %>%
    group_by(economic_opening, cs, tier, level1, level2, ambigious.arm, is.first.opening) %>%
    summarize(num.apps = length(economic_opening))

g <- ggplot(data = df.num.apps, aes(x = log(num.apps), linetype = cs)) + geom_density() +
    facet_grid(tier ~ level1, scale = "free_y")

JJHmisc::writeImage(g, "application_reg_vizs", path = "../writeup/plots/")
