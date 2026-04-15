#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

models <- readRDS("../computed_objects/condition_on_pool_size.rds")
m <- models[["ols"]]
m.fs <- models[["first_stage"]]
m.iv <- models[["iv"]]

covariate.labels <- c("\\textsc{ShownPref}",
                      "\\textsc{MedTier}",
                      "\\textsc{HighTier}",
                      "\\textsc{MedTier} x \\textsc{ShownPref}",
                      "\\textsc{HighTier} x \\textsc{ShownPref}")


addParam <- JJHmisc::genParamAdder("../writeup/params_condition_on_pool_size.tex")
extract.effect <- . %>%
      multiply_by(100) %>%
    round(1)

addParam("\\PoolSizeIV",
         m.iv %>% coef %>% .[["`log(num_organic_applications)(fit)`"]] %>% extract.effect
         )

addParam("\\IVcondFstat",
         condfstat(m.iv) %>% as.numeric %>% round(2)
         )

out.file <- "../writeup/tables/condition_on_pool_size.tex"
sink(file = "/dev/null")
s <- stargazer(m, m.fs, m.iv,  
               title = paste("Effects of applicant pool size on individual wage bidding behavior"),
               no.space = TRUE,
               font.size = "small",
               label = "tab:condition_on_pool_size",
               omit.stat = c("aic", "adj.rsq", "ll", "bic", "ser"),
               dep.var.labels = c("Wage Bid", "Log Apps", "Wage Bid"),
               add.lines = list(c("Worker FE", "Y", "Y")), 
               covariate.labels = c("Log num apps", "IV", "Log num apps (instrumented)")
               )
sink()
note <- paste("This table reports regressions that explore the relationship between applicant pool size and individual wage bidding.
In Column~(1), the OLS estimate of log wage bids on log pool size is reported, with a worker-specific fixed effect.
In Column~(2), the first stage of an IV regression regression is reported, where the IV is the mean log number of applications received by job openings posted the same day, and in the same work category, as the ``focal'' job opening (but not including that opening).
In Column~(3), the second stage of the IV regression is reported.
The sample consists of all applications to exeriment job openings that received at least two applications. 
 \\starlanguage") 
JJHmisc::AddTableNote(s, out.file, note = NoteWrapper(note, 0.8))


