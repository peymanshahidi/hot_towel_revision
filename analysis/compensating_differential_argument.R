#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

models <- readRDS("../computed_objects/compensating_differential_argument.rds")
m.1 <- models[["m.1"]]
m.2 <- models[["m.2"]]
m.3 <- models[["m.3"]]
m.4 <- models[["m.4"]] 

covariate.labels <- c(
    "\\textsc{MedTier}",
    "\\textsc{HighTier}",
    "\\textsc{ShownPref}",
    "\\textsc{MedTier} x \\textsc{ShownPref}",
    "\\textsc{HighTier} x \\textsc{ShownPref}")

out.file <- "../writeup/tables/compensating_differential_argument.tex"
sink(file = "/dev/null")
s <- stargazer(m.1, m.2, m.4, m.3, 
               title = paste("Measures of employer satisfaction by whether the firm's vertical preferences were revealed"),
               no.space = TRUE,
               font.size = "small", 
               label = "tab:compensating_differential_argument",
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
               dep.var.labels = c("FB to worker (z)", "Promotor score (z)", "Promotor score (z)","Promotor score (z)"),
               covariate.labels = covariate.labels
               )
sink()
note <- paste("This table reports regressions where the outcome variable is some measure of employer satisfaction afte the conclusion of a contract.
The outcome in Column~(1) is the feedback to the hired worker, normalized to a z-score (it is actually given on a 1 to 5 star scale). 
The outcome in the remaining columns is the normalized promotion score for the platform.
Employers are not always asked for a promotor score at the conclusion of a contract, so it offers a smaller sample than the feedback sample.
 \\starlanguage") 
JJHmisc::AddTableNote(s, out.file, note = NoteWrapper(note, 1))



