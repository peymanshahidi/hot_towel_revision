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

m.to.client.e <- lm(average_feedback_to_client ~ contractor.shown, data =
                        subset(df.explicit,
                               !is.na(average_feedback_to_client) &
                                   !is.na(average_feedback_to_contractor)
                               ))

m.to.worker.e <- lm(average_feedback_to_contractor ~ contractor.shown, data =
                        subset(df.explicit,
                               !is.na(average_feedback_to_client) &
                                   !is.na(average_feedback_to_contractor)
                               ))


m.to.client.a <- lm(average_feedback_to_client ~ contractor.shown,
                    data = subset(df.ambiguous,
                          !is.na(average_feedback_to_client) &
                                   !is.na(average_feedback_to_contractor)
                               ))


m.to.worker.a <- lm(average_feedback_to_contractor ~ contractor.shown,
                    data = subset(df.ambiguous,
                        !is.na(average_feedback_to_client) &
                                   !is.na(average_feedback_to_contractor)
                                  ))


out.file <- "../writeup/tables/feedback.tex"
sink(file = "/dev/null")
s <- stargazer(m.to.client.e, m.to.client.a, m.to.worker.e, m.to.worker.a,  
               title = "Bi-lateral feedback scores",
               label = "tab:feedback",
               #covariate.labels = c("Medium Tier (MT)", "High Tier (HT)", "ShownPref",
               #    "MT x ShownPref", "HT x ShownPref", "Constant"), 
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser")
               #dep.var.labels = c("To Employer", "To Worker",
               #    "To Worker", "To Employer"), 
               #column.labels = c("Explicit", "Explicit", "Ambig", "Ambig")
               )
sink() 
JJHmisc::AddTableNote(s, out.file, NoteWrapper("Here are some notes"))

