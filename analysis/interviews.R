#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

out.file <- "../writeup/tables/interviews.tex"

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



m.interviewed.any <- lm(I(num_interviewed > 0) ~ tier*contractor.shown,
                        data = df.ambiguous %>% filter(num_interviewed < 10))

m.interviewed.rate <- lm(I(num_interviewed/num_applications) ~ tier*contractor.shown,
                         data = df.ambiguous %>% filter(num_interviewed < 10))

m.interviewed.count <- lm(num_interviewed~ tier*contractor.shown,
                          data = df.ambiguous %>% filter(num_interviewed < 10))

note <- paste("The dependent variable in Column~(1) is whether any appliants were interviewed by the employer, whereas in Column~(2), it is the fraction of applicants interviewed.
Column~(3) is the count of applicants interviewed. 
The sample consists of the first openings by employers in the ambiguous arm of the experiment. \\starlanguage.")

out.file <- "../writeup/tables/interviews.tex"
sink(file = "/dev/null")
s <- stargazer(m.interviewed.any, m.interviewed.rate, m.interviewed.count, 
               title = "Effect of P/Q revelation on whether any candidates are interviewed, as well as the fraction of candidates and the total count.",
               covariate.labels = c("Medium Tier (MT)", "High Tier (HT)", "ShownPref", "MT x ShownPref", "HT x ShownPref"),
               dep.var.labels = c("Any Interviewed?", "Fraction Interviewed", "Count of Interviews"), 
               label = "tab:interviews"
        )
sink()
AddTableNote(s, out.file, NoteWrapper(note))

