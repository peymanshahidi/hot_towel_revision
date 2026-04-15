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
    filter(hr_charge_rate > 0.25) %>%
    filter(status == "filled") %>%
    group_by(economic_opening) %>%
    mutate(num.apps = length(economic_opening))

## No evidence that revelation leads employer to be more likely to hire
## someone w/o experience

m <- felm(I(prior_earnings > 0) ~ contractor.shown * tier | 0 | 0 | economic_opening,
          data = df.apps)
m <- feols(I(prior_earnings > 0) ~ contractor.shown * tier,
          data = df.apps)


df.apps <- df.apps.raw %>%
    filter(hr_charge_rate > 0.25) %>%
    filter(prior_earnings > 0.25 & prior_hours > 0.25) %>%
    filter(status == "filled") %>%
    group_by(economic_opening) %>%
    mutate(num.apps = length(economic_opening))
    

################################
## Bidding up when tier is known
################################

df.shown <- df.apps %>% filter(contractor.shown == TRUE)
df.not.shown <- df.apps %>% filter(contractor.shown == FALSE)

## Bidding effects 
m.bidding.shown <- felm(log(prior_earnings) ~ tier - 1| 0 | 0 | economic_opening,
                        weights = 1/df.shown$num.apps, 
                        data = df.shown)
m.bidding.shown <- feols(log(prior_earnings) ~ tier - 1,
                        weights = 1/df.shown$num.apps, 
                        data = df.shown)

m.bidding.not.shown <- felm(log(prior_earnings) ~ tier - 1 | 0 | 0 | economic_opening,
                            weights = 1/df.not.shown$num.apps, 
                            data = df.not.shown)
m.bidding.not.shown <- feols(log(prior_earnings) ~ tier - 1,
                            weights = 1/df.not.shown$num.apps, 
                            data = df.not.shown)

m.pr.shown <- felm(log(prior_hours) ~ tier - 1| 0 | 0 | economic_opening,
                   weights = 1/df.shown$num.apps, 
                   data = df.shown)
m.pr.shown <- feols(log(prior_hours) ~ tier - 1,
                   weights = 1/df.shown$num.apps, 
                   data = df.shown)

m.pr.not.shown <- felm(log(prior_hours) ~ tier - 1 | 0 | 0 | economic_opening,
                       weights = 1/df.not.shown$num.apps, 
                        data = df.not.shown)
m.pr.not.shown <- feols(log(prior_hours) ~ tier - 1,
                       weights = 1/df.not.shown$num.apps, 
                        data = df.not.shown)

pr.label <- "Outcome:\nHired worker\nprior hours"
wb.label <- "Outcome:\nHired worker\nprior earnings"

## df.results <- rbind(
##     tidy(m.pr.not.shown) %>% mutate(model = "ShownPref = 0", outcome = pr.label, sample.size = nrow(model.frame(m.pr.not.shown))),
##     tidy(m.pr.shown) %>% mutate(model = "ShownPref = 1", outcome = pr.label, sample.size = nrow(model.frame(m.pr.shown))), 
##     tidy(m.bidding.not.shown) %>% mutate(model = "ShownPref = 0" , outcome = wb.label, sample.size = nrow(model.frame(m.bidding.not.shown))),
##     tidy(m.bidding.shown) %>% mutate(model = "ShownPref = 1", outcome = wb.label, sample.size = nrow(model.frame(m.bidding.shown)))
## )
df.results <- rbind(
    tidy(m.pr.not.shown) %>% mutate(model = "ShownPref = 0", outcome = pr.label, sample.size = m.pr.not.shown$n.obs),
    tidy(m.pr.shown) %>% mutate(model = "ShownPref = 1", outcome = pr.label, sample.size = m.pr.shown$n.obs), 
    tidy(m.bidding.not.shown) %>% mutate(model = "ShownPref = 0" , outcome = wb.label, sample.size = m.bidding.not.shown$n.obs),
    tidy(m.bidding.shown) %>% mutate(model = "ShownPref = 1", outcome = wb.label, sample.size = m.bidding.shown$n.obs)
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
           effect.pos = I(effect > 0),
           effect.se = sqrt(std.error[model=="ShownPref = 1"]^2 + std.error[model=="ShownPref = 0"]^2),
           avg.effect = mean(estimate))


saveRDS(df.results, "../computed_objects/compare_experience_hired.rds")
