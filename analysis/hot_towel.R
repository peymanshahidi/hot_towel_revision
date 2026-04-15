

#'---------------------------------------
#' Analysis of the "Hot Towel" experiment
#' Author: John Horton
#'---------------------------------------

################################################################################

library(devtools)

devtools::install_github("johnjosephhorton/JJHmisc")
library(JJHmisc)

# Create a namespace file: devtools::document()
devtools::install("HotTowelR")
library(HotTowelR)

#-------------------------------------------
#' Allocation consistent with randomization?
#-------------------------------------------

plots.path <- "../writeup/plots/"
tables.path <- "../writeup/tables/"

g.alloc <- HotTowelR::ClientsPerDayPlot()
JJHmisc::writeImage(g.alloc, "allocation_by_day", width = 8, height = 4, path = plots.path)

#'--------------------------------
#' P/Q choices by category of work
#'---------------------------------

g.choices.by.cat <- HotTowelR::ChoicesByCat()
JJHmisc::writeImage(g.choices.by.cat, "choices_by_cat", width = 8, height = 4, path = plots.path)

## hot_towel.tex:378:\input{./tables/knowledge_and_choice_past_exper.tex}
HotTowelR::KnowledgePastExper("../writeup/tables/knowledge_and_choice_past_exper.tex")



########################
#' Descriptive stats
########################


########################
# Opening-level outcomes
########################

#'----------------------------------------------------------
#' Load openings and define explicit and ambiguous data sets
#'----------------------------------------------------------

df.openings <- HotTowelR::GetOpenings()

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

df.ambiguous$filled <- with(df.ambiguous, total_charge > 0)
df.explicit$filled <- with(df.ambiguous, total_charge > 0)

reporttools::tableContinuous(vars = reshape::rename(subset(df.ambiguous,
                    select = c(filled)),
                    c("filled" = "Job filled")), 
                group = df.ambiguous$contractor.shown,
                file = "../writeup/tables/fills_ss.tex",
                cap = "Summary statistics for job-filling in the ambiguous arm",
                label = "tab:fills_ss",        
                             caption.placement = "top")


#-----------------------------------
# Does project duration affect tier?
#-----------------------------------

## hot_towel.tex:1138:\input{./tables/job_duration.tex} 
HotTowelR::ProjectDurationTierChoice(df.openings, "../writeup/tables/job_duration.tex")

#'-------------------------
#' Applications per opening
#'-------------------------

## hot_towel.tex:445:\input{./tables/app_counts.tex}

HotTowelR::AppCounts(df.openings, "../writeup/tables/app_counts.tex")

#'------------------------
#' Opening-level fill rate
#' -----------------------

## hot_towel.tex:673:\input{./tables/fills.tex}
HotTowelR::FillTable(df.ambiguous, "../writeup/tables/fills.tex")

# Effect on total charge-------------------------------------------------------- 

#'------------------------
#' Opening-level wage rate
#' -----------------------

## hot_towel.tex:711:\input{./tables/spend.tex}
HotTowelR::SpendTable(df.openings, "../writeup/tables/spend.tex")
#writeImage(plotLine(m.ambig.spend.i, "Log wage bill"), "wage_bill_reg_viz", width = 7, height = 3)

## hot_towel.tex:752:\input{./tables/hours.tex}
HotTowelR::HoursTable(df.openings, "../writeup/tables/hours.tex")

## hot_towel.tex:775:\input{./tables/hired_rate.tex}

HotTowelR::HiredRateTable(df.openings, out.file = "../writeup/tables/hired_rate.tex")

##############################
# Load freelancer applications
##############################

df.apps <- HotTowelR::GetApps()

#'---------------------------------------------------
#' Regression approach to profile rates of applicants
#'---------------------------------------------------
## hot_towel.tex:483:\input{./tables/profile_rate_percentiles.tex}
# df.apps$lhourly_rate_snap <- with(df.apps, log(hourly_rate_snap))

models <- HotTowelR::appPoolPercentiles(df.apps, "lhourly_rate_snap", log(0.25), log(100))
out.file <-  "../writeup/tables/profile_rate_percentiles.tex"
HotTowelR::ProfileRatePercentiles(models, out.file)

JJHmisc::writeImage(
    HotTowelR::CreatePlot(models, "Quantiles of log profile rate"),
    "profile_rate_reg_viz", width = 7, height = 3, path = plots.path
)

#'---------------------------------------------------
#' Regression approach to prior earnings of applicants
#'---------------------------------------------------
## hot_towel.tex:534:\input{./tables/past_earnings_percentiles.tex}

df.apps$lprior_earnings <- with(df.apps, log(prior_earnings))
models <- HotTowelR::appPoolPercentiles(df.apps, "lprior_earnings", log(1), Inf)
out.file <-  "../writeup/tables/past_earnings_percentiles.tex"
HotTowelR::PastEarningsPercentiles(models, out.file)

JJHmisc::writeImage(
    HotTowelR::CreatePlot(models, "Quantiles of log prior earnings"), "prior_earnings_reg_viz", width = 7, height = 3,
path = plots.path)

#'---------------------------------
#' Regression approach to wage bids 
#'---------------------------------
## hot_towel.tex:583:\input{./tables/wage_bid_percentiles.tex}
df.apps$lhr_charge_rate <- with(df.apps, log(hr_charge_rate))
models <- models <- HotTowelR::appPoolPercentiles(df.apps, "lhr_charge_rate", log(0.25), log(100))
out.file <-  "../writeup/tables/wage_bid_percentiles.tex"
HotTowelR::WageBidPercentiles(models, out.file)
JJHmisc::writeImage(HotTowelR::CreatePlot(models, "Log wage bid"),
                    "wage_bid_reg_viz", width = 7, height = 3, path = plots.path)

## hot_towel.tex:621:\input{./tables/markups.tex}

#-------------------------------
# Regression approach to markups 
#-------------------------------

df.apps$markup <- with(df.apps,
                       (hr_charge_rate - hourly_rate_snap)/(hourly_rate_snap))

models <- models <- HotTowelR::appPoolPercentiles(df.apps, "markup", -1, 1)
out.file <-  "../writeup/tables/markups.tex"
HotTowelR::MarkupPercentiles(models, out.file)
JJHmisc::writeImage(HotTowelR::CreatePlot(models, "Wage Bid Markup"), "markup_reg_viz", width = 7, height = 3,
                    path = plots.path)


