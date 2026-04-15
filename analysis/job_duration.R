#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

df.openings <- HotTowelR::GetOpenings() %>%
    group_by(employer) %>% 
    mutate(durations.per.employer = length(unique(duration_weeks)))

HotTowelR::ProjectDurationTierChoice(df.openings, "../writeup/tables/job_duration.tex")
