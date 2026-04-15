#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

#df.openings <- HotTowelR::GetOpenings()
df.openings <- readRDS("../etl/transformed/openings.rds")

file.name.no.ext <- "app_counts"
out.file <- paste0("../writeup/tables/", file.name.no.ext, ".tex")

df.explicit <- subset(df.openings, is.first.opening
                      & (G2 | G3)
                      & !bad
                      & visibility != "private")

df.ambiguous <- subset(df.openings,
                       is.first.opening
                       & (G4 | G5 | G6)
                       & !bad
                       & visibility != "private")

df.pooled <- rbind(df.explicit, df.ambiguous)

## Any?
m <- felm(I(num_applications > 0) ~ contractor.shown | 0 | 0 | 0, data = df.pooled)


m.apps.pooled <- felm(log(num_applications) ~ contractor.shown | 0 | 0 | 0, data = df.pooled %>% filter(num_applications  > 0))


addParam <- JJHmisc::genParamAdder("../writeup/params_app_counts.tex")

extract.effect <- . %>%
     multiply_by(100) %>%
         round(1)

addParam("\\AppCountsRevealedExplicit",
         m.apps.pooled %>% coef %>% .[["contractor.shownTRUE"]] %>%
         extract.effect
         )


m.apps.explicit <- felm(log(num_applications) ~ contractor.shown | 0 | 0 | 0,
                        data = df.explicit %>% filter(num_applications  > 0))
m.apps.explicit.bt <- felm(log(num_applications) ~ contractor.shown * tier | 0 | 0 | 0,
                           data = df.explicit %>% filter(num_applications  > 0))
m.apps.ambig.1 <- felm(log(num_applications) ~ contractor.shown | 0 | 0 | 0,
                       data = df.ambiguous %>% filter(num_applications  > 0))

addParam("\\AppCountsRevealedAmbig",
         m.apps.ambig.1 %>% coef %>% .[["contractor.shownTRUE"]] %>%
         extract.effect
         )

m.apps.ambig.3 <- felm(log(num_applications) ~ contractor.shown * tier | 0 | 0 | 0,
                       data = df.ambiguous %>% filter(num_applications  > 0))
#m.apps.ambig.3 <- felm(log(num_applications) ~ contractor.shown * tier | 0 | 0 | 0, data = df.explicit)

covariate.labels <- c("\\textsc{ShownPref}",
                      "\\textsc{MedTier}",
                      "\\textsc{HighTier}",
                      "\\textsc{MedTier} x \\textsc{ShownPref}",
                      "\\textsc{HighTier} x \\textsc{ShownPref}",
                      "Constant")
column.labels <- c("Pooled", "Ambig.", "Ambig.", "Ambig.") 

sink(file = "/dev/null")
s <- stargazer::stargazer(m.apps.pooled, m.apps.explicit, m.apps.ambig.1, m.apps.ambig.3, 
                          title = paste("Effect of employer vertical preference revelation on",
                                        "the size of the applicant pool"),
                          label = paste0("tab:", file.name.no.ext),
                          font.size = "small",
                          no.space = TRUE,
                          dep.var.labels = "Log number of applications received",
                          covariate.labels = covariate.labels,
                          align = TRUE,
                          star.char = star.char,
                          model.names = FALSE, 
                          star.cutoffs = star.cutoffs,
                          add.lines = list(c("{\\footnotesize Includes Explicit Arm}", "Y", "Y", "N", "N"),
                                           c("{\\footnotesize Includes Ambiguous Arm}", "Y", "N", "Y", "Y")),
                          omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
                          type = "latex")
sink()

note <- c("\\\\ ",
          "\\begin{minipage}{1.20 \\textwidth}",
          "\\begin{footnotesize}",
          "\\begin{singlespace}",
          "\\emph{Notes:}", 
          "This table reports regressions where the outcome is the log number of applications received by that opening.
The sample is restricted to job openings receiving at least one application.
The same specification is used in Columns~(1) through (3), with only the sample differing.
In Column~(4), the \\textsc{ShownPref} is interacted with the employer's tier selection, which can be treated as exogenous in the ambiguous arm. 
Standard errors are robust to heteroscedasticity.
\\signaldef{}.
\\ambigdef{}.
\\explicitdef{}. 
\\starlanguage",
"\\end{singlespace}",
"\\end{footnotesize}",
"\\end{minipage}")


JJHmisc::AddTableNote(s, out.file, note = note)

