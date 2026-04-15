#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

df.results.1 <- readRDS("../computed_objects/compare_wb_to_pr.rds")

addParam <- JJHmisc::genParamAdder("../writeup/params_reg_wb_pr_apps.tex")

extract.effect <- .  %>% multiply_by(100) %>% round(0)


addParam("\\EffectProfileRateAppHighTierRegression",
         df.results.1 %>% filter(term == "tierHigh Tier") %>% filter(outcome == "Outcome:\nApplicant\nprofile rate") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )
addParam("\\EffectProfileRateAppMedTierRegression",
         df.results.1 %>% filter(term == "tierMedium Tier") %>% filter(outcome == "Outcome:\nApplicant\nprofile rate") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )
addParam("\\EffectProfileRateAppLowTierRegression",
         df.results.1 %>% filter(term == "tierLow Tier") %>% filter(outcome == "Outcome:\nApplicant\nprofile rate") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )


df.results.2 <- readRDS("../computed_objects/compare_wb_to_pr_hired.rds")

addParam("\\EffectWageBidAppHighTierRegression",
         df.results.1 %>% filter(term == "tierHigh Tier") %>% filter(outcome == "Outcome:\nApplicant\nwage bid") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )
addParam("\\EffectWageBidAppMedTierRegression",
         df.results.1 %>% filter(term == "tierMedium Tier") %>% filter(outcome == "Outcome:\nApplicant\nwage bid") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )
addParam("\\EffectWageBidAppLowTierRegression",
         df.results.1 %>% filter(term == "tierLow Tier") %>% filter(outcome == "Outcome:\nApplicant\nwage bid") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )


addParam("\\EffectWageBidAppHighTierHiredRegression",
         df.results.2 %>% filter(term == "tierHigh Tier") %>% filter(outcome == "Outcome:\nHired worker\nwage bid") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )

addParam("\\EffectWageBidAppLowTierHiredRegression",
         df.results.2 %>% filter(term == "tierLow Tier") %>% filter(outcome == "Outcome:\nHired worker\nwage bid") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )

## df.results <- rbind(df.results.1, df.results.2) %>% ungroup %>%
##     mutate(outcome = factor(outcome, levels =  c(
##                                          "Outcome:\nApplicant\nprofile rate",
##                                          "Outcome:\nHired worker\nprofile rate",
##                                          "Outcome:\nApplicant\nwage bid",
##                                          "Outcome:\nHired worker\nwage bid"))
##            )

df.results <- rbind(df.results.1, df.results.2) %>% ungroup %>%
    mutate(outcome = factor(outcome, levels =  c(
                                         "Outcome:\nApplicant\nwage bid",
                                         "Outcome:\nHired worker\nwage bid",
                                         "Outcome:\nApplicant\nprofile rate",
                                         "Outcome:\nHired worker\nprofile rate"))
           )


gap <- 0.2


g <- ggplot(data = df.results,
            aes(x = model,
                y = estimate
                )) +
    geom_point() + 
    geom_errorbar(aes(
        ymin = estimate - 2*std.error,
        ymax = estimate + 2*std.error
    ), width = 0.1) +
                                        #facet_grid(new.term ~ outcome, scale = "free_y", space = "free") +
    facet_wrap(~outcome, ncol = 4) + 
    geom_line(aes(group = interaction(outcome, term), colour = factor(effect.pos)), alpha = 0.5, size = 4) +
    geom_text(data = df.results %>% filter(abs(effect) > 0.01) %>%
                  mutate(
                      pct.change = paste0(sprintf("%.0f", round(effect,2)*100),"%"),
                      pct.change.se = paste0("[",sprintf("%.0f", round(effect.se,2)*100),"%]")
                  ),
              aes(y = avg.effect,
                  x = 1.5,
                  label = ifelse(effect > 0,
                                 paste0("+", pct.change, "\n", pct.change.se),
                                 paste0(pct.change, "\n", pct.change.se)
                                 )
                  )) + 
    theme_bw() +
    geom_text_repel(data = df.results %>% filter(model == "ShownPref = 1"),
                    aes(label = gsub("ium", "", gsub("Tier", "", gsub("tier","",term)))),
                    nudge_x = 1
                    ) +        
    scale_colour_manual(values = c(brewer.neg, brewer.pos)) +
    theme(legend.position = "none",
          strip.text.y = element_text(angle = 0),
          axis.text.x = element_text(angle = 45, hjust = 1)) +
    xlab("Employer vertical preference revelation to workers") +
    ylab("Log outcome") +
    expand_limits(x = 3, y = 1) +
    geom_text(aes(label = paste0("n=\n",formatC(sample.size, big.mark = ",")), x = model, y = 1.15), size = 3)

JJHmisc::writeImage(g, "compare_wb_to_pr", path = "../writeup/plots/", width = 6, height = 5)

