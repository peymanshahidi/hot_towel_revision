#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

out.file <- "../writeup/tables/fills.tex"

df.openings <- HotTowelR::GetOpenings()


df.explicit <- subset(df.openings, is.first.opening
                       & (G2 | G3)
                       & !bad
                       & visibility != "private"
                       & num_applications > 0)

df.ambiguous <- subset(df.openings,
                        is.first.opening
                        & (G4 | G5 | G6)
                        & !bad
                        & visibility != "private"
                        & num_applications > 0)

df.ambiguous$filled <- with(df.ambiguous, total_charge > 0)
df.explicit$filled <- with(df.explicit, total_charge > 0)

m.fill <- lm(filled ~ contractor.shown, data = df.explicit)
m.fill.ambig <- lm(filled ~ contractor.shown, data = df.ambiguous)
m.fill.ambig.i <- lm(filled ~ contractor.shown*tier, data = df.ambiguous)

sink(file = "/dev/null")
s <- stargazer::stargazer(m.fill, m.fill.ambig, m.fill.ambig.i,
                          title = paste("The effect of p/q revelation on the quantity of matches formed"), 
                          covariate.labels = c("P/Q choice shown to applicants, ShownPref",
                                               "Medium Tier (MT)", "High Tier (HT)",
                                               "HT x ShownPref", "MT x ShownPref"),
                          dep.var.labels = "Employer hired:", 
                          column.labels = c("Expl.", "Ambig.", "Ambig."),
                          star.char = star.char,
                          no.space = TRUE,
                          font.size = "small", 
                          star.cutoffs = star.cutoffs, 
                          omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
                          label = "tab:fills"
                          )
sink()
note <- paste("This table reports OLS regressions where the dependent variable is an indicator for whether the employer hired. \\starlanguage")

JJHmisc::AddTableNote(s, out.file, note =  JJHmisc::NoteWrapper(note))
