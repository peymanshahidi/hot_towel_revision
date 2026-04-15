#' Creates a table showing profile rate percentiles
#'
#' Creates a table showing profile rate percentiles
#'
#' @param models 
#' @param out.file
#' @param width 
#' @return none
#' @export 

ProfileRatePercentiles <- function(models, out.file, width = 0.90){
    dep.var.caption <- paste("Per-opening percentiles of applicant log profile wage",
                 "by opening:")
    title <- "Effect of p/q revelation on the market wage of applicants, as measured by applicant profile rates"
    label <- "tab:pr_rate_percentiles"
    note <- paste("This table reports regressions of the various per-opening percentiles of the log profile rate of applicants on ShownPref interacted with indicators for the employer's p/q tier selection. All regressions are OLS estimates of Equation~\\ref{eq:pr} (with differing percentiles) except in Column~(5), which reports a regression with a category-specific random-effect to control for the type of work asked for in the opening e.g., computer programming, graphic design etc.
The sample for each regression consists of job openings assigned to the ambiguous arm of the experiment.
\\ambigdef  Standard errors are robust to heteroscedasticity.  \\starlanguage")

    HotTowelR::GetLaTeXTable(models, out.file, title, label, dep.var.caption, note, width = width)
} 
