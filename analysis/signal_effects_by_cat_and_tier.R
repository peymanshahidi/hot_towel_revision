#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)
library(directlabels)

outcome.min <- log(0.25)
outcome.max <- log(100)

df.q <- data.frame(q = seq(0.05, 0.95, 0.05)) %>%
    mutate(dummy.col = 1)

## restricted to application sent to first openings in the ambiguous arm 
df.apps <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(outcome = lhourly_rate_snap) %>%
    filter(outcome > outcome.min) %>%
    filter(outcome < outcome.max) %>%
    filter(ambigious.arm == TRUE) %>%
    filter(is.first.opening == TRUE) %>%
    select(outcome, economic_opening, cs, tier, level1, level2, ambigious.arm, is.first.opening) %>%
    mutate(dummy.col = 1) 

df.combo <- df.apps %>% left_join(df.q, by = "dummy.col") %>%
        group_by(economic_opening, tier, cs, level1, level2, q) %>%
        summarise(mu = mean(outcome),
                  sigma = sd(outcome),
                  pct = quantile(outcome, q[1])
                  )

df.summary.two <- df.combo %>% group_by(tier, cs, level1, q) %>%
    summarise(mean.pct = mean(pct)) %>%
    ungroup %>% 
    group_by(tier, level1, q) %>%
    summarise(delta = mean.pct[cs == TRUE] - mean.pct[cs == FALSE])


g <- ggplot(data = df.summary.two, aes(x = q, y = delta, linetype = factor(tier))) +
    geom_line() +
    geom_hline(yintercept = 0, colour = "red") + 
    facet_wrap(~level1, scale = "free_y", ncol = 3) +
    expand_limits(x = 1.2) + 
    theme_bw() +
    geom_dl(aes(label = tier), method = "last.points") +
    xlab("Quantile of the application pool") +
    ylab("Difference in log outcomes quantile, from p/q shown versus not shown")

writeImage(g, "signal_effects_by_cat_and_tier", path = "../writeup/plots/")

