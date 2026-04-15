#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

outcome.min <- log(0.25)
outcome.max <- log(100)

df.apps.raw <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(outcome = log(hr_charge_rate)) %>%
    mutate(hired = status %in% c("filled"))

df.apps <- df.apps.raw %>%
    filter(hr_charge_rate > 0.01) %>%
    filter(prior_earnings > 0.01
           & prior_hours > 0.01) %>%
    group_by(economic_opening) %>%
    mutate(num.apps = length(economic_opening)) %>%
    filter(!is.na(level2)) %>%
    filter(hourly_rate_snap > 0.01) 


GetEffects <- function(m){
    df.skel <- expand.grid(contractor.shown = c(TRUE, FALSE),
                           tier = unique(df.apps$tier) %>% as.character)    
    df.skel$tier <- with(df.skel,
                         factor(tier,
                                levels = c("Low Tier",
                                           "Medium Tier", "High Tier")))
    V <- vcov(m)
    X <- model.matrix(~contractor.shown * tier, data = df.skel)[,-1]
    df.skel$y.hat <- as.numeric(X %*% coef(m))
    df.skel$se <- sqrt(as.numeric(unname(rowSums((X %*% V) * X))))
    df.skel
}

FitModel <- function(outcome, df = df.apps){
    felm(as.formula(paste0(outcome, "~ contractor.shown * tier |
level2 + odesk_hours_pref + engagement_duration_label + employer_country + first_skill | 0 |economic_opening")), data = df)
}

outcomes.1 <-FitModel("log(hr_charge_rate)") %>%
               GetEffects() %>% mutate(outcome = "Charge")
outcomes.2 <-FitModel("log(prior_hours)") %>%
               GetEffects() %>% mutate(outcome = "Prior Hours")
outcomes.3 <-FitModel("log(prior_earnings)") %>%
               GetEffects() %>% mutate(outcome = "Prior Earnings")
outcomes.4 <-FitModel("lhourly_rate_snap") %>%
               GetEffects() %>% mutate(outcome = "Hourly rate")
outcomes.5 <-FitModel("I(prior_hours > 0)", df = df.apps.raw) %>%
               GetEffects() %>% mutate(outcome = "Any hours")
outcomes.6 <-FitModel("hired", df = df.apps.raw) %>%
               GetEffects() %>% mutate(outcome = "Hired")
    
df.results <- rbind(outcomes.1,
                    outcomes.2,
                    outcomes.3,
                    outcomes.4,
                    outcomes.5,
                    outcomes.6
                    )

g <- ggplot(data = df.results, aes(x = tier, y = y.hat,
                                colour = contractor.shown,
                                group = contractor.shown,
                                fill = contractor.shown, 
                                linetype = contractor.shown),
            dodge = position_dodge(0.9)) +
    geom_line() +
    geom_point() +
    geom_ribbon(aes(ymin = y.hat - 2*se, ymax = y.hat + 2*se), alpha = 0.1) +
    theme_bw() +
    theme(legend.position = "none") +
    facet_wrap(~outcome, ncol = 2, scale = "free_y")

JJHmisc::writeImage(g, "compare_outcomes_controlled", path = "../writeup/plots/", width = 5, height = 5)


m <- felm(hired ~ contractor.shown * tier | contractor | 0| contractor, data = df.apps.raw)

