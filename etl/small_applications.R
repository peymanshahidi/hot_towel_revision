#!/usr/bin/Rscript

df.apps <- readRDS("transformed/applications.rds")
df.small.apps <- subset(df.apps,
                        ambigious.arm == TRUE &
                        is.first.opening == TRUE)

saveRDS(df.small.apps, "transformed/small_applications.rds")
