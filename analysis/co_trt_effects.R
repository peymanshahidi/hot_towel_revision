#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

scale.z <- function(x) (x - mean(x, na.rm = TRUE))/sd(x, na.rm = TRUE)


df.openings <- readRDS("../etl/transformed/openings.rds") %>% as.data.frame %>% 
    mutate(
        log.num.apps = log(num_applications),
        any.interviews = I(num_organic_applicants_interviewed > 0),
        any.hires = I(num_hires > 0), 
        log.wage = log(mean_wage_over_contract),
        log.hours = log(hours),
        log.total_charge = ifelse(total_charge > 0, log(total_charge), 0),
        nps_score_cli = (nps_score_cli - mean(nps_score_cli, na.rm = TRUE))/sd(nps_score_cli, na.rm = TRUE), 
        average_feedback_to_contractor = (average_feedback_to_contractor - mean(average_feedback_to_contractor, na.rm = TRUE))/sd(average_feedback_to_contractor, na.rm = TRUE),
        average_feedback_to_client = (average_feedback_to_client - mean(average_feedback_to_client, na.rm = TRUE))/sd(average_feedback_to_client, na.rm = TRUE)
        )

df.all <- df.openings %>% filter(
                              1 == 1 
                              & !bad  
                              & visibility != "private"
                              & num_applications > 0) 



to.estimate <- list(
    list(outcome = "log.num.apps", label = "Log num. applications", restrictions = "1==1"),
    list(outcome = "any.interviews", label = "Any interviews?", restrictions = "1==1"),
    list(outcome = "any.hires", label = "Any hires?", restrictions = "1==1"), 
    list(outcome = "log.wage", label = "Log wage of hired worker", restrictions = "mean_wage_over_contract > 0.25 & hours > 0.25 & total_charge > 0"),
    list(outcome = "log.hours", label = "Log hours-worked", restrictions = "mean_wage_over_contract > 0.25 & hours > 0.25 & total_charge > 0"),
    list(outcome = "log.total_charge", label = "Log total wage bill", restrictions = "total_charge > 0 & mean_wage_over_contract > 0.25 & hours > 0.25"),
    list(outcome = "average_feedback_to_contractor", label = "Feedback to worker", restrictions = "!is.na(average_feedback_to_contractor)"),
    list(outcome = "average_feedback_to_client", label = "Feedback to employer", restrictions = "!is.na(average_feedback_to_client)"),
    list(outcome = "nps_score_cli", label = "Recommend platform score", restrictions = "!is.na(nps_score_cli)")
    )


GetOutcome <- function(df, params){
    df.est <- subset(df, eval(parse(text = params$restrictions)))
    get.mu <- . %>% filter(!contractor.shown) %>% (function(x) x[[params$outcome]]) %>% mean 
    pooled.mu <- df.est %>% get.mu
    low.mu <- df.est %>% filter(tier == "Low Tier") %>% get.mu
    low.n <- df.est %>% filter(tier == "Low Tier") %>% nrow
    med.mu <- df.est %>% filter(tier == "Medium Tier") %>% get.mu
    med.n <- df.est %>% filter(tier == "Medium Tier") %>% nrow
    high.mu <-df.est %>% filter(tier == "High Tier") %>% get.mu
    high.n <- df.est %>% filter(tier == "High Tier") %>% nrow
    #m <- lm(as.formula(paste0(params$outcome,
    #                          "~ contractor.shown:tier - 1 + tier")),
    #        data = df.est)
    m <- felm(as.formula(paste0(params$outcome,
                              "~ contractor.shown:tier - 1 + tier|0|0|employer")),
            data = df.est)
    m.pooled <- felm(as.formula(paste0(params$outcome,
                              "~ contractor.shown | 0 | 0 | employer")),
                     data = df.est)
    pooled.n <- df.est %>% nrow
    num.groups <- df.est %$% employer %>% unique %>% length
    delta.pooled <- coef(m.pooled)[2]
    se.pooled <- sqrt(diag(vcov(m)))[2]
    t.stat.pooled <- delta.pooled / se.pooled 
    delta <- coef(m)[4:6]
    delta.se = sqrt(diag(vcov(m)))[4:6]
    label <- params$label
    data.frame(delta = c(delta.pooled, delta),
               delta.se = c(se.pooled, delta.se),
               delta.t.stat = c(t.stat.pooled, delta / delta.se),
               tier = c("Pooled", "Low Tier", "Medium Tier", "High Tier"),
               mu = c(pooled.mu, low.mu, med.mu, high.mu),
               n = c(pooled.n, low.n, med.n, high.n),
               num.groups = c(num.groups, num.groups, num.groups, num.groups)
               ) %>% 
        mutate(
            outcome = label
        )
}


df.effects <- data.frame()

# All 
df.combo <- do.call("rbind", lapply(to.estimate, function(x) GetOutcome(df.all, x)))
outcomes <- lapply(to.estimate, function(x) x$label) %>% unlist %>% as.vector
df.combo$outcome <- with(df.combo, factor(outcome, levels = outcomes))
saveRDS(df.combo, "../computed_objects/trt_effects.rds")

df.effects <- rbind(df.effects, df.combo %>% mutate(sample = "All arms; All openings"))

## All - first 
df.all.first <- df.all %>% filter(is.first.opening)
df.combo <- do.call("rbind", lapply(to.estimate, function(x) GetOutcome(df.all.first, x)))
outcomes <- lapply(to.estimate, function(x) x$label) %>% unlist %>% as.vector
df.combo$outcome <- with(df.combo, factor(outcome, levels = outcomes))
saveRDS(df.combo, "../computed_objects/trt_effects_all_first.rds")

df.effects <- rbind(df.effects, df.combo %>% mutate(sample = "All arms; First openings"))

## Ambiguous
df.ambiguous <- subset(df.openings,
                         is.first.opening &
                         (G4 | G5 | G6)
                         & !bad
                         & visibility != "private"
                         & num_applications > 1)

df.combo <- do.call("rbind", lapply(to.estimate, function(x) GetOutcome(df.ambiguous, x)))
outcomes <- lapply(to.estimate, function(x) x$label) %>% unlist %>% as.vector
df.combo$outcome <- with(df.combo, factor(outcome, levels = outcomes))
saveRDS(df.combo, "../computed_objects/trt_effects_ambiguous.rds")

df.effects <- rbind(df.effects, df.combo %>% mutate(sample = "Ambiguous; First openings"))

## Explicit
df.ambiguous <- subset(df.openings,
                         is.first.opening &
                         (G2 | G3)
                         & !bad
                         & visibility != "private"
                         & num_applications > 1)

df.combo <- do.call("rbind", lapply(to.estimate, function(x) GetOutcome(df.ambiguous, x)))
outcomes <- lapply(to.estimate, function(x) x$label) %>% unlist %>% as.vector
df.combo$outcome <- with(df.combo, factor(outcome, levels = outcomes))

saveRDS(df.combo, "../computed_objects/trt_effects_explicit.rds")

df.effects <- rbind(df.effects, df.combo %>% mutate(sample = "Explicit; First openings"))

saveRDS(df.effects, "../computed_objects/trt_effects_robust.rds")



