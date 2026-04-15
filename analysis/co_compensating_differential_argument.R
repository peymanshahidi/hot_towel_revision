#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

df.openings <- readRDS("../etl/transformed/openings.rds")  %>%
    as.data.frame %>% 
    mutate(
        log.num.apps = log(num_applications),
        any.interviews = I(num_organic_applicants_interviewed > 0),
        any.hires = I(num_hires > 0), 
        log.wage = log(mean_wage_over_contract),
        log.hours = log(hours),
        log.total_charge = ifelse(total_charge > 0, log(total_charge), 0)
        )


m.1 <- felm(scale(average_feedback_to_contractor) ~ tier | level2 | 0 |0,
          data = df.openings %>% filter(ambigious.arm) %>% filter(!contractor.shown))

m.2 <- felm(scale(nps_score_cli) ~ tier | level2 | 0 |0,
          data = df.openings %>% filter(ambigious.arm) %>% filter(!contractor.shown))

m.3 <- felm(scale(nps_score_cli) ~ tier * contractor.shown | level2 | 0 |0,
          data = df.openings %>% filter(ambigious.arm))

m.4 <- felm(scale(nps_score_cli) ~  tier + contractor.shown| level2 | 0 |0,
          data = df.openings %>% filter(ambigious.arm))

saveRDS(list("m.1" = m.1,
             "m.2" = m.2,
             "m.3" = m.3,
             "m.4" = m.4), "../computed_objects/compensating_differential_argument.rds")

