#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

out.file <- "../writeup/tables/hired_rate.tex"
df.openings <- HotTowelR::GetOpenings()

min.wage <- 0.05
min.time <- (1/6)

m.g2g3.wage <- lm(log(mean_wage_over_contract) ~ contractor.shown,
                  data = df.openings[is.first.opening & (G2 | G3) & hours > min.time &
                                     mean_wage_over_contract > min.wage])
m.ambig.wage <- lm(log(mean_wage_over_contract) ~ contractor.shown,
                   data = df.openings[is.first.opening & ambigious.arm & hours > min.time &
                                      mean_wage_over_contract > min.wage])
m.ambig.wage.i <- lm(log(mean_wage_over_contract)~ contractor.shown*tier,
                     data = df.openings[is.first.opening & ambigious.arm & hours > min.time &
                                        mean_wage_over_contract > min.wage])
covariate.labels <- c("P/Q choice shown to applicants, ShownPref", "Medium Tier (MT)", "High Tier (HT)",
                      "MT x ShownPref", "HT x ShownPref", "Constant")
column.labels <- c("Expl.", "Ambig.", "Ambig.")

sink(file = "/dev/null")
title = "Effect of p/q revelation on average log wages of hired workers"
s <- stargazer::stargazer(m.g2g3.wage, m.ambig.wage, m.ambig.wage.i,
                          title = title,
                          star.cutoffs = star.cutoffs,
                          star.char = star.char,
                          no.space = TRUE,
                          font.size = "small", 
                          covariate.labels = covariate.labels,
                          dep.var.labels = "Log mean wage over the relationship:", 
                          label = "tab:hired_rate",
                          omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
                          column.labels = column.labels
                          )
sink() 
note <- paste("This table reports OLS regressions where the dependent variable is the log mean wage of workers hired.
Standard errors are robust to heteroscedasticity.  \\starlanguage")

JJHmisc::AddTableNote(s, out.file, JJHmisc::NoteWrapper(note))






