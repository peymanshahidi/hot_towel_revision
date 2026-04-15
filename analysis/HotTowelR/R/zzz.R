
.onLoad <- function(libname = "HotTowelR", pkname = "HotTowelR"){
    star.cutoffs <<- c(0.10, 0.05, 0.01, 0.001)
    star.char <<- c("\\dagger", "*", "**", "***")
    tables.path <<- "../writeup/tables/"
    plots.path <<- "../writeup/plots/"
    brewer.neg <<- "#d7191c"
    brewer.pos <<- "#abdda4"
}
