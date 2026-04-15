#' Load the application data
#'
#' Load the application data
#'
#' @return data.frame 
#' @export

GetOpenings <- function(){
    data.table(readRDS(system.file("extdata/openings.rds", package = "HotTowelR")))
}
