#' Count of applications received per opening 
#'
#' Count of applications received per opening
#' 
#' @param df.openings
#' @param out.file
#' @return none - writes text to a file 
#' @export

AppCounts <- function(df.openings, out.file) {

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


    m.apps.explicit <- lm(log(num_applications) ~ contractor.shown, data = df.explicit)
    m.apps.explicit.bt <- lm(log(num_applications) ~ contractor.shown * tier, data = df.explicit)
    m.apps.ambig.1 <- lm(log(num_applications) ~ contractor.shown,
                         data = df.ambiguous)
    m.apps.ambig.3 <- lm(log(num_applications) ~ contractor.shown * tier,
                         data = df.ambiguous)

    covariate.labels <- c("P/Q choice shown to applicants, ShownPref", "Medium Tier (MT)", "High Tier (HT)", "MT x ShownPref",
              "HT x ShownPref", "Constant")
    column.labels <- c("Ambiguous Arm", "Ambiguous Arm", "Explicit Arm") 
    file.name.no.ext <- "app_counts"
    out.file <- paste0("../../writeup/tables/", file.name.no.ext, ".tex")
    sink(file = "/dev/null")
    s <- stargazer::stargazer(m.apps.ambig.1, m.apps.ambig.3, m.apps.explicit, 
                              title = paste("Effect of employer p/q preference revelation on",
                                  "the size of the applicant pool"),
                              label = paste0("tab:", file.name.no.ext),
                              font.size = "small",
                              no.space = TRUE,
                              dep.var.labels = "Log number of applications received",
                              covariate.labels = covariate.labels,
                              align = TRUE,
                              star.char = star.char,
                              star.cutoffs = star.cutoffs, 
                              omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
                              column.labels = column.labels, 
                              type = "latex")
    sink()
    
    note <- c("\\\\ ",
              "\\begin{minipage}{0.90 \\textwidth}",
              "\\emph{Notes:}", 
              "This table reports OLS regressions of the log number of applications received by that opening, conditional upon receiving any.
Columns~(1) and (3) report estimates of Equation~\\ref{eq:apps}, whereas Column~(2) reports estimates of Equation~\\ref{eq:appsi}. 
In Columns~(1) and (2), the sample is restricted to employers allocated to the ambiguous arm, whereas in Column~(3) the sample is estimated with observations from the explicit arm. \\ambigdef \\explicitdef \\shownprefdef \\tierdef Standard errors are robust to heteroscedasticity.  \\starlanguage ",
              "\\end{minipage}")
    AddTableNote(s, out.file, note = note)
}

