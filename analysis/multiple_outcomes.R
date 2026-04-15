#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

df.openings <- HotTowelR::GetOpenings()

df.ambiguous <- subset(df.openings,
                        is.first.opening
                        & (G4 | G5 | G6)
                        & !bad
                        & visibility != "private"
                        & num_applications > 0) %>%
    mutate(cs = contractor.shown) 

df.raw <- df.ambiguous %>%
    select(cs, tier, total_charge, num_applications) %>%
    mutate(filled = I(total_charge > 0), 
           l.num_applications = log(num_applications)
           ) %>%
    select(cs, tier, filled, l.num_applications) %>% 
    melt(id.vars = c("cs", "tier"))

## filled jobs 
df.raw <- df.ambiguous %>%
    filter(hours > 0 & total_charge > 0) %>% 
    mutate(
        l.total_charge = log(total_charge), 
        l.hours = log(hours), 
        l.mean_wage_over_contract = log(mean_wage_over_contract)
    ) %>%
    select(cs, tier, l.hours, l.mean_wage_over_contract, l.total_charge) %>% 
    melt(id.vars = c("cs", "tier"))

df.effects <- df.raw %>%
    group_by(cs, tier, variable) %>%
    summarize(mu = mean(value),
              se = sd(value)/sqrt(length(cs))
              ) %>%
    group_by(tier, variable) %>%
    summarize(tau = mu[cs == TRUE] - mu[cs == FALSE],
              se = sqrt(se[cs==TRUE]^2 + se[cs == FALSE]^2)
              )

g <- ggplot(data = df.effects, aes(x = tier, y = tau)) + geom_errorbar(aes(ymin = tau - 2*se, ymax = tau + 2*se)) + geom_point() +
    facet_wrap(~variable, ncol = 3, scale = "free_y") +
    geom_line(aes(group = variable), colour = "grey") +
    geom_hline(yintercept = 0, colour = "red") + 
    theme_bw()

JJHmisc::writeImage(g, "multiple_outcomes", path = "../writeup/plots/")


df.effects <- df.ambiguous %>%
    select(cs, tier, total_charge) %>% 
    group_by(cs, tier) %>%
    summarize(mu = mean(I(total_charge > 0)),
              se = sd(I(total_charge > 0))/sqrt(length(cs))
              ) %>%
    group_by(tier) %>%
    summarize(tau = mu[cs == TRUE] - mu[cs == FALSE],
              se = sqrt(se[cs==TRUE]^2 + se[cs == FALSE]^2)
              )




