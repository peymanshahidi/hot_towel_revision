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


m.ambig.any <- lm(I(num_viewed > 0) ~ tier*contractor.shown, data = df.ambiguous)
m.ambig.rate <- lm(I(num_viewed/num_applications) ~ tier*contractor.shown, data = df.ambiguous)

note <- paste("The dependent variable in Column~(1) is whether any appliants were viewed by the employer, whereas in Column~(2), it is the fraction of applicants viewed. The sample consists of the first openings by employers in the ambiguous arm of the experiment. \\starlanguage.")


out.file <- "../writeup/tables/viewing.tex"
sink(file = "/dev/null")
s <- stargazer(m.ambig.any, m.ambig.rate,  
               title = paste("Effects of P/Q revelation on whether any candidates were viewed, as well as the fraction that were viewed by the treated employer"),
               covariate.labels = c("Medium Tier (MT)", "High Tier (HT)", "ShownPref", "MT x ShownPref", "HT x ShownPref"),
               dep.var.labels = c("Any viewed?", "Fraction viewed"), 
               label = "tab:viewed"
        )
sink()
AddTableNote(s, out.file, NoteWrapper(note))
