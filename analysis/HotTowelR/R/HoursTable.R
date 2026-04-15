#' Table showing opening-level hours-worked results
#'
#' Table showing opening-level hours-worked results
#'
#' @param df.openings
#' @param out.file
#' @return none
#' @export 

HoursTable <- function(df.openings, df.ambiguous, df.explicit, out.file){
    m.ambig.i <- lfe::felm(log(hours) ~  tier * contractor.shown | level1|0|employer, 
                      data = subset(df.openings, (G4 | G5| G6) & hours > 0))
    df.ambiguous.hours <- subset(df.ambiguous, hours > 0)
    df.ambiguous.hours$l.hours <- with(df.ambiguous.hours, log(hours))
    
    m.g2g3.hours <- lm(log(hours) ~ contractor.shown,
              data = subset(df.explicit, hours > 1))
    m.ambig.hours <- lm(log(hours) ~ contractor.shown,
                        data = subset(df.ambiguous, hours > 1))
    m.ambig.hours.i <- lm(log(hours)~ contractor.shown*tier,
                          data = subset(df.ambiguous, hours > 1))
    covariate.labels <- c("P/Q choice shown to applicants, ShownPref", "Medium Tier (MT)", "High Tier (HT)",
                          "MT x ShownPref", "HT x ShownPref", "Constant")
    column.labels <- c("Explicit Arm", "Ambiguous Arm", "Ambiguous Arm")
    sink(file = "/dev/null")
    s <- stargazer::stargazer(m.g2g3.hours, m.ambig.hours, m.ambig.hours.i,
        title = "Effect of p/q revelation on log hours worked, conditional upon more than 1 hour",
                              label = "tab:hours",
                              star.char = star.char,
                              star.cutoffs = star.cutoffs, 
                              dep.var.label = "Log hours worked:", 
                              covariate.labels = covariate.labels,  
                              omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
                              column.labels = column.labels
                              )
    sink()
    note <- paste("This table reports OLS regressions where the dependent variable is the log hours worked following a hire for an opening and the independent variables are ShownPref---in Columns~(1) and (2)---and ShownPref interacted with the employer's p/q tier selection---Column~(3).
\\shownprefdef
\\tierdef
The sample for Column~(1) consists of openings from the explict arm, whereas in Columns~(2) and (3), the sample consists of openings from the ambiguous arm.
\\ambigdef
\\explicitdef Openings where less than one hour was worked excluded. Standard errors are robust to heteroscedasticity.  \\starlanguage")
    JJHmisc::AddTableNote(s, out.file, JJHmisc::NoteWrapper(note))
}
