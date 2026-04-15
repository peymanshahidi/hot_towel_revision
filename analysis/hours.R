#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

out.file <- "../writeup/tables/hours.tex"

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


m.ambig.i <- lfe::felm(log(hours) ~  tier * contractor.shown | level1|0|employer, 
                       data = subset(df.openings, (G4 | G5| G6) & hours > 0))
df.ambiguous.hours <- subset(df.ambiguous, hours > 0)
df.ambiguous.hours$l.hours <- with(df.ambiguous.hours, log(hours))

m.g2g3.hours <- lm(log(hours) ~ contractor.shown,
                   data = subset(df.explicit, hours > 1))
m.ambig.hours <- lm(log(hours) ~ contractor.shown,
                    data = subset(df.ambiguous, hours > 1))
m.ambig.hours.i <- lm(log(hours)~ contractor.shown*tier,
                      data = subset(df.ambiguous, hours > 1))
covariate.labels <- c("P/Q choice shown to applicants, ShownPref", "Medium Tier (MT)", "High Tier (HT)",
                      "MT x ShownPref", "HT x ShownPref", "Constant")
column.labels <- c("Expl.", "Ambig.", "Ambig.")
sink(file = "/dev/null")
s <- stargazer::stargazer(m.g2g3.hours, m.ambig.hours, m.ambig.hours.i,
                          title = "Effect of p/q revelation on log hours worked, conditional upon more than 1 hour",
                          label = "tab:hours",
                          dep.var.labels = c("Log hours worked:"), 
                          star.cutoffs = star.cutoffs, 
                          star.char = star.char,
                          font.size = "small", 
                          no.space = TRUE,
                          covariate.labels = covariate.labels,  
                          omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
                          column.labels = column.labels
                          )
sink()

note <- paste("This table reports OLS regressions where the dependent variable is the log hours worked following a hire.
\\starlanguage")


JJHmisc::AddTableNote(s, out.file, JJHmisc::NoteWrapper(note))

