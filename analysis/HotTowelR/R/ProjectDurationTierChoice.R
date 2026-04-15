#' Does project duration affect tier choice? 
#'
#' Does project duration affect tier choice? 
#'
#' @param df.openings
#' @param out.file
#' @return none
#' @export 

ProjectDurationTierChoice <- function(df.openings, out.file){

    m.duration.fe.HT <- lfe::felm(HT ~ duration | employer | 0 | employer, 
                      data = subset(df.openings, durations.per.employer > 2))

    m.duration.fe <- lfe::felm(I(contractor_tier - 2) ~ duration | employer | 0 | employer, 
                      data = subset(df.openings, durations.per.employer > 2))

    sink(file = "/dev/null")
    s <- stargazer::stargazer(m.duration.fe.HT, m.duration.fe, 
               title = paste("Expected job duration and employer P/Q",
                   "preference, with employer-specific fixed effects"),
               label = "tab:job_duration",
               covariate.labels = c("1 week", "3 weeks", "9 weeks", "18 weeks", "52+ weeks"), 
               dep.var.labels = c("Select High Tier",
                   "Tier (-1 = Low, 0 = Medium, 1 = High)")
               )
    sink()
    note <- paste("The sample consists of all vacancies by allocated employers with",
          "two or more duration selections. An employer-specific fixed-effect",
           " is included in both regressions. Standard errors are clustered at",
           " the employer level. \\starlanguage")

    JJHmisc::AddTableNote(s, out.file, JJHmisc::NoteWrapper(note))
}
