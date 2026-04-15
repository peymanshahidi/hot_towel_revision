#!/usr/bin/Rscript

library(HotTowelR)

out.file <- "../writeup/tables/knowledge_and_choice_past_exper.tex"

df.openings <- readRDS(system.file("extdata/openings.rds", package = "HotTowelR"))
df.reveal <- subset(df.openings, (G2 | G3) & !is.na(contractor_tier) & is.first.opening)

chisq.test(table(df.reveal$contractor.shown, df.reveal$contractor_tier))


m.0 <- lm(MT ~ level1, data = df.reveal)
m.1 <- lm(MT ~ contractor.shown + level1, data = df.reveal)
anova(m.0, m.1)

m.2 <- lm(MT ~ contractor.shown * level1, data = df.reveal)

df.reveal$tier.z <- with(df.reveal, scale(contractor_tier))

m.low.spend.tier <- lm(tier.z ~ G2*I(prior_spend > 0), data = df.reveal) 
m.middle.spend.tier <- update(m.low.spend.tier, MT ~ .)
m.high.spend.tier <- update(m.low.spend.tier, HT ~ .)

covariate.labels <- c(
    "P/Q choice shown to applicants, \\textsc{ShownPref}",
    "Any prior spend, \\textsc{AnyPriorSpend}",
    "\\textsc{ShownPref} $\\times$ \\textsc{AnyPriorSpend}")

dep.var.labels <- c("Low Tier",
                    "Middle Tier",
                    "High Tier")
sink(file = "/dev/null")
s <- stargazer::stargazer(m.low.spend.tier, m.middle.spend.tier, m.high.spend.tier,
                          title = paste("Effect of knowledge that p/q choice will be",
                                        "exposed to would-be applicants on the employer's p/q choice"),
                          label = "tab:revelation",
                          omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
                          star.cutoffs = star.cutoffs,
                          star.char = star.char,
                          no.space = TRUE,
                          font.size = "small", 
                          dep.var.labels = dep.var.labels,
                          covariate.labels = covariate.labels)
sink()

note <- "
\\begin{minipage}{\\textwidth}
\\begin{spacing}{0.5}
\\begin{small}
\\emph{Notes}: This table reports OLS regressions of an employer's p/q selection on an indicator for whether that p/q choice would or would not be shown to would-be applicants.
 The sample is restricted to employers in the explicit arm of the experiment.
 Standard errors are robust to heteroscedasticity. 
 \\starlanguage
\\end{small}
\\end{spacing}
\\end{minipage}"

    #JJHmisc::AddTableNote(s, out.file, note = NoteWrapper(note, TableWidth(dep.var.labels, covariate.labels)))
JJHmisc::AddTableNote(s, out.file, note =  note)






