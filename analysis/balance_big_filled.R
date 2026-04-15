#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

source("utility_functions.R")

#df.openings <- HotTowelR::GetOpenings()
df.openings <- readRDS("../etl/transformed/openings.rds")

df.explicit <- subset(df.openings, is.first.opening
                      & (G2 | G3)
                      & !bad
                      & visibility != "private"
                      & num_applications > 0)

df.ambiguous <- subset(df.openings,
                       is.first.opening
                       & (G4 | G5 | G6)
                       & !bad
                       & visibility != "private"
                       & num_applications > 0)

df.pooled <- rbind(df.explicit, df.ambiguous)

df.oo.first <- df.pooled %>% mutate(trt = contractor.shown) %>%
    filter(total_charge > 0)

out.file<- "../writeup/tables/balance_big_filled.tex"
## where is contractor_min_wage6m
#df.apps <- readRDS("../etl/raw/wage_history_applications.rds")


BalenceTables <- c(
  "\\\\",
  "\\multicolumn{4}{l}{\\emph{Employer attributes}} \\\\ \n",
  do.call(LineFun_OLS,list(prior_economic_openings~trt,'Prior job openings', df.oo.first)),
  do.call(LineFun_OLS, list(log1p(prior_spend)~trt,'Prior spend (log) by employers', df.oo.first %>% filter(prior_spend > 0))),
  do.call(LineFun_OLS, list(prior_contractors~trt,'Num prior workers', df.oo.first)),
  "\\multicolumn{4}{l}{\\emph{Job opening attributes}} \\\\ \n",
#  do.call(LineFun_OLS, list(num_organic_applications~trt, "Number non-invited applicants", df.oo.first)),
  do.call(LineFun_OLS, list(odesk_hours_pref~trt, "Prefered experiance in hours", df.oo.first)),
  do.call(LineFun_OLS, list(duration_weeks~trt, "Estimated job duration in weeks", df.oo.first)),
  do.call(LineFun_OLS, list(job_desc_length ~trt, "Job description length (characters)", df.oo.first))
)
fileConn<-file(out.file)
writeLines(BalenceTables, fileConn)
close(fileConn)

