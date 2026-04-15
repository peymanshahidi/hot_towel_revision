#!/usr/bin/env Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)
library(broom)
library(ggrepel)
library(directlabels)

outcome.min <- log(0.25)
outcome.max <- log(100)

df.apps.raw <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(outcome = log(hr_charge_rate))

df.apps <- df.apps.raw %>% filter(hr_charge_rate > 0.25) %>%
    filter(hourly_rate_snap > 0.25) %>%
    filter(status == "filled")

################################
## Bidding up when tier is known
################################

## Bidding effects 
m.bidding.shown <- felm(log(hr_charge_rate) ~ tier - 1| 0 | 0 | 0,
                        data = df.apps %>% filter(contractor.shown == TRUE))

m.bidding.not.shown <- felm(log(hr_charge_rate) ~ tier - 1 | 0 | 0 | 0,
                        data = df.apps %>% filter(contractor.shown == FALSE))

m.pr.shown <- felm(log(hourly_rate_snap) ~ tier - 1| 0 | 0 | 0,
                        data = df.apps %>% filter(contractor.shown == TRUE))

m.pr.not.shown <- felm(log(hourly_rate_snap) ~ tier - 1 | 0 | 0 | 0,
                        data = df.apps %>% filter(contractor.shown == FALSE))


df.results <- rbind(
    tidy(m.pr.not.shown) %>% mutate(model = "not shown", outcome = "Profile rate", sample.size = nrow(model.frame(m.pr.not.shown))),
    tidy(m.pr.shown) %>% mutate(model = "shown", outcome = "Profile rate", sample.size = nrow(model.frame(m.pr.shown))), 
    tidy(m.bidding.not.shown) %>% mutate(model = "not shown" , outcome = "Wage bid", sample.size = nrow(model.frame(m.bidding.not.shown))),
    tidy(m.bidding.shown) %>% mutate(model = "shown", outcome = "Wage bid", sample.size = nrow(model.frame(m.bidding.shown)))
)
mapping <- list("tierMedium Tier" = "Medium",
                "tierHigh Tier" = "High",
                "tierLow Tier" = "Low")
df.results$new.term <- with(df.results, unlist(mapping[as.character(term)]))
df.results$new.term <- with(df.results, factor(new.term, levels = c("High", "Medium", "Low")))

df.results %<>% group_by(outcome, new.term) %>%
    mutate(effect = estimate[model=="shown"]- estimate[model=="not shown"],
           effect.pos = I(effect > 0),
           avg.effect = mean(estimate))

gap <- 0.2
g <- ggplot(data = df.results,
            aes(x = outcome, y = estimate, shape = model)) +
    geom_errorbar(aes(
        ymin = estimate - 2*std.error,
        ymax = estimate + 2*std.error
    ), width = 0.1, position = position_dodge(gap)) +
    facet_wrap(~ new.term, ncol = 1) + 
    geom_point(position = position_dodge(gap)) +
    geom_line(aes(group = outcome, colour = factor(effect.pos)), alpha = 0.5, size = 4) +
    geom_text(data = df.results %>% filter(abs(effect) > 0.01),
              aes(y = avg.effect, x = outcome, label = formatC(round(effect,2),digits = 2)), nudge_x = 0.35) +  
    coord_flip() +
    theme_bw() +
    geom_text_repel(data = df.results %>% filter(new.term == "Low") %>% filter(outcome == "Wage bid"),
                     aes(label = model), force = 3, max.iter = 1000, size = 3) +
    scale_colour_manual(values = c(brewer.neg, brewer.pos)) +
    theme(legend.position = "top")

JJHmisc::writeImage(g, "compare_wb_to_pr_hired", path = "../writeup/plots/", width = 6, height = 4)

