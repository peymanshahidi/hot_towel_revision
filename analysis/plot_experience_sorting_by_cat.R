#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

outcome.min <- log(0.25)
outcome.max <- log(100)

df.apps.raw <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(outcome = log(hr_charge_rate))


df.apps <- df.apps.raw %>%
    filter(hr_charge_rate > 0.01) %>%
    filter(prior_earnings > 0.01
           & prior_hours > 0.01) %>%
    group_by(economic_opening) %>%
    mutate(num.apps = length(economic_opening))

df.by.cat <- df.apps %>% group_by(contractor.shown, level1, tier) %>%
    summarise(mean.prior.earnings = mean(log(prior_earnings)),
              se = sd(log(prior_earnings))/sqrt(n())) %>%
    group_by(level1) %>%
    mutate(avg.earnings = mean(mean.prior.earnings)) %>%
    ungroup

df.by.cat$level1 <- with(df.by.cat, factor(level1))
df.by.cat$level1 <- with(df.by.cat, reorder(level1, avg.earnings, mean))

df.by.cat$tier <- with(df.by.cat, factor(tier, levels = c("Low Tier", "Medium Tier", "High Tier")))

df.by.cat <- df.by.cat[with(df.by.cat, order(level1, tier)), ]
                       
g <- ggplot(data = df.by.cat, aes(y = mean.prior.earnings, x = tier, shape = factor(contractor.shown), colour = factor(contractor.shown))) +
    geom_point(position = position_dodge(0.1)) +
    geom_errorbar(aes(ymin = mean.prior.earnings - 2*se, ymax = mean.prior.earnings + 2*se), width = 0, alpha = 0.25,
                    position = position_dodge(0.1)) + 
    geom_line(aes(group = contractor.shown), alpha = 0.5, position =  position_dodge(0.1)) + 
    facet_wrap(~level1, ncol = 9) +
    theme_bw() +
    theme(legend.position = "top") 

JJHmisc::writeImage(g, "experience_sorting_by_cat", path = "../writeup/plots/", width = 10, height = 4)

