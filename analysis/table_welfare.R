#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

outcome.min <- log(0.25)
outcome.max <- log(100)

df.apps.raw <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(outcome = log(hr_charge_rate))

# This is all applications 
#df.apps.raw <- readRDS("../etl/transformed/applications.rds")


df.apps.raw %<>%
    mutate(outcome = log(hr_charge_rate)) %>%
    filter(hr_charge_rate > 0.25) %>%
    filter(hourly_rate_snap > 0.25) %>%
    mutate(hired = I(status == "filled")) %>%
    mutate(expected.wage = hired * hr_charge_rate) %>%
    select(hired, contractor.shown, contractor, expected.wage)

df.apps <- df.apps.raw

m.within.hired <- felm(hired ~ contractor.shown | contractor | 0 | contractor,  data = df.apps)

m.within.ev <- felm(expected.wage ~ contractor.shown | contractor | 0 | contractor,  data = df.apps)


addParam <- JJHmisc::genParamAdder("../writeup/params_welfare.tex")

addParam("\\EffectOnHireProbability",
       (  (m.within.hired %>% coef %>% .[["contractor.shownTRUE"]]) / mean(df.apps$hired) ) %>% multiply_by(100) %>% round(1))
addParam("\\EffectOnExpectedWage",
       (  (m.within.ev %>% coef %>% .[["contractor.shownTRUE"]]) / mean(df.apps$expected.wage) ) %>% multiply_by(100) %>% round(1))

#coef(m.within.hired) / 
#coef(m.within.ev) / (df.apps$expected.wage %>% mean)


out.file <- "../writeup/tables/welfare.tex"

sink(file = "/dev/null")
s <- stargazer::stargazer(m.within.hired, m.within.ev,
                          title = paste("The effect of revelation on win probability and expected wage"), 
                          covariate.labels = c("\\textsc{ShownPref}"),
                          dep.var.labels = c("Hired", "Expected wage"),  
                          star.char = star.char,
                          no.space = TRUE,
                          font.size = "small", 
                          star.cutoffs = star.cutoffs,
                          add.lines = list(c("Worker FE", "Y", "Y")), 
                          omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
                          label = "tab:welfare"
                          )
sink()
note <- paste("The unit of analysis is the individual job application. \\starlanguage")

JJHmisc::AddTableNote(s, out.file, note =  JJHmisc::NoteWrapper(note))

