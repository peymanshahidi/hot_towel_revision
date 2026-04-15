#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

outcome.min <- log(0.25)
outcome.max <- log(100)

df.apps.raw <- readRDS("../etl/transformed/small_applications.rds") %>%
    mutate(outcome = log(hr_charge_rate)) %>%
    mutate(hired = status %in% c('filled'))

df.apps <- df.apps.raw %>% filter(hr_charge_rate > 0.25) %>%
    filter(hourly_rate_snap > 0.25)

GetResults <- function(m, df.est, outcome){

    df.skel <- expand.grid(contractor.shown = c(TRUE, FALSE),
                           tier = unique(df.est$tier) %>% as.character)
    df.skel$tier <- with(df.skel, factor(tier, levels = c("Low Tier", "Medium Tier", "High Tier")))
    df.skel$pretty.contractor.shown <- with(
        df.skel,
        ifelse(contractor.shown, "ShownPref\n=1",
               "ShownPref\n=0"))
    V <- vcov(m)
    X <- model.matrix(~contractor.shown * tier, data = df.skel)[,-1]
    df.skel$y.hat <- as.numeric(X %*% coef(m))
    df.skel$se <- sqrt(as.numeric(unname(rowSums((X %*% V) * X))))
    df.skel %<>% mutate(outcome = outcome)
    df.skel %<>% mutate(sample.size = nrow(model.frame(m)))
    df.skel
}

df.est <- df.apps %>% filter(prior_hours >= 0.25)

m.hours <- felm(log(prior_hours) ~ contractor.shown * tier | contractor | 0 | contractor, 
          data = df.est)

m.bidding <- felm(log(hr_charge_rate) ~ contractor.shown * tier | contractor | 0 | contractor, 
                  data = df.apps)

m.pr <- felm(lhourly_rate_snap ~ contractor.shown * tier | contractor | 0 | contractor, 
                        data = df.apps %>% filter(hourly_rate_snap > 0.25))

m.hired <- felm(hired ~ contractor.shown * tier | contractor | 0 | contractor, 
                        data = df.apps.raw)



df.results <- rbind(GetResults(m.bidding, df.est, "Applicant wage bid"),
                    GetResults(m.hours, df.est, "Applicant prior hours"),
                    GetResults(m.pr, df.est, "Applicant profile rate"))


#                    GetResults(m.hired, df.est, "Hired")) 

df.results$outcome <- with(df.results,
                           factor(outcome,
                                  levels = c("Applicant wage bid",
                                             "Applicant profile rate",
                                             "Applicant prior hours"
                                             )))

pd <- position_dodge(0.1)


g <- ggplot(data = df.results, aes(x = tier, y = y.hat,
                                group = contractor.shown,
                                linetype = contractor.shown,
                                colour = contractor.shown,
                                fill = contractor.shown, 
                                shape = contractor.shown)
            ) + 
    geom_line(position = pd) +  
    geom_point(position = pd) + 
    geom_ribbon(aes(ymin = y.hat - 2*se, ymax = y.hat + 2*se),
                alpha = 0.15,
                position = pd) +
    theme_bw() + 
    theme(legend.position = "none",
          axis.title.y = element_text(angle = 0),
          axis.text.x = element_text(angle = 30, hjust = 1)
          ) +
    expand_limits(x = 5.5, y = 0.2) +
    facet_wrap(~outcome, ncol = 4) +
    geom_dl(data = . %>% filter(outcome == "Applicant wage bid"),
            aes(label = pretty.contractor.shown),
            method = list("last.points",
                          cex = 0.75, 
                          dl.trans(x = x + 0.2)
                          )
            ) +
    xlab("Employer vertical preferences") +
    ylab("Change\nin outcome\n(logs)") +
    geom_text(data = df.results %>% filter(tier == "High Tier"), aes(x = 4, y = -0.1, label = paste0("n=", formatC(sample.size, big.mark = ","))), colour = "black")

JJHmisc::writeImage(g, "bidding_effect",
                    width = 6,
                    height = 3,
                    path = "../writeup/plots/")



