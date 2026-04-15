#!/usr/bin/Rscript

library(devtools)
install("HotTowelR")

write.table(data.frame(date = date()), "HotTowelR_installed.txt")
