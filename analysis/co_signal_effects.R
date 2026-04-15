#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
) 

outcome.min <- log(0.25)
outcome.max <- log(100)

df.q <- data.frame(q = seq(0.05, 0.95, 0.10)) %>%
    mutate(dummy.col = 1)

df.apps <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(lhr_charge_rate = log(hr_charge_rate)) %>%
    filter(lhr_charge_rate > log(0.25)) %>%
    filter(lhourly_rate_snap > log(0.25)) %>% 
    filter(prior_earnings >= 0) %>%
    filter(prior_hours >= 0) %>%
    mutate(lprior_hours = log(1 + prior_hours)) %>% 
    mutate(lprior_earnings = log(1 + prior_earnings)) %>%
    mutate(pct.markup = lhr_charge_rate - lhourly_rate_snap) %>% 
    select(lhourly_rate_snap, lhr_charge_rate, lprior_hours, lprior_earnings, cs, tier, economic_opening, pct.markup)

## restricted to application sent to first openings in the ambiguous arm 
df.delta <- df.apps %>%    
    melt(id.vars = c("cs", "tier", "economic_opening")) %>%
    mutate(dummy.col = 1) %>%
    left_join(df.q, by = "dummy.col") %>%
    group_by(economic_opening, tier, cs, q, variable) %>%
    summarise(
        pct = quantile(value, q[1])
    ) %>%
    group_by(variable, cs, tier, q) %>%
    summarize(avg.pct = mean(pct),
              se = sd(pct) / sqrt(length(variable))
              ) %>%
    group_by(variable, tier, q) %>%
    summarize(delta = avg.pct[cs == TRUE] - avg.pct[cs == FALSE],
              se.delta = sqrt(se[cs==TRUE]^2 + se[cs==FALSE]^2)
              )


saveRDS(df.delta, "../computed_objects/signal_effects.rds")


