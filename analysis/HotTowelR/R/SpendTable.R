#' Table showing opening-level fill results
#'
#' Table showing opening-level fill results
#'
#' @param df.openings
#' @param df.ambiguous
#' @param out.file
#' @return none
#' @export 

SpendTable <- function(df.openings, df.ambiguous, out.file){

    m.g2g3.spend <- lm(log(total_charge) ~ contractor.shown,
              data = df.openings[is.first.opening &
                                     (G2 | G3) & total_charge > 0])
    m.ambig.spend <- lm(log(total_charge) ~ contractor.shown,
              data = df.openings[is.first.opening & ambigious.arm
                  & total_charge > 0])
    m.ambig.spend.i <- lm(log(total_charge)~ contractor.shown * tier,
              data = df.openings[is.first.opening & ambigious.arm
                  & total_charge > 0])
    df.ambiguous$l.wage.bill <- with(df.ambiguous, log(total_charge))
    df.ambiguous.filled <- subset(df.ambiguous, total_charge > 0)

    covariate.labels <- c("P/Q choice shown to applicants, ShownPref", "Medium Tier (MT)", "High Tier (HT)",
                      "MT x ShownPref", "HT x ShownPref", "Constant")
    column.labels <- c("Explicit Arm", "Ambiguous Arm", "Ambiguous Arm")
    sink(file = "/dev/null")
    s <- stargazer::stargazer(m.g2g3.spend, m.ambig.spend, m.ambig.spend.i,
                              title = "Effect of p/q revelation on the opening wage bill, conditional upon the opening being filled",
                              label = "tab:spend",
                              dep.var.labels = c("Log total charge:"),
                              star.cutoffs = star.cutoffs,
                              star.char = star.char, 
                              covariate.labels = covariate.labels,  
                              omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
                              column.labels = column.labels
                              ) 
    sink()
    note <- paste("This table reports OLS regressions where the dependent variable is the log total charge against an opening (i.e., the wage bill) and the independent variables are ShownPref---in Columns~(1) and (2)---and ShownPref interacted with the employer's p/q tier selection---Column~(3).
Columns~(1) and (2) report estimates of Equation~\\ref{eq:spend} and Column~(3) reports estimates of Equation~\\ref{eq:spendi}. 
\\shownprefdef
\\tierdef
The sample for Column~(1) consists of openings from the explict arm, whereas in Columns~(2) and (3), the sample consists of openings from the ambiguous arm.
\\ambigdef
\\explicitdef Openings where no money was spent are excluded. Standard errors are robust to heteroscedasticity.  \\starlanguage")
    JJHmisc::AddTableNote(s, out.file, JJHmisc::NoteWrapper(note))
}
