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

TierEntropy <- function(x) {
    freq <- (table(x)/length(x)) %>% as.vector
    -sum(log2(freq))
}

df.worker <- df.apps %>%
    group_by(contractor.shown) %>%
    mutate(num.openings = n()) %>%
    ungroup %>% 
    mutate(tier = contractor_tier - 2) %>%
    group_by(contractor) %>%
    mutate(num.apps.total = length(contractor),
           num.hires = sum(I(status == "filled")),
           num.apps.shown = sum(contractor.shown %>% as.logical %>% as.numeric),
           num.apps.not.shown = length(contractor) -  sum(contractor.shown %>% as.logical %>% as.numeric)
           ) %>%
    filter(num.apps.total > 1) %>% 
    ungroup %>% 
    group_by(contractor, contractor.shown) %>%
    summarise(tier.var = var(tier),
              num.apps = length(contractor),
              num.apps.scaled = length(contractor)/num.openings[1],
              num.hires.scaled = num.hires[1] / num.apps, 
              entropy = TierEntropy(tier),
              mean.tier = mean(tier),
              frac.not.low = mean(I(tier > -1))/length(contractor),
              frac.not.low.var = sqrt(frac.not.low * (1-frac.not.low))
              ) 

df.worker %<>% mutate(contractor.shown = as.logical(as.character(contractor.shown)))

df.worker %<>% ungroup %>%
    group_by(contractor) %>%
    mutate(same.num.apps = num.apps[contractor.shown][1] == num.apps[!contractor.shown][1])

m <- felm(log1p(num.apps) ~ contractor.shown | contractor | 0 | contractor, data = df.worker)

m <- felm(log(num.apps.scaled) ~ contractor.shown | contractor | 0 | contractor, data = df.worker)

m <- felm(num.hires.scaled ~ contractor.shown | contractor | 0 | contractor, data = df.worker)

m.1 <- felm(frac.not.low  ~ contractor.shown | 0 | 0 | contractor, data = df.worker)


m <- felm(log1p(num.apps) ~ contractor.shown | 0 | 0 | contractor, data = df.worker)


m.2 <- felm(frac.not.low  ~ contractor.shown | 0 | 0 | contractor,
          data = df.worker %>% filter(num.apps > 1))

m.3 <- felm(frac.not.low.var ~ contractor.shown | 0 | 0 | contractor,
          data = df.worker %>% filter(num.apps > 1 & same.num.apps))

m.4 <- felm(frac.not.low.var ~ contractor.shown | 0 | 0 | contractor,
          data = df.worker %>% filter(num.apps > 1))

m.5 <- felm(entropy ~ contractor.shown | 0 | 0 | contractor,
          data = df.worker %>% filter(num.apps > 1 & same.num.apps))

m.6 <- felm(entropy ~ contractor.shown | 0 | 0 | contractor,
          data = df.worker %>% filter(num.apps > 1))


addParam <- JJHmisc::genParamAdder("../writeup/params_worker_targeted_apps.tex")

extract.effect <- . %>%
      multiply_by(100) %>%
          round(1)

addParam("\\WorkerAppTierVarEffect",
         m.3 %>%
         coef %>% (function(x)
             x[["contractor.shownTRUE"]] / x[["(Intercept)"]]) %>%
         extract.effect
          )

covariate.labels <- c("\\textsc{ShownPref}")

out.file <- "../writeup/tables/worker_targeted_apps.tex"
sink(file = "/dev/null")
s <- stargazer(m.1, m.2, m.3, m.4,
               title = "Effects of employer vertical preference revelation on the mean and dispersion in reported signal of the applied-to job openings",
               no.space = TRUE,
               font.size = "small", 
               label = "tab:worker_targeted_apps",
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
               covariate.labels = covariate.labels,
               add.lines = list(c("Same Num Apps?", "N", "Y", "N","Y")), 
               dep.var.labels = c("Avg. Tier",
                                  "Tier Variance",
                                  "Tier Variance")
               )
sink()
note <- paste("
This table reports regressions where the outcome is a measure of the worker's average tier and tier dispersion on whether the applications were sent to job openings where the vertical preference was revealed.
The employer tier selection is transformed into a continuous outcome, with values of -1, 0, and 1 for low, medium, and high, respectively.
The sample was constructed by taking all applications by all workers and then computing statistics on a per-worker and per-revelation level.
Standard errors are clustered at the individual worker level. 
In Columns~(2) and (4), the sample is restricted to only those workers that sent more than one application.
In Column~(1) and (2), the sample is further restricted to workers that send the same number of applications to $\\textsc{ShownPref}=1$ openings as $\\textsc{ShownPref}=0$ openings.
 \\starlanguage") 
AddTableNote(s, out.file, note = NoteWrapper(note, 1))


