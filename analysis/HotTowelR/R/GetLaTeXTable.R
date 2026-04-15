#' Writes a percentile table
#'
#' Writes a percentile table
#'
#' @param models
#' @param out.file
#' @param title
#' @param label
#' @param dep.var.caption
#' @param width
#' @return None
#' @export


GetLaTeXTable <- function(models, out.file, title, label, dep.var.caption, note, width = 1.0){
    sink(file = "/dev/null")
    s <- stargazer(models["25"], models["50"], models["75"], models["90"], models["re"], 
                   dep.var.labels = c("25th", "50th", "75th", "90th", "50th (with RE)"),
                   dep.var.caption = dep.var.caption,
                   # dep.var.labels = NULL, 
                   covariate.labels = c("ShownPref", "Medium Tier (MT)",
                       "High Tier (HT)",
                       "MT $\\times$ ShownPref", "HT $\\times$ ShownPref"),  
                   title = title, 
                   omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
                   label = label
            )
    sink()
    AddTableNote(s, out.file, JJHmisc::NoteWrapper(note, width))
}
