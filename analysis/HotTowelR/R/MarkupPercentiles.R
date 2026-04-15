#' Creates a table showing past earnings percentiles
#'
#' Creates a table showing past earnings percentiles
#'
#' @param models 
#' @param out.file
#' @param width 
#' @return none
#' @export 

MarkupPercentiles <- function(models, out.file, width = 0.90){
    dep.var.caption <- paste("Per-opening percentiles of applicant wage-bid markups:")
    title <- "Effect of p/q revelation on the wage bid markups of applicants"
    label <- "tab:markups"
    note <- paste("This table reports regressions of the various per-opening percentiles of the wage bid markup of applicants on ShownPref interacted with indicators for the employer's p/q tier selection. Wage bid markups are calculated using Equation~\\ref{eq:markup}. 
All regressions are OLS estimates of a variant of Equation~\\ref{eq:pr} (with differing percentiles and markups substituted for profile wage) except in Column~(5), which reports a regression with a category-specific random-effect to control for the type of work asked for in the opening e.g., computer programming, graphic design etc. The sample for each regression consists of job openings assigned to the ambiguous arm of the experiment.
Applicants with markups greater than than 100\\% or zero profile rate are excluded from the sample. \\ambigdef
Standard errors are robust to heteroscedasticity. \\starlanguage")   
    HotTowelR::GetLaTeXTable(models, out.file, title, label, dep.var.caption, note, width = width)
} 
