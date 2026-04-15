#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)


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
                        & num_applications > 0) %>%
    mutate(num_late_invites = num_invites - num_early_invites)

m.success <- lm(I(successes > 0) ~ contractor.shown, data = df.explicit)
m.success.ambig <- lm(I(successes > 0) ~ contractor.shown,
                data = df.ambiguous)
m.success.ambig.i <- lm(I(successes > 0) ~ tier*contractor.shown,
                data = df.ambiguous)

out.file <- "../writeup/tables/success.tex"
sink(file = "/dev/null")
s <- stargazer(m.success, m.success.ambig, m.success.ambig.i, 
               title = "Employer rated the project a success",
               label = "tab:success",
               covariate.labels = c("Medium Tier (MT)", "High Tier (HT)", "ShownPref",
                   "MT x ShownPref", "HT x ShownPref", "Constant"), 
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
               column.labels = c("Explicit", "Ambig", "Ambig")
               )
sink() 
JJHmisc::AddTableNote(s, out.file, NoteWrapper("Here are some notes TK"))