## hot_towel.tex:812:\input{./tables/ats_message.tex} 
## hot_towel.tex:826:\input{./tables/employer_choice_fe.tex}
## hot_towel.tex:1128:\input{./tables/job_complexity.tex} 


## hot_towel.tex:1149:\input{./tables/invites} 
## hot_towel.tex:1176:\input{./tables/viewing.tex}
## hot_towel.tex:1185:\input{./tables/interviews.tex}
## hot_towel.tex:1188:%% \input{./tables/interviewee_attributes.tex}
## hot_towel.tex:1197:\input{./tables/success.tex} 
## hot_towel.tex:1212:\input{./tables/feedback.tex} 
## hot_towel.tex:1214:\input{./tables/feedback_ss.tex}
## hot_towel.tex:1217:\input{./tables/feedback_cond.tex}


## library(RPostgreSQL)
## library(data.table)
## library(devtools)
## library(digest)
## library(foreign)
## library(ggplot2)
## library(lme4)
## library(lmtest)
## library(lubridate)
## library(memisc)
## library(plyr)
## library(reporttools)
## library(reshape2)
## library(scales)
## library(stargazer)
## library(testthat)
## library(xtable)
## library(lfe)

## # Non-CRAN resources 
## library(oDeskTools)
## library(JJHmisc)


# PRD URL: https://docs.google.com/a/odesk.com/document/d/
# 1FKx9Yl1RsIF591eEW4GRI8G9u9ctoVAkHHvjjOaXx-w/edit#heading=h.tihnjf80cx5z

# FRD URL: https://sites.google.com/a/odesk.com/eng/teams/network/
# f3044---hot-towel-v1#TOC-Create-QT-for-the-Feature

# 399: Control: 0% (Control Cell)
# 400: G1: 5% (P/Q Choice Optional)
# 401: G2: 31% (P/Q Choice + ‘Contractor Will Be Shown Choice’)
# 402: G3: 31% (P/Q Choice + ‘Contractor Will Not Be Shown Choice’)
# 403: G4: 11% (P/Q Choice + Contractor Not Shown Choice + No Client Message in ATS)
# 404: G5: 11% (P/Q Choice + Contractor Shown Choice + Client Message in ATS)
# 405: G6: 11% (P/Q Choice + Contractor Shown Choice + No Client Message in ATS)

###########
# File List 
###########

#' These are the data files used for the analysis. They are generally constructed
#' by "construct_data.R".

#setwd("~/Dropbox/topics/market_design/hot_towel/code/R/")

# source("file_list.R")

#############
# Parameters
#############

## SHOW.PLOTS <- FALSE

## library(functional)
## sg <- Curry(stargazer, star.cutoffs = c(0.10, 0.05, 0.01, 0.001),
##                        star.char = c("\\dagger", "*", "**", "***"))

################################
# Allocation / Interval Validity
################################

#---------------------------------------
#' Are counts consist with randomization? 
#---------------------------------------

## df.by.day <- readRDS(QT.BY.DAY.FILE)

## g.alloc <- ggplot(data = df.by.day,
##                   aes(x = as.Date(day),
##                       y = num.obs,
##                       colour =
##                       factor(test_cell_id))) +
##     geom_point() +
##     geom_line(aes(group = test_cell_id)) +
##     theme_bw() +
##     xlab("Day") +
##     ylab("Number of employers allocated") +
##     scale_y_continuous(labels = comma)


## if (interactive() && SHOW.PLOTS) {
##     print(g.alloc)
## }



##############################################
# Custom functions - eventually add to JJHmisc
##############################################

## TableWidth <- function(column.labels, covariate.labels){
##     min(1.0, (1.0/80.0) *  (0.0 + sum(sapply(column.labels, nchar)) + max(sapply(covariate.labels, nchar))))
## } 

######################
# Employer preferences
######################

## df.openings <- readRDS(OPENINGS.CLEAN.FILE)
## df.openings[, openings.per.employer := .N, by = employer]
## df.openings[, durations.per.employer := length(unique(duration_weeks)),
##             by = employer]
## df.openings[, duration := factor(duration_weeks), ] 
## df.openings[, num_late_invites := num_invites - num_early_invites] 

## levels(df.openings$duration) <- c("1 week", "3 weeks", "9 weeks",
##                                   "18 weeks", "52 weeks or longer")

## df.openings <- within(df.openings, {
##                       LT <- I(as.character(contractor_tier) == "1")
##                       MT <- I(as.character(contractor_tier) == "2")
##                       HT <- I(as.character(contractor_tier) == "3")
##                   })


## df.openings$org.int.frac <- with(df.openings,
##                               num_organic_applicants_interviewed/
##                               num_organic_applications)
## df.openings$org.int.frac <- with(df.openings,
##                               num_organic_applicants_interviewed/
##                               num_organic_applications)

## df.openings[, opening.rank := rank(economic_opening), by = employer]

## #-------------------------------------------------------------------------------
## # Type of work and preference for quality 
## #-------------------------------------------------------------------------------

## DT.prop.by.cat <- df.openings[(is.first.opening & (G2|G3)), list(num.obs = .N),
##                               by = list(level1, tier, contractor.shown)]
## DT.prop.by.cat[, frac := num.obs/sum(num.obs), by = list(level1, contractor.shown)]
## DT.prop.by.cat[, N := sum(num.obs), by = list(level1, contractor.shown)]
## DT.prop.by.cat[, se := sqrt(frac * (1 - frac))/sqrt(sum(num.obs)), by = list(level1, contractor.shown)]

## DT.prop.by.cat$tier.label <- with(
##     DT.prop.by.cat, factor(tier,
##                            levels = c("Low Tier", "Medium Tier" , "High Tier"),
##                            labels = c("Low", "Medium", "High")))


## DT.prop.by.cat$level1.label <- with(
##     DT.prop.by.cat, factor(level1,
##                            levels = c(
##                                "Administrative Support",
##                                "Business Services", 
##                                "Customer Service",
##                                "Design & Multimedia",
##                                "Networking & Information Systems", 
##                                "Sales & Marketing",
##                                "Software Development",
##                                "Web Development", 
##                                "Writing & Translation"),
##                            labels = c(
##                                "Administrative Support",
##                                "Business Services", 
##                                "Customer Service",
##                                "Design & Multimedia",
##                                "Networking &\n Info. Sys.", 
##                                "Sales & Marketing",
##                                "Software Development",
##                                "Web Development", 
##                                "Writing & Translation")
##                            )
## )


