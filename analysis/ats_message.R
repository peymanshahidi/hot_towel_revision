#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

df.openings <- HotTowelR::GetOpenings()

df.ambiguous <- subset(df.openings,
                        is.first.opening
                        & (G4 | G5 | G6)
                        & !bad
                        & visibility != "private"
                        & num_applications > 0)

m.filled <- lm(I(total_charge > 0) ~  ats.message * tier,
               data = subset(df.ambiguous, contractor.shown))


m.wage.bill <- lm(log(total_charge) ~ ats.message * tier,
                  data = subset(df.ambiguous, contractor.shown & total_charge > 0))

m.wage <- lm(log(mean_wage_over_contract) ~ ats.message * tier,
             data = subset(df.ambiguous, contractor.shown & mean_wage_over_contract > 0))

m.hours <- lm(log(hours) ~ ats.message * tier,
              data = subset(df.ambiguous, contractor.shown & hours > 0))

m.fb <- lm(average_feedback_to_contractor ~ ats.message * tier,
           data = subset(df.ambiguous, contractor.shown & average_feedback_to_contractor > 0))

covariate.labels = c("Messaging", "Medium Tier (MT)", "High Tier (HT)",
                    "MT x Messaging", "HT x Messaging", "Constant") 
out.file <- "../writeup/tables/ats_message.tex"
sink(file = "/dev/null")

s <- stargazer(m.filled, m.wage.bill, m.wage, m.hours, m.fb,       
               title = "Effects of messaging about p/q revelation in the ambiguous arm on a variety of outcomes",
               label = "tab:ats",
        omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
        dep.var.labels = c("Filled", "Log Wage Bill", "Log Mean Wage", "Log hours", "FB to Worker"),
        covariate.labels = covariate.labels, 
        font.size = "footnotesize"
        )

sink()
note <- paste("This table reports OLS regressions on a number of opening outcomes on an indicator, Messaging, for whether the realized value of ShownPref was shown to employers again before they screened would-be applicants.
The sample consists of openings from the ambiguous arm.
\\ambigdef
\\shownprefdef
\\tierdef
Standard errors are robust to heteroscedasticity.  \\starlanguage")
JJHmisc::AddTableNote(s, out.file, NoteWrapper(note, 1))
