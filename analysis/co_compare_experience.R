#!/usr/bin/env Rscript

suppressPackageStartupMessages({
    library(HotTowelR)
    library(fixest)
    }
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

m <- felm(log(prior_earnings) ~ contractor.shown * tier | level2 | 0 |economic_opening, data = df.apps)
m <- feols(log(prior_earnings) ~ contractor.shown * tier | level2, data = df.apps)

df.shown <-  df.apps %>% filter(contractor.shown == TRUE)

df.shown <- df.apps %>% filter(contractor.shown == TRUE)
df.not.shown <- df.apps %>% filter(contractor.shown == FALSE)

m.prior_earnings.shown <- felm(log(prior_earnings) ~ tier - 1| 0 | 0 | economic_opening,
                               weights = 1/df.shown$num.apps, 
                               data = df.shown)
m.prior_earnings.shown <- feols(log(prior_earnings) ~ tier - 1,
                               weights = 1/df.shown$num.apps, 
                               data = df.shown)

m.prior_earnings.pool <- felm(log(prior_earnings) ~ tier * contractor.shown | 0 | 0 | economic_opening,
                               weights = 1/df.apps$num.apps, 
                               data = df.apps)
m.prior_earnings.pool <- feols(log(prior_earnings) ~ tier * contractor.shown,
                               weights = 1/df.apps$num.apps, 
                               data = df.apps)

m.prior_earnings.pool.ht <- felm(log(prior_earnings) ~ contractor.shown | 0 | 0 | economic_opening,
                               weights = 1/(df.apps %>% filter(tier == "High Tier") %$% num.apps), 
                               data = df.apps %>% filter(tier == "High Tier"))
m.prior_earnings.pool.ht <- feols(log(prior_earnings) ~ contractor.shown,
                               weights = 1/(df.apps %>% filter(tier == "High Tier") %$% num.apps), 
                               data = df.apps %>% filter(tier == "High Tier"))

vcov(m.prior_earnings.pool)[c("contractor.shownTRUE", "tierHigh Tier:contractor.shownTRUE"),
                            c("contractor.shownTRUE", "tierHigh Tier:contractor.shownTRUE")] %>% as.matrix

m.prior_earnings.not.shown <- felm(log(prior_earnings) ~ tier - 1 | 0 | 0 | economic_opening,
                                   weights = 1/df.not.shown$num.apps, 
                                   data = df.not.shown)
m.prior_earnings.not.shown <- feols(log(prior_earnings) ~ tier - 1,
                                   weights = 1/df.not.shown$num.apps, 
                                   data = df.not.shown)

m.prior_hours.shown <- felm(log(prior_hours) ~ tier - 1| 0 | 0 | economic_opening,
                            weights = 1/df.shown$num.apps, 
                            data = df.shown)
m.prior_hours.shown <- feols(log(prior_hours) ~ tier - 1,
                            weights = 1/df.shown$num.apps, 
                            data = df.shown)

m.prior_hours.not.shown <- felm(log(prior_hours) ~ tier - 1 | 0 | 0 | economic_opening,
                                weights = 1/df.not.shown$num.apps, 
                                data = df.not.shown)
m.prior_hours.not.shown <- feols(log(prior_hours) ~ tier - 1,
                                weights = 1/df.not.shown$num.apps, 
                                data = df.not.shown)

pr.label <- "Outcome:\nApplicant\nprior hours"
wb.label <- "Outcome:\nApplicant\nprior earnings"

tidy(m.prior_hours.not.shown) %>% mutate(model = "ShownPref = 0",
                                         outcome = pr.label,
                                         sample.size = m.prior_hours.not.shown$n.obs)

df.results <- rbind(
    tidy(m.prior_hours.not.shown) %>% mutate(model = "ShownPref = 0", outcome = pr.label, sample.size = m.prior_hours.not.shown$n.obs),
    tidy(m.prior_hours.shown) %>% mutate(model = "ShownPref = 1", outcome = pr.label, sample.size = m.prior_hours.shown$n.obs), 
    tidy(m.prior_earnings.not.shown) %>% mutate(model = "ShownPref = 0" , outcome = wb.label, sample.size = m.prior_earnings.not.shown$n.obs),
    tidy(m.prior_earnings.shown) %>% mutate(model = "ShownPref = 1", outcome = wb.label, sample.size = m.prior_earnings.shown$n.obs)) %>%
    mutate(no.group = !("group" %in% colnames(.))) %>% 
    filter(ifelse(no.group, TRUE, group == "fixed"))
    

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
           avg.effect = mean(estimate)
           )


saveRDS(df.results, "../computed_objects/compare_experience.rds")
