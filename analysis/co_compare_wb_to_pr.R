#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

outcome.min <- log(0.25)
outcome.max <- log(100)

df.apps.raw <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(outcome = log(hr_charge_rate))

df.apps <- df.apps.raw %>% filter(hr_charge_rate > 0.25) %>%
    filter(hourly_rate_snap > 0.25) %>%
    group_by(economic_opening) %>%
    mutate(num.apps = length(economic_opening))


df.shown <- df.apps %>% filter(contractor.shown == TRUE)
df.not.shown <- df.apps %>% filter(contractor.shown == FALSE)

m.bidding.shown <- felm(log(hr_charge_rate) ~ tier - 1 |0 | 0 | contractor,
                        weights = 1/df.shown$num.apps,
                        data = df.shown)

m.bidding.not.shown <- felm(log(hr_charge_rate) ~ tier - 1 | 0 | 0 | contractor, 
                            weights = 1/df.not.shown$num.apps,
                            data = df.not.shown)

m.pr.shown <- felm(log(hourly_rate_snap) ~ tier - 1| 0 | 0 | contractor,
                   weights = 1/df.shown$num.apps,
                   data = df.shown)

m.pr.not.shown <- felm(log(hourly_rate_snap) ~ tier - 1 | 0 | 0 | contractor,
                       weights = 1/df.not.shown$num.apps,
                       data = df.not.shown)

pr.label <- "Outcome:\nApplicant\nprofile rate"
wb.label <- "Outcome:\nApplicant\nwage bid"

df.results <- rbind(
    tidy(m.pr.not.shown) %>% mutate(model = "ShownPref = 0", outcome = pr.label, sample.size = nrow(model.frame(m.pr.not.shown))),
    tidy(m.pr.shown) %>% mutate(model = "ShownPref = 1", outcome = pr.label, sample.size = nrow(model.frame(m.pr.shown))), 
    tidy(m.bidding.not.shown) %>% mutate(model = "ShownPref = 0" , outcome = wb.label, sample.size = nrow(model.frame(m.bidding.not.shown))),
    tidy(m.bidding.shown) %>% mutate(model = "ShownPref = 1", outcome = wb.label, sample.size = nrow(model.frame(m.bidding.shown)))
) 

mt.label <- "Employer\nvertical preference:\nMedium"
ht.label <- "Employer\nvertical preference:\nHigh"
lt.label <- "Employer\nvertical preference:\nLow"
mapping <- list("tierMedium Tier" = mt.label,
                "tierHigh Tier" = ht.label, 
                "tierLow Tier" = lt.label)

df.results$new.term <- with(df.results, unlist(mapping[as.character(term)]))
df.results$new.term <- with(df.results, factor(new.term, levels = c(ht.label, mt.label, lt.label)))

df.results %<>% group_by(outcome, new.term) %>%
    mutate(effect = estimate[model=="ShownPref = 1"]- estimate[model=="ShownPref = 0"],
           effect.se = sqrt(std.error[model=="ShownPref = 1"]^2 + std.error[model=="ShownPref = 0"]^2),
           effect.pos = I(effect > 0),
           avg.effect = mean(estimate))


saveRDS(df.results, "../computed_objects/compare_wb_to_pr.rds")
