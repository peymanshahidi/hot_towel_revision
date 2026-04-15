#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

outcome.min <- log(0.25)
outcome.max <- log(100)

df.apps.raw <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(date.level.2 = paste0(level2, date)) %>% 
    filter(num_organic_applications > 1) %>%
    group_by(date.level.2) %>%
    mutate(num.apps.iv.2 = (sum(log(num_organic_applications)) -
                          log(num_organic_applications))/(length(date.level.2) - 1)
           ) %>%
    ungroup %>%
    mutate(date.level.1 = paste0(level1, date)) %>% 
    group_by(date.level.1) %>%
    mutate(num.apps.iv.1 = (sum(log(num_organic_applications)) -
                          log(num_organic_applications))/(length(date.level.1) - 1)
           ) 


m.fs <- felm(log(num_organic_applications) ~ num.apps.iv.1 | contractor | 0 | contractor,
             data = df.apps.raw %>% filter(hr_charge_rate > 1))

m <- felm(log(hr_charge_rate) ~ log(num_organic_applications) | contractor | 0 | contractor,
          data = df.apps.raw %>% filter(hr_charge_rate > 1))

m.1 <- felm(log(hr_charge_rate) ~ 1 | contractor + date | (log(num_organic_applications) ~ num.apps.iv.1) | contractor,
          data = df.apps.raw %>% filter(hr_charge_rate > 1))

## m.2 <- felm(log(hr_charge_rate) ~ 1 | contractor + date | (log(num_organic_applications) ~ num.apps.iv.2) |
##               contractor,
##             data = df.apps.raw %>% filter(hr_charge_rate > 1))


saveRDS(list("first_stage" = m.fs,
             "ols" = m,
             "iv" = m.1), "../computed_objects/condition_on_pool_size.rds")
