#' Creates a table showing wage bid percentiles 
#'
#' Creates a table showing wage bid percentiles 
#'
#' @param models 
#' @param out.file
#' @param width 
#' @return none
#' @export 

WageBidPercentiles <- function(models, out.file, width = 0.90){
    dep.var.caption = "Average log wage bid percentiles by employer:"
    title <- "Mean per-opening wage bid percentiles"
    label <- "tab:wage_bid_percentiles"
    note <- paste("The sample in each regression are the first job posts for each",
                  "employer assigned to the ambiguous arm of the experiment.",
              "For each opening, the percentiles (25th, 50th, 75th and 90th)",
              "of the log wage bid of all applicants are computed and are ",
              "used as the dependent variables in Columns~(1) through (4)",
              "respectively")   
    HotTowelR::GetLaTeXTable(models, out.file, title, label, dep.var.caption, note, width = width)
} 
