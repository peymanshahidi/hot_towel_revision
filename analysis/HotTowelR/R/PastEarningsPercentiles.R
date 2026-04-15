#' Creates a table showing past earnings percentiles
#'
#' Creates a table showing past earnings percentiles
#'
#' @param models 
#' @param out.file
#' @param width 
#' @return none
#' @export 

PastEarningsPercentiles <- function(models, out.file, width = 0.90){
    dep.var.caption <- paste("Per-opening percentiles of applicant log past earnings")
    title <- "The effects of p/q revelation on the past experience of applicants, as measured by cumulative prior earnings"
    label <- "tab:past_earnings_percentiles"
    note <- paste("This table reports regressions of the various per-opening percentiles of the log cumulative prior earnings of applicants on ShownPref interacted with indicators for the employer's p/q tier selection. All regressions are OLS estimates of a variant of Equation~\\ref{eq:pr} (with differing percentiles and earnings substituted for profile wage) except in Column~(5), which reports a regression with a category-specific random-effect to control for the type of work asked for in the opening e.g., computer programming, graphic design etc.
The sample for each regression consists of job openings assigned to the ambiguous arm of the experiment. \\ambigdef
Workers with zero prior earnings are counter-factually given \\$1 in past earnings. Standard errors are robust to heteroscedasticity.  \\starlanguage")
    HotTowelR::GetLaTeXTable(models, out.file, title, label, dep.var.caption, note, width = width)
} 
