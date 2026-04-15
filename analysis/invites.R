#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

out.file <- "../writeup/tables/invites.tex"

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

df.ambiguous$filled <- with(df.ambiguous, total_charge > 0)
df.explicit$filled <- with(df.explicit, total_charge > 0)


m.has.late.invites <- lm(I(num_late_invites > 0) ~ tier*contractor.shown,
                           data = df.ambiguous)

m.has.early.invites <- lm(I(num_early_invites > 0) ~ tier*contractor.shown,
                           data = df.ambiguous)
m.has.invites <- lm(I(num_invites > 0) ~ tier*contractor.shown,
                    data = df.ambiguous)
               
m.accept.ratio <- lm(I(num_accepted_invites/num_invites) ~
                     tier * contractor.shown,
                     data = subset(df.ambiguous,
                         num_invites > 0
                         & num_invites < 5))


sink(file = "/dev/null")
s <- stargazer(m.has.late.invites, m.has.early.invites,
               m.has.invites, m.accept.ratio, 
               title = "Effects of price/quality revelation on employer recruiting",
               label = "tab:invites",
               font.size = "small", 
               covariate.labels = c("Medium Tier", "High Tier", "ShownPref",
                   "MT x ShownPref", "HT x ShownPref", "Constant"),
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
               dep.var.labels = c("Any late", "Any early", "Any",
                   "Acceptance Rate")
        )
sink()
note <- paste("The sample consists of the first vacancies by ambiguous",
              "arm employers.",
              "\\starlanguage")

JJHmisc::AddTableNote(s, out.file, note = NoteWrapper(note))
