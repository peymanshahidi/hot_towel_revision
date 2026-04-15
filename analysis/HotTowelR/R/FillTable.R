#' Table showing opening-level fill results
#'
#' Table showing opening-level fill results
#'
#' @param df.explicit
#' @param df.ambiguous
#' @param out.file
#' @return none
#' @export 

FillTable <- function(df.explicit, df.ambiguous, out.file){
    m.fill <- lm(filled ~ contractor.shown,
             data = df.explicit)
    m.fill.ambig <- lm(filled ~ contractor.shown,
                   data = df.ambiguous)
    m.fill.ambig.i <- lm(filled ~ contractor.shown*tier,
                   data = df.ambiguous)

    sink(file = "/dev/null")
    s <- stargazer::stargazer(m.fill, m.fill.ambig, m.fill.ambig.i,
                          title = paste("The effect of p/q revelation on the quantity of matches formed"), 
                          covariate.labels = c("P/Q choice shown to applicants, ShownPref",
                              "Medium Tier (MT)", "High Tier (HT)",
            "HT x ShownPref", "MT x ShownPref"),
                          dep.var.labels = "Employer spent any money against the opening:", 
                          column.labels = c("Explicit Arm", "Ambiguous Arm", "Ambiguous Arm"),
                          star.char = star.char,
                          star.cutoffs = star.cutoffs, 
                          omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
                          label = "tab:fills"
        )
    sink()
    note <- paste("This table reports OLS regressions where the dependent variable is an indicator for whether the employer spent any money against the opening and the independent variables are ShownPref---in Columns~(1) and (2)---and ShownPref interacted with the employer's p/q tier selection---Column~(3).
Columns~(1) and (2) report estimates of Equation~\\ref{eq:fill} and Column~(3) reports estimates of Equation~\\ref{eq:filli}. 
\\shownprefdef
\\tierdef
The sample for Column~(1) consists of openings from the explict arm, whereas in Columns~(2) and (3), the sample consists of openings from the ambiguous arm.
\\ambigdef \\explicitdef Standard errors are robust to heteroscedasticity.  \\starlanguage")
    JJHmisc::AddTableNote(s, out.file, note =  JJHmisc::NoteWrapper(note))
}
