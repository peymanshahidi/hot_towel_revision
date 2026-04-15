#' Load the application data
#'
#' Load the application data
#'
#' @return data.frame 
#' @export

GetApps <- function(){
    data.table(readRDS(system.file("extdata/applications.rds", package = "HotTowelR")))
}