## g.choices.by.cat <- ggplot(DT.prop.by.cat, aes(x = factor(tier.label), y = frac, fill = factor(contractor.shown))) +
##     geom_bar(stat = "identity", colour = "black",  position = position_dodge(.9)) +
##         geom_errorbar(aes(ymin = frac - 2*se, ymax = frac + 2*se), position = position_dodge(0.9), width = 0.2) + 
##         facet_wrap(~level1.label, ncol = 3) +
##             scale_fill_manual("ShownPref", labels = c("FALSE", "TRUE"), values = c("white", "grey")) +
##                 theme_bw() +
##                     xlab("Price/Qualtity Tier Selection") + 
##                         scale_y_continuous(labels = percent) + 
##                             ylab("Fraction of employers selecting this tier")

## g.choices.by.cat <- ggplot(DT.prop.by.cat,
##                            aes(x = tier.label, y = frac)) +
##     geom_line(aes(group = level1.label), colour = "grey") +
##     geom_linerange(aes(ymin = frac - 2*se, ymax = frac + 2*se, line = factor(contractor.shown)),
##                   width = 0.2, position = "dodge") +
##     facet_wrap(~level1.label, ncol = 3) +
##     theme_bw() +
##     xlab("Price/Qualtity Tier Selection") + 
##     scale_y_continuous(labels = percent) + 
##     ylab("Fraction of employers selecting this tier")
    
# print(g.choices.by.cat)

## if (interactive() && SHOW.PLOTS){
##     print(g.choices.by.cat)
## }

writeImage(g.choices.by.cat, "choices_by_cat", width = 8, height = 4, path = plots.path)

#-------------------------------------------------------------------
# In what level 2 categories are employers most interested in quality?
#-------------------------------------------------------------------

DT.by.cat <- df.openings[ (is.first.opening),
                         list(avg.tier = mean(contractor_tier),
                              se.tier = sd(contractor_tier)/sqrt(.N),
                              num.obs = .N), by=list(level1, level2)]

# re-orders the level 2 category 
DT.by.cat$level2 <- with(DT.by.cat, reorder(level2, avg.tier, mean))

DT.by.cat[, level1.short := sapply(level1, shortenName)]

g.avg.tier.pref.by.cat <- ggplot(data = DT.by.cat[num.obs > 30]) +
    geom_point(aes(x = level2,
                   y = avg.tier)) +
    geom_errorbar(aes(x = level2,
                      ymin = avg.tier - 2*se.tier,
                      ymax = avg.tier + 2*se.tier)) + 
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    ylab("Average Tier (Low = 1, Medium = 2, High = 3)") + 
    facet_grid(. ~ level1.short, scales = "fixed", space = "free") +
    coord_flip()


MIN.OBS <- 200
g.avg.tier.pref.by.cat <- ggplot(data = DT.by.cat[num.obs > MIN.OBS]) +
    geom_point(aes(x = avg.tier,
                   y = level2)) +
    geom_errorbarh(aes(xmax = avg.tier + 2*se.tier,
                       xmin = avg.tier - 2*se.tier,
                       y = level2, x = avg.tier)) + 
    xlab("Average Tier (Low = 1, Medium = 2, High = 3)") + 
    facet_wrap(~level1, scales = "free_y", ncol = 1) +
    theme_bw()

writeImage(g.avg.tier.pref.by.cat, "pref_by_level2", width = 8, height = 12, path = plots.path)



#------------------------------------------------------
# Complexity of project, as measured by job description  
#------------------------------------------------------


m.job.complexity <- felm(I(contractor_tier - 2) ~ log(job_desc_length) +
                             G(employer),
                         data = df.openings)
m.job.complexity.HT <- felm(HT ~ log(job_desc_length) + G(employer),
                            data = df.openings)

sink(file = "/dev/null")
out.file <- "../writeup/tables/job_complexity.tex"
s <- sg(m.job.complexity.HT, m.job.complexity, 
               title = paste("Job description length (proxy for complexity)",
                   " and employer P/Q preference, with employer specific fixed",
                   "effects"),
               label = "tab:job_complexity",
               dep.var.labels = c("Select High Tier",
                   "Tier (-1 = Low, 0 = Medium, 1 = High)")
               )
sink()
JJHmisc::AddTableNote(s, out.file, NoteWrapper(
    paste("The sample consists of all vacancies by allocated employers.",
          "An employer-specific fixed-effect is included in both regressions.",
          "Standard errors are clustered at the employer lelvel.",
          "\\starlanguage")))

#----------------------------------------------------
# Does tier selection depend upon experimental group? 
#----------------------------------------------------

DT.prop.by.cell <- df.openings[is.first.opening == TRUE,
                               list(num.obs = .N),
                               by = list(grp, tier)]

DT.prop.by.cell[ ,frac := num.obs/sum(num.obs), by = grp]
DT.prop.by.cell[ ,N := sum(num.obs), by = grp]
DT.prop.by.cell[ ,se := sqrt(frac * (1 - frac))/sqrt(N), by = grp] 

dodge <- position_dodge(width = 0.5)
g.choices.by.cell <- ggplot(DT.prop.by.cell, aes(x = tier,
                                                 y = frac)) +
    geom_point(aes(colour = grp), position = dodge) +
    geom_errorbar(aes(ymin = frac - 2*se,
                      ymax = frac + 2*se,
                      colour = grp), width = 0.5, position = dodge) +
    theme_bw() +
    xlab("Selected Tier") +
    ylab("Fraction of Employers Selecting Tier")

writeImage(g.choices.by.cell, "tiers_by_cell", path = plots.path)

#------------------------------------------------------------------------------
#' Does revelation change P/Q choice and does it change with experience? 
#------------------------------------------------------------------------------

df.reveal <- subset(df.openings,
                   (G2 | G3) &
                   !is.na(contractor_tier) &
                   is.first.opening)

df.reveal$tier.z <- with(df.reveal, scale(contractor_tier))

m.base.tier <- lm(tier.z ~ G2, data = df.reveal)
m.low.spend.tier <- update(m.base.tier, LT ~ G2*I(prior_spend > 0))
m.middle.spend.tier <- update(m.low.spend.tier, MT ~ .)
m.high.spend.tier <- update(m.low.spend.tier, HT ~ .)
covariate.labels <- c("P/Q choice shown to applicants, ShownPref",
                   "Any prior spend on oDesk, AnyPriorSpend",
            "ShownPref $\\times$ AnyPriorSpend")
