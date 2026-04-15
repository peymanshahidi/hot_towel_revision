#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

df.openings <- readRDS("../etl/transformed/openings.rds") %>%
    group_by(employer) %>% 
    mutate(openings.per.employer = length(employer))

MAX.OPENINGS.PER.EMPLOYER <- 10


m.ht <- felm(HT ~ opening.rank |employer|0|employer,
             data = subset(df.openings,
                           openings.per.employer < MAX.OPENINGS.PER.EMPLOYER))

m.mt <- felm(MT ~ opening.rank | employer|0|employer,
             data = subset(df.openings,
              openings.per.employer < MAX.OPENINGS.PER.EMPLOYER))

m.lt <- felm(LT ~ opening.rank | employer|0|employer,
             data = subset(df.openings,
              openings.per.employer < MAX.OPENINGS.PER.EMPLOYER))

m.ht.inter <- felm(HT ~ opening.rank*as.numeric(G2) | employer|0|employer,
                   data = subset(df.openings,
                       openings.per.employer < MAX.OPENINGS.PER.EMPLOYER))

out.file <- "../writeup/tables/employer_choice_fe.tex"
sink(file = "/dev/null")
s <- stargazer(m.lt, m.mt, m.ht, m.ht.inter,  
               title = paste("Employer vertical preference signal over time, by treatment assignemnt"),
               no.space = TRUE,
               font.size = "small", 
               label = "tab:employer_choice_fe",
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
               dep.var.labels = c("\\textsc{LowTier}",
                                  "\\textsc{MedTier}",
                                  "\\textsc{HighTier}",  "\\textsc{HighTier}"),
               covariate.labels = c("\\textsc{OpeningRank}", "\\textsc{ShownPref}",
                                    "\\textsc{ShownPref} x \\textsc{OpeningRank}")
               )
sink()
note <- paste("This table reports regressions where the dependent variable is an indicator for an employer's vertical preference selection and the independent variables are the chronological rank of the opening (ascending order) for that particular employer, \\textsc{OpeningRank}, and its interactions with \\textsc{ShownPref}.
\\shownprefdef{}.
The sample is restricted to employers assigned to the explicit arm that posted more than 1 but fewer than 10 openings.
\\explicitdef{}.
In each regression, an employer-specific fixed-effect is included. 
Standard errors are clustered at the employer level. 
 \\starlanguage") 
AddTableNote(s, out.file, note = NoteWrapper(note, 1))
