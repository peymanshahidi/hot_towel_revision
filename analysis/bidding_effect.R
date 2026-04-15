#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

outcome.min <- log(0.25)
outcome.max <- log(100)

df.apps.raw <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(outcome = log(hr_charge_rate))

df.apps <- df.apps.raw %>% filter(hr_charge_rate > 0.25) %>%
    filter(hourly_rate_snap > 0.25)

m.bidding <- felm(log(hr_charge_rate) ~ contractor.shown * tier | contractor | 0 | contractor, 
                  data = df.apps)

addParam <- JJHmisc::genParamAdder("../writeup/params_bidding_effect.tex")

extract.effect <- . %>%
    multiply_by(100) %>%
    round(1) 

addParam("\\BidIncreaseMedWorkerFE", m.bidding %>% coef
         %>% .[["tierMedium Tier"]]
         %>%  extract.effect)

addParam("\\BidIncreaseHighWorkerFE", m.bidding %>% coef
         %>% .[["tierHigh Tier"]]
         %>%  extract.effect)


addParam("\\BidChangeLowRevealedWorkerFE",
        m.bidding %>% coef %>% .[["contractor.shownTRUE"]]
         %>%  extract.effect)

addParam("\\BidChangeHighRevealedWorkerFE",
         (m.bidding %>% coef
         %>% .[["contractor.shownTRUE"]]
         %>%  extract.effect) +
         (m.bidding %>% coef
         %>% .[["contractor.shownTRUE:tierHigh Tier"]]
         %>%  extract.effect
         )
         )
    

m.pr <- felm(lhourly_rate_snap ~ contractor.shown * tier | contractor | 0 | contractor, 
                        data = df.apps %>% filter(hourly_rate_snap > 0.25))

m.hours <- felm(log(prior_hours) ~ contractor.shown * tier | contractor | 0 | contractor, 
                        data = df.apps %>% filter(prior_hours >= 0.25))


covariate.labels <- c("\\textsc{ShownPref}",
                      "\\textsc{MedTier}",
                      "\\textsc{HighTier}",
                      "\\textsc{MedTier} x \\textsc{ShownPref}",
                      "\\textsc{HighTier} x \\textsc{ShownPref}")

out.file <- "../writeup/tables/bidding_effect.tex"
sink(file = "/dev/null")
s <- stargazer(m.bidding, m.pr, m.hours,  
               title = paste("Worker wage bid, profile rate and experience at time of application, by employer vertical preference and revelation status"),
               no.space = TRUE,
               font.size = "small", 
               label = "tab:bidding_effect",
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
               covariate.labels = covariate.labels,
               dep.var.labels = c("Wage bid",
                                  "Profile rate",
                                  "Past hours"),
               add.lines = list(c("Worker FE", "Y", "Y", "Y"))
               )
sink()
note <- paste("This table reports estimates of Equation~\\ref{eq:bidding}.
The sample consists of all applications sent to job openings in the ambiguous arm of the experiment.
%\\signaldef{}.
%\\ambigdef{}. 
In each regression, a worker specific fixed effect is included.
Standard errors are clustered at the level of the individual worker.
The dependent variables are the worker's hourly wage bid, profile rate at time of application and past hours-worked at time of application, in Columns~(1), (2) and (3), respectively. 
 \\starlanguage") 
JJHmisc::AddTableNote(s, out.file, note = NoteWrapper(note, 1))


