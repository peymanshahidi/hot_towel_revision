#!/usr/bin/Rscript

library(RPostgreSQL)
library(data.table)


con <- dbConnect(PostgreSQL(),
                 user = "john",
                 dbname = "odw"
                 )


GetQueryString <- function(file.path){
    readChar(file.path, file.info(file.path)$size)
}

query <- GetQueryString("./SQL/tiers_over_time.sql")

df.raw <- dbGetQuery(con, query)

saveRDS(df.raw, "./transformed/tiers_over_time.rds")