dep.var.labels <- c("Tier z-score", 
            "Low Tier",
            "Middle Tier",
            "High Tier")

out.file <- "../writeup/tables/knowledge_and_choice_past_exper.tex"
sink(file = "/dev/null")
s <- sg(m.base.tier, m.low.spend.tier, m.middle.spend.tier, m.high.spend.tier,
        title = paste("Effect of knowledge that p/q choice will be",
            "exposed to would-be applicants on the employer's p/q choice"),
        label = "tab:revelation",
        omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
        dep.var.labels = dep.var.labels,
        covariate.labels = covariate.labels)
sink()

note <- paste("This table reports OLS regressions of an employer's p/q selection---as captured by a z-score in Column~(1) or as tier-specific indicators in Columns~(2) through (4)---on an indicator for whether that p/q choice would or would not be shown to would-be applicants.
In Columns~(2) through (4) the ShowPref indicator is interacted with an indicator for whether the employer had previously spent any money on the platform.
Column~(1) shows estimates for Equation~\\ref{eq:tierz}, while Columns~(2) through (4) show estimates for variants of Equation~\\ref{eq:tieri}. 
The sample is restricted to employers in the explicit arm. \\explicitdef \\tierdef
The Column~(1) z-score of p/q tier choice is constructed by treating tiers selections as integers in successive, ascending order.
Standard errors are robust to heteroscedasticity. 
 \\starlanguage")
JJHmisc::AddTableNote(s, out.file, note = NoteWrapper(note, TableWidth(dep.var.labels, covariate.labels)))

out.file <- "../writeup/tables/knowledge_and_choice_past_exper.tex"
## m.ht <- felm(HT ~ opening.rank*as.numeric(ats.message) + G(employer), clustervar = "employer",
##              data = subset(df.openings,
##               openings.per.employer < MAX.OPENINGS.PER.EMPLOYER & contractor.shown))


MAX.OPENINGS.PER.EMPLOYER <- 10
m.ht <- felm(HT ~ opening.rank + G(employer), clustervar = "employer",
             data = subset(df.openings,
              openings.per.employer < MAX.OPENINGS.PER.EMPLOYER))
m.mt <- felm(MT ~ opening.rank + G(employer), clustervar = "employer",
             data = subset(df.openings,
              openings.per.employer < MAX.OPENINGS.PER.EMPLOYER))
m.lt <- felm(LT ~ opening.rank + G(employer), clustervar = "employer",
             data = subset(df.openings,
              openings.per.employer < MAX.OPENINGS.PER.EMPLOYER))
m.ht.inter <- felm(HT ~ opening.rank*as.numeric(G2) + G(employer),
                   clustervar = "employer",
                   data = subset(df.openings,
                       openings.per.employer < MAX.OPENINGS.PER.EMPLOYER))

out.file <- "../writeup/tables/employer_choice_fe.tex"
sink(file = "/dev/null")
s <- sg(m.lt, m.mt, m.ht, m.ht.inter,  
               title = paste("Employer p/q  selection over time, by treatment assignemnt"),                
               label = "tab:employer_choice_fe",
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
        dep.var.labels = c("Select Low Tier",
            "Select Middle Tier",
            "Select High Tier", "Select High Tier"),
        covariate.labels = c("OpeningRank", "ShownPref", "ShownPref x OpeningRank")
        )
sink()
note <- paste("This table reports regressions where the dependent variable is an indicator for an employer's p/q tier selection and the independent variables are the chronological rank of the opening (ascending order) for that particular employer, OpeningRank, and its interactions with ShownPref.
\\shownprefdef
The sample is restricted to employers assigned to the explicit arm that posted more than 1 but fewer than 10 openings.
\\explicitdef
In each regression, an employer-specific fixed-effect is included. 
Standard errors are clustered at the employer level. 
 \\starlanguage") 
AddTableNote(s, out.file, note = NoteWrapper(note, 1))


#######################################
# Applicant pool count and composition
#######################################

#-----------------------------------------------------------------
#' Does the treatments affect the number of applications received?
#' ---------------------------------------------------------------

plotLine <- function(model, ylab){
    df.apps.fx <- expand.grid(contractor.shown = c(TRUE, FALSE),
                          tier = c("Low Tier", "Medium Tier", "High Tier")
                          )
    df.apps.fx$y <- predict(model, newdata = df.apps.fx)
    df.apps.fx$se <- predict(model, newdata = df.apps.fx, se.fit = TRUE)$se.fit

    df.delta <- data.table(df.apps.fx)[,
                                   list(pct.change = y[contractor.shown == TRUE] - y[contractor.shown == FALSE],
                                        mid.point = mean(y)),
           by = list(tier)]
    df.delta$pos <- df.delta$pct.change > 0
    
    g <- ggplot(data = df.apps.fx, aes(x = contractor.shown, y = y)) +
        geom_line(aes(group = 1), colour = "grey") +
            geom_point(aes(x = contractor.shown, y = y)) + 
                geom_errorbar(aes(ymin = y - 2*se, ymax = y + 2*se), width = 0.1) + 
                    facet_wrap(~tier, ncol = 3) +
                            xlab("Workers shown buyer price/quality preference?") +
                                ylab(ylab) +
                                    geom_text(data = df.delta,
                                              aes(x = 1.5,
                                                  y = mid.point,
                                                  label = paste0(round(pct.change * 100, 2), "%"),
                                                  colour = factor(pos)
                                                  ))+
                                                      scale_colour_manual(values =
                                                                              c("TRUE" = "#228b22",
                                                                                "FALSE" = "red")) +                                                                                    
                                                  theme(legend.position = "none",
                                                         panel.background =  element_rect(fill = "white", colour = NA), 
                                                         panel.border =      element_rect(fill = NA, colour="grey50"), 
                                                         panel.grid.major =  element_line(colour = "grey90", size = 0.2),
                                                         panel.grid.minor =  element_line(colour = "grey98", size = 0.5)
                                                         )                                                 
}


writeImage(plotLine(m.apps.ambig.3, "Log number of applications"), "application_reg_viz", width = 7, height = 3)


#--------------------------------------
# Does the treatment affect recruiting?
#--------------------------------------

m.has.late.invites <- lm(I(num_late_invites > 0) ~ tier*contractor.shown,
                           data = df.ambiguous)
m.has.early.invites <- lm(I(num_early_invites > 0) ~ tier*contractor.shown,
                           data = df.ambiguous)
m.has.invites <- lm(I(num_invites > 0) ~ tier*contractor.shown,
                    data = df.ambiguous)
               
m.accept.ratio <- lm(I(num_accepted_invites/num_invites) ~
                     tier * contractor.shown,
                     data = subset(df.ambiguous,
                         num_invites > 0
                         & num_invites < 5))

out.file <- "../writeup/tables/invites.tex"
sink(file = "/dev/null")
s <- sg(m.has.late.invites, m.has.early.invites,
               m.has.invites, m.accept.ratio, 
               title = "Effects of price/quality revelation on employer recruiting",
               label = "tab:invites",
               font.size = "small", 
               covariate.labels = c("Medium Tier", "High Tier", "ShownPref",
                   "MT x ShownPref", "HT x ShownPref", "Constant"),
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
               dep.var.labels = c("Any late", "Any early", "Any",
                   "Acceptance Rate")
        )
sink()
note <- paste("The sample consists of the first vacancies by ambiguous",
              "arm employers.",
              "\\starlanguage")

JJHmisc::AddTableNote(s, out.file, note = NoteWrapper(note))
#----------------------------------------------------------
# Does the treatment affect employer viewing of applicants? 
#-----------------------------------------------------------

m.ambig.any <- lm(I(num_viewed > 0) ~ tier*contractor.shown, data = df.ambiguous)
m.ambig.rate <- lm(I(num_viewed/num_applications) ~ tier*contractor.shown, data = df.ambiguous)

note <- paste("The dependent variable in Column~(1) is whether any appliants were viewed by the employer, whereas in Column~(2), it is the fraction of applicants viewed. The sample consists of the first openings by employers in the ambiguous arm of the experiment. \\starlanguage.")

out.file <- "../writeup/tables/viewing.tex"
sink(file = "/dev/null")
s <- sg(m.ambig.any, m.ambig.rate,  
               title = paste("Effects of P/Q revelation on whether any candidates were viewed, as well as the fraction that were viewed by the treated employer"),
               covariate.labels = c("Medium Tier (MT)", "High Tier (HT)", "ShownPref", "MT x ShownPref", "HT x ShownPref"),
               dep.var.labels = c("Any viewed?", "Fraction viewed"), 
               label = "tab:viewed"
        )
sink()
AddTableNote(s, out.file, NoteWrapper(note))

#----------------------------------------------------------
# Does the treatment affect screening? (number interviewed) 
#----------------------------------------------------------

m.interviewed.any <- lm(I(num_interviewed > 0) ~ tier*contractor.shown,
                        data = df.ambiguous[num_interviewed < 10,])
m.interviewed.rate <- lm(I(num_interviewed/num_applications) ~ tier*contractor.shown,
                         data = df.ambiguous[num_interviewed < 10,])
m.interviewed.count <- lm(num_interviewed~ tier*contractor.shown,
                          data = df.ambiguous[num_interviewed < 10,])

note <- paste("The dependent variable in Column~(1) is whether any appliants were interviewed by the employer, whereas in Column~(2), it is the fraction of applicants interviewed.
Column~(3) is the count of applicants interviewed. 
The sample consists of the first openings by employers in the ambiguous arm of the experiment. \\starlanguage.")

out.file <- "../writeup/tables/interviews.tex"
sink(file = "/dev/null")
s <- sg(m.interviewed.any, m.interviewed.rate, m.interviewed.count, 
               title = "Effect of P/Q revelation on whether any candidates are interviewed, as well as the fraction of candidates and the total count.",
               covariate.labels = c("Medium Tier (MT)", "High Tier (HT)", "ShownPref", "MT x ShownPref", "HT x ShownPref"),
               dep.var.labels = c("Any Interviewed?", "Fraction Interviewed", "Count of Interviews"), 
               label = "tab:interviews"
        )
sink()
AddTableNote(s, out.file, NoteWrapper(note))


##################
# Opening Outcomes
##################

# Fill Rate---------------------------------------------------------------------

m.fill.shown.tier <- lm(filled ~ contractor.shown * tier,
                   data = df.ambiguous)



# Effect on hours worked-------------------------------------------------------- 

writeImage(plotLine(m.ambig.hours.i, "Log hours worked"), "hours_reg_viz", width = 7, height = 3)

#' Visualize hours worked

ggplot(data = df.ambiguous, aes(x = log(hours), colour = factor(contractor.shown))) +
    geom_density() + facet_wrap(~level1, ncol = 3)


ggplot(data = df.ambiguous, aes(x = log(hours), colour = factor(contractor.shown))) +
    geom_density() + facet_grid(tier ~ level1)

#-------------
# Hourly rate 
#-------------

writeImage(plotLine(m.ambig.wage.i, "Mean log hourly wage"), "hourly_wage_reg_viz", width = 7, height = 3)

######################################
# EX POST MEAURES OF CONTRACT OUTCOMES
######################################

# Successes---------------------------------------------------------------------

m.success <- lm(I(successes > 0) ~ contractor.shown, data = df.explicit)
m.success.ambig <- lm(I(successes > 0) ~ contractor.shown,
                data = df.ambiguous)
m.success.ambig.i <- lm(I(successes > 0) ~ tier*contractor.shown,
                data = df.ambiguous)

out.file <- "../writeup/tables/success.tex"
sink(file = "/dev/null")
s <- sg(m.success, m.success.ambig, m.success.ambig.i, 
               title = "Employer rated the project a success",
               label = "tab:success",
               covariate.labels = c("Medium Tier (MT)", "High Tier (HT)", "ShownPref",
                   "MT x ShownPref", "HT x ShownPref", "Constant"), 
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
               column.labels = c("Explicit", "Ambig", "Ambig")
               )
sink() 
JJHmisc::AddTableNote(s, out.file, NoteWrapper("Here are some notes TK"))


# Feedbacks---------------------------------------------------------------------


tableContinuous(vars = rename(subset(df.ambiguous,
                    select = c(average_feedback_to_client, average_feedback_to_contractor)),
                    c("average_feedback_to_client" = "FB to Employer",
                      "average_feedback_to_contractor" = "FB to Worker")),
                group = df.ambiguous$contractor.shown,
                file = "../writeup/tables/feedback_ss.tex",
                cap = "Summary statistics for feedback in the ambiguous arm",
                label = "tab:feedback_ss",        
                caption.placement = "top")



m.to.client.e <- lm(average_feedback_to_client ~ contractor.shown, data =
                        subset(df.explicit,
                               !is.na(average_feedback_to_client) &
                                   !is.na(average_feedback_to_contractor)
                               ))

m.to.worker.e <- lm(average_feedback_to_contractor ~ contractor.shown, data =
                        subset(df.explicit,
                               !is.na(average_feedback_to_client) &
                                   !is.na(average_feedback_to_contractor)
                               ))


m.to.client.a <- lm(average_feedback_to_client ~ contractor.shown,
                    data = subset(df.ambiguous,
                          !is.na(average_feedback_to_client) &
                                   !is.na(average_feedback_to_contractor)
                               ))


m.to.worker.a <- lm(average_feedback_to_contractor ~ contractor.shown,
                    data = subset(df.ambiguous,
                        !is.na(average_feedback_to_client) &
                                   !is.na(average_feedback_to_contractor)
                                  ))


out.file <- "../writeup/tables/feedback.tex"
sink(file = "/dev/null")
s <- sg(m.to.client.e, m.to.client.a, m.to.worker.e, m.to.worker.a,  
               title = "Bi-lateral feedback scores",
               label = "tab:feedback",
               #covariate.labels = c("Medium Tier (MT)", "High Tier (HT)", "ShownPref",
               #    "MT x ShownPref", "HT x ShownPref", "Constant"), 
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser")
               #dep.var.labels = c("To Employer", "To Worker",
               #    "To Worker", "To Employer"), 
               #column.labels = c("Explicit", "Explicit", "Ambig", "Ambig")
               )
sink() 
JJHmisc::AddTableNote(s, out.file, NoteWrapper("Here are some notes"))



m.to.client.a <- lm(average_feedback_to_client ~ tier*contractor.shown,
                    subset(df.ambiguous, 
                                                               !is.na(average_feedback_to_client) &
                                                                   !is.na(average_feedback_to_contractor)
                    ))

m.to.contractor.a <- lm(average_feedback_to_contractor ~ tier*contractor.shown,
                        subset(df.ambiguous, 
                               !is.na(average_feedback_to_client) &
                                   !is.na(average_feedback_to_contractor)
                               ))

out.file <- "../writeup/tables/feedback_cond.tex"
sink(file = "/dev/null")
s <- sg(m.to.client.a, m.to.contractor.a,
               title = "Bi-lateral feedback scores in the ambiguous arm, by tier selection",
               label = "tab:feedback_cond",
               #covariate.labels = c("Medium Tier (MT)", "High Tier (HT)", "ShownPref",
               #    "MT x ShownPref", "HT x ShownPref", "Constant"), 
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser")
               #dep.var.labels = c("To Employer", "To Worker",
               #    "To Worker", "To Employer"), 
               #column.labels = c("Explicit", "Explicit", "Ambig", "Ambig")
               )
sink() 
JJHmisc::AddTableNote(s, out.file, NoteWrapper("Here are some notes"))


#############################
# Did the ATS message matter?
#############################

m <- lm(I(total_charge > 0) ~ ats.message, data = subset(df.ambiguous, contractor.shown))

m.filled <- lm(I(total_charge > 0) ~  ats.message * tier,
               data = subset(df.ambiguous, contractor.shown))

#m.filled <- lm(I(total_charge > 0) ~  ats.message * log1p(prior_spend) * tier,
#               data = subset(df.ambiguous, contractor.shown))

m.wage.bill <- lm(log(total_charge) ~ ats.message * tier,
                  data = subset(df.ambiguous, contractor.shown & total_charge > 0))

m.wage <- lm(log(mean_wage_over_contract) ~ ats.message * tier,
             data = subset(df.ambiguous, contractor.shown & mean_wage_over_contract > 0))

m.hours <- lm(log(hours) ~ ats.message * tier,
              data = subset(df.ambiguous, contractor.shown & hours > 0))
m.fb <- lm(average_feedback_to_contractor ~ ats.message * tier,
           data = subset(df.ambiguous, contractor.shown & average_feedback_to_contractor > 0))
covariate.labels = c("Messaging", "Medium Tier (MT)", "High Tier (HT)",
                    "MT x Messaging", "HT x Messaging", "Constant") 
out.file <- "../writeup/tables/ats_message.tex"
sink(file = "/dev/null")
s <- sg(m.filled, m.wage.bill, m.wage, m.hours, m.fb,       
               title = "Effects of messaging about p/q revelation in the ambiguous arm on a variety of outcomes",
               label = "tab:ats",
        omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
        dep.var.labels = c("Filled", "Log Wage Bill", "Log Mean Wage", "Log hours", "FB to Worker"),
        covariate.labels = covariate.labels, 
        font.size = "footnotesize"
        )
sink()
note <- paste("This table reports OLS regressions on a number of opening outcomes on an indicator, Messaging, for whether the realized value of ShownPref was shown to employers again before they screened would-be applicants.
The sample consists of openings from the ambiguous arm.
\\ambigdef
\\shownprefdef
\\tierdef
Standard errors are robust to heteroscedasticity.  \\starlanguage")
JJHmisc::AddTableNote(s, out.file, NoteWrapper(note, 1))



##########################################
# WORKER APPLICATION DECISIONS AND BIDDING
##########################################

df.apps <- readRDS(APPLICATIONS.CLEAN.FILE)

setkey(df.openings, economic_opening)
setkey(df.apps, economic_opening)

## df.apps <- merge(df.apps,df.openings[,list(economic_opening, tier, grp, contractor.shown, ambigious.arm, level1, level2)],
##                  by="economic_opening", all.x=TRUE, all.y=FALSE)

df.apps[, hourly_rate_snap := as.numeric(as.character(hourly_rate_snap))]
df.apps[, ambigious.arm := factor(ambigious.arm)]
df.apps[, economic_opening := factor(economic_opening)]
df.apps[, contractor.shown := factor(contractor.shown)]




#--------------------------------------------------------
# Do workers bid more when facing a higher-tier employer? 
#--------------------------------------------------------

MIN.HOURLY.RATE <- 0.25
MAX.HOURLY.RATE <- 100

df.reasonable.apps <- subset(df.apps,
                             job_type.x == "hr" & 
                             hr_charge_rate > MIN.HOURLY.RATE &
                             hr_charge_rate < MAX.HOURLY.RATE &
                             is.first.opening &
                             !is.na(contractor.shown))

m <- felm(log(hr_charge_rate) ~ tier * contractor.shown +
              G(contractor),
          data = df.reasonable.apps)


m <- felm(I(status == "filled")  ~ tier * log(hr_charge_rate) + G(contractor),
          data = df.reasonable.apps)

# some evidence that contractors endogenously change their profile rate
# - we probably need to change 
m <- felm(log(hourly_rate_snap) ~ tier + G(contractor),
          data = subset(df.reasonable.apps, hourly_rate_snap > 0))


#'-----
m <- felm(I(status == "filled")  ~ tier * log(hr_charge_rate) + G(contractor),
          clustervar = "contractor", 
          data = df.reasonable.apps)


m <- felm(I(status == "filled")  ~ ats.message * tier * log(hr_charge_rate) + G(contractor),
          clustervar = "contractor", 
          data = subset(df.reasonable.apps, G4 | G5))



###########################
# Analysis of hired workers
###########################

MIN.WAGE <- 0.75
MAX.WAGE <- 100

df.hired <- df.apps[hr_charge_rate > MIN.WAGE   &
                    hr_charge_rate < MAX.WAGE   &
                    hourly_rate_snap > MIN.WAGE &
                    hourly_rate_snap < MAX.WAGE &
                    status == 'filled' &
                    is.first.opening == TRUE &
                    ambigious.arm == TRUE, ]

df.hired[, num.hires := .N, by = economic_opening]

#------------------------
# Hired Worker Attributes
#------------------------

m.pr <- lm(log(hourly_rate_snap) ~ contractor.shown * tier,
           data = subset(df.hired, num.hires == 1))
m.wb <- lm(log(hr_charge_rate) ~ contractor.shown * tier,
           data = subset(df.hired, num.hires == 1))
m.prior <- lm(log(prior_earnings) ~ contractor.shown * tier,
              data = subset(df.hired, num.hires == 1 & prior_earnings > 0))

covariate.labels = c("Medium Tier (MT)", "High Tier (HT)", "ShownPref",
                   "MT x ShownPref", "HT x ShownPref", "Constant") 

notes <- "Here are some notes"
out.file <- "../writeup/tables/hired_worker.tex"
sink(file = "/dev/null")
s <- sg(m.pr, m.wb, m.prior, 
               title = "Attributes of hired workers in the ambiguous arm",
               label = "tab:hired_workers",
               omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
               dep.var.labels = c("Profile Rate", "Wage Bid",
                   "Prior earnings"),
        
               covariate.labels = c("ShownPref", "Medium Tier", "High Tier (HT)", "MT x ShownPref",
              "HT x ShownPref", "Constrant")
               )
sink() 
JJHmisc::AddTableNote(s, out.file, NoteWrapper(note))



# Explicit----------------------------------------------------------------------

df.hired.explicit <- df.apps[hr_charge_rate > MIN.WAGE   &
                    hr_charge_rate < MAX.WAGE   &
                    hourly_rate_snap > MIN.WAGE &
                    hourly_rate_snap < MAX.WAGE &
                    status == 'filled' &
                    (G2 | G3), ]

df.hired.explicit[, num.hires := .N, by = economic_opening]

m.pr <- lm(log(hourly_rate_snap) ~ contractor.shown,
           data = subset(df.hired.explicit, num.hires == 1))

m.wb <- lm(log(hr_charge_rate) ~ contractor.shown,
           data = subset(df.hired.explicit, num.hires == 1))

m.prior <- lm(log(prior_earnings) ~ contractor.shown,
           data = subset(df.hired, num.hires == 1 & prior_earnings > 0))


mtable(m.pr, m.wb, m.prior)








#----------------------
# Wages of hired worker
#----------------------

m.wage.overall.mm <- lmer(log(hr_charge_rate) ~ contractor.shown * tier +
                          (1|economic_opening), data =
                     df.hired)


m.wage.overall <- lm(log(hr_charge_rate) ~ contractor.shown * tier,
                     data = df.hired[num.hires == 1])

m.wage.ambig <- lm(log(hr_charge_rate) ~ contractor.shown * tier,
                   data = df.hired[
                       ambigious.arm == TRUE
                       & num.hires == 1
                       ])

m.wage.ambig.mm <- lmer(log(hr_charge_rate) ~ contractor.shown * tier +
                        (1|economic_opening),
                        data = df.hired[
                            ambigious.arm == TRUE
                            ])

sample.labels <- c("All openings, single hire",
                   "All openings, all hires",
                   "Ambig. openings, single hires",
                   "Ambig. openings, all hires")


out.file <- "../writeup/tables/wage_of_hired.tex"
sink(file = "/dev/null")
s <- sg(m.wage.overall.mm, m.wage.overall,
               m.wage.ambig, m.wage.ambig.mm,
               title = "Effects of treatment on hourly wage of the hired worker",
               label = "tab:wage_hired",
               covariate.labels = c("Worker shown preference",
                   "Medium tier",
                   "High tier",
                   "Worker shown preference $\\times$ Medium Tier",
                   "Worker shown preference $\\times$ High Tier",
                   "Intercept")
               )
sink()
AddTableNote(s, out.file, note = c("\\emph{Notes:} Here are some notes."))

#------------------------
# Profile of hired worker
#------------------------

m.pr.overall.mm <- lmer(log(hourly_rate_snap) ~ contractor.shown * tier +
                        (1|economic_opening),
                        data = df.hired)

m.pr.overall <- lm(log(hourly_rate_snap) ~ contractor.shown * tier,
                   data = df.hired[
                       num.hires == 1
                       ])

m.pr.ambig <- lm(log(hourly_rate_snap) ~ contractor.shown * tier,
                   data = df.hired[
                       ambigious.arm == TRUE &
                       num.hires == 1
                       ])

m.pr.ambig.mm <- lmer(log(hourly_rate_snap) ~ contractor.shown * tier +
                      (1|economic_opening),
                   data = df.hired[
                       ambigious.arm == TRUE
                       ])

out.file <- "../writeup/tables/pr_of_hired.tex"
sink(file = "/dev/null")
s <- sg(m.pr.overall, m.pr.overall.mm, m.pr.ambig, m.pr.ambig.mm,
               title = "Effects of treatment on profile rate of the hired worker",
               label = "tab:pr_hired",
               covariate.labels = c("Worker shown preference",
                   "Medium tier",
                   "High tier",
                   "ShwnPref $\\times$ Med.",
                   "ShwnPref $\\times$ High.",
                   "Intercept")
)
sink()
AddTableNote(s, out.file, note = c("\\emph{Notes:} Here are some notes."))

#------------------------------
# Interviewed worker attributes
#------------------------------

df.apps[, interviewed := !is.na(employer_interview_decision_timestamp)]

# Interview characteristics 
df.interviewed <- df.apps[(interviewed) &
                          hourly_rate_snap > MIN.WAGE &
                          hourly_rate_snap < MAX.WAGE &
                          hr_charge_rate > MIN.WAGE &
                          hr_charge_rate < MAX.WAGE]

m.pr.ambig.interviewed <- lmer(log(hourly_rate_snap) ~
                               contractor.shown * tier + (1|economic_opening),
                               data = df.interviewed[
                                   ambigious.arm == TRUE
                                   ])

m.wage.ambig.interviewed <- lmer(log(hr_charge_rate) ~
                                 contractor.shown * tier + (1|economic_opening),
                                 data = df.interviewed[
                                     ambigious.arm == TRUE
                                     ])


out.file <- "../writeup/tables/interviewee_attributes.tex"
sink(file = "/dev/null")
s <- sg(m.pr.ambig.interviewed, m.wage.ambig.interviewed,
               title = "Interviewee attributes",
               label = "tab:interviewee_attributes",
               column.labels = c("Profile Rate (Ambig)", "Wage Bid (Ambig)"))
AddTableNote(s, out.file, note = "\\emph{Notes:} Here are some TK notes.")
sink()


###########################################
# Per-opening moments of the applicant pool
###########################################

## df.apps$cs <- as.logical(as.character(df.apps$contractor.shown))

## appPoolPercentiles <- function(outcome, outcome.min, outcome.max, transform.func = function(x) x){    
##     df.tmp <- df.apps[get(outcome) > outcome.min & get(outcome) < outcome.max & ambigious.arm == TRUE & is.first.opening,
##                       list(mu=mean(get(outcome)),
##                            sigma = sd(get(outcome)),
##                            pct25 = quantile(get(outcome), 0.25),
##                            pct75 = quantile(get(outcome), 0.75),
##                            pct90 = quantile(get(outcome), 0.90),
##                            pct50 = quantile(get(outcome), 0.50),
##                            num.obs=.N
##                            )
##                     , by = list(economic_opening, tier,
##                           cs, level1, level2)]
##     m.25 <- lm(pct25 ~ cs * tier , df.tmp)
##     m.50  <- lm(pct50 ~ cs * tier , df.tmp)
##     m.75 <- lm(pct75 ~ cs * tier , df.tmp)
##     m.90 <- lm(pct90 ~ cs * tier , df.tmp)
##     m.50.re <- lmer(pct50 ~ cs * tier + (1|level2), data = df.tmp)
##     #m.50.re <- felm(pct50 ~ cs * tier + G(level2), clustervar = "level2", data = df.tmp)
##     list("25" = m.25, "50" = m.50, "75" =  m.75, "90" = m.90, "re" = m.50.re)
## }

## getLaTeXTable <- function(models, out.file, title, label, dep.var.caption, note, width = 1.0){
##     sink(file = "/dev/null")
##     s <- sg(models["25"], models["50"], models["75"], models["90"], models["re"], 
##                    dep.var.labels = c("25th", "50th", "75th", "90th", "50th (with RE)"),
##                    dep.var.caption = dep.var.caption,
##                    # dep.var.labels = NULL, 
##                    covariate.labels = c("ShownPref", "Medium Tier (MT)",
##                        "High Tier (HT)",
##                        "MT $\\times$ ShownPref", "HT $\\times$ ShownPref"),  
##                    title = title, 
##                    omit.stat = c("aic", "f", "adj.rsq", "ll", "bic", "ser"),
##                    label = label
##             )
##     sink()
##     AddTableNote(s, out.file, NoteWrapper(note, width))
## }



## df.apps$lhourly_rate_snap <- with(df.apps, log(hourly_rate_snap))
## models <- HotTowelR::appPoolPercentiles(df.apps, "lhourly_rate_snap", log(0.25), log(100))
## out.file <-  "../../writeup/tables/profile_rate_percentiles.tex"
## dep.var.caption <- paste("Per-opening percentiles of applicant log profile wage",
##                  "by opening:")
## title <- "Effect of p/q revelation on the market wage of applicants, as measured by applicant profile rates"
## label <- "tab:pr_rate_percentiles"
## note <- paste("This table reports regressions of the various per-opening percentiles of the log profile rate of applicants on ShownPref interacted with indicators for the employer's p/q tier selection. All regressions are OLS estimates of Equation~\\ref{eq:pr} (with differing percentiles) except in Column~(5), which reports a regression with a category-specific random-effect to control for the type of work asked for in the opening e.g., computer programming, graphic design etc.
## The sample for each regression consists of job openings assigned to the ambiguous arm of the experiment.
## \\ambigdef  Standard errors are robust to heteroscedasticity.  \\starlanguage")
## HotTowelR::GetLaTeXTable(models, out.file, title, label, dep.var.caption, note, width = 0.90)
## JJHMisc::writeImage(HotTowelR::CreatePlot(models, "Quantiles of log profile rate"), "profile_rate_reg_viz", width = 7, height = 3)
 


#--------------------------------------------------------------------------
# Did the treatments affect the probability of making a subsequent opening? 
#--------------------------------------------------------------------------

m.count <- lm(num.openings ~ grp, df.openings[(is.first.opening)])

m.log <- lm(log(num.openings) ~ grp, data = df.openings[(is.first.opening)])

m.shown <- lm(log(num.openings) ~ contractor.shown,
              data = subset(df.openings, is.first.opening))

m.log.ambig <- lm(log(num.openings) ~ grp,
                  data = subset(df.openings,
                      ambigious.arm & is.first.opening))

m.log.ambig.cs <- lm(log(num.openings) ~ contractor.shown,
                     data = subset(df.openings,
                         ambigious.arm & is.first.opening))


