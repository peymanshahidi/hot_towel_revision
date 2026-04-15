#' Tier selection by employer experience 
#'
#' Tier selection by experiment experience
#'
#' @param out.file 
#' @return None
#' @export

KnowledgePastExper <- function(out.file) {
    df.openings <- readRDS(system.file("extdata/openings.rds", package = "HotTowelR"))
    df.reveal <- subset(df.openings,
                   (G2 | G3) &
                   !is.na(contractor_tier) &
                   is.first.opening)

    df.reveal$tier.z <- with(df.reveal, scale(contractor_tier))

    m.base.tier <- lm(tier.z ~ G2, data = df.reveal)
    m.low.spend.tier <- update(m.base.tier, LT ~ G2*I(prior_spend > 0))
    m.middle.spend.tier <- update(m.low.spend.tier, MT ~ .)
    m.high.spend.tier <- update(m.low.spend.tier, HT ~ .)
    covariate.labels <- c(
        "P/Q choice shown to applicants, ShownPref",
        "Any prior spend on oDesk, AnyPriorSpend",
        "ShownPref $\\times$ AnyPriorSpend")
    dep.var.labels <- c("Tier z-score", 
                        "Low Tier",
                        "Middle Tier",
                        "High Tier")
    sink(file = "/dev/null")
    s <- stargazer::stargazer(m.base.tier, m.low.spend.tier, m.middle.spend.tier, m.high.spend.tier,
        title = paste("Effect of knowledge that p/q choice will be",
            "exposed to would-be applicants on the employer's p/q choice"),
        label = "tab:revelation",
        omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
        star.cutoffs = star.cutoffs,
        star.char = star.char, 
        dep.var.labels = dep.var.labels,
        covariate.labels = covariate.labels)
    sink()
    note <- c(paste("This table reports OLS regressions of an employer's p/q selection---as captured by a z-score in Column~(1) or as tier-specific indicators in Columns~(2) through (4)---on an indicator for whether that p/q choice would or would not be shown to would-be applicants.
In Columns~(2) through (4) the ShowPref indicator is interacted with an indicator for whether the employer had previously spent any money on the platform.
Column~(1) shows estimates for Equation~\\ref{eq:tierz}, while Columns~(2) through (4) show estimates for variants of Equation~\\ref{eq:tieri}. 
The sample is restricted to employers in the explicit arm. \\explicitdef \\tierdef
The Column~(1) z-score of p/q tier choice is constructed by treating tiers selections as integers in successive, ascending order.
Standard errors are robust to heteroscedasticity. 
 \\starlanguage"))
    #JJHmisc::AddTableNote(s, out.file, note = NoteWrapper(note, TableWidth(dep.var.labels, covariate.labels)))
    JJHmisc::AddTableNote(s, out.file, note = JJHmisc::NoteWrapper(note))
}
