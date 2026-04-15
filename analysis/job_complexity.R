#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

df.openings <- HotTowelR::GetOpenings() %>%
    group_by(employer) %>% 
    mutate(openings.per.employer = length(employer))


m.job.complexity <- felm(I(contractor_tier - 2) ~ log(job_desc_length) | employer | 0 | employer,
                         data = df.openings)

m.job.complexity.HT <- felm(HT ~ log(job_desc_length) | employer | 0 | employer,
                            data = df.openings)

sink(file = "/dev/null")
out.file <- "../writeup/tables/job_complexity.tex"
s <- stargazer(m.job.complexity.HT, m.job.complexity, 
               title = paste("Job description length (proxy for complexity)",
                   " and employer P/Q preference, with employer specific fixed",
                   "effects"),
               label = "tab:job_complexity",
               dep.var.labels = c("Select High Tier",
                   "Tier (-1 = Low, 0 = Medium, 1 = High)")
               )
sink()
JJHmisc::AddTableNote(s, out.file, NoteWrapper(
    paste("The sample consists of all vacancies by allocated employers.",
          "An employer-specific fixed-effect is included in both regressions.",
          "Standard errors are clustered at the employer lelvel.",
          "\\starlanguage")))

