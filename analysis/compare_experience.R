#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

df.results.1 <- readRDS("../computed_objects/compare_experience.rds")


extract.effect <- .  %>% multiply_by(100) %>% round(1)

addParam <- JJHmisc::genParamAdder("../writeup/params_reg_experience.tex")

addParam("\\EffectEarningsExperienceHighTierRegression",
         df.results.1 %>% filter(term == "tierHigh Tier") %>% filter(outcome == "Outcome:\nApplicant\nprior earnings") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )
addParam("\\EffectEarningsExperienceMedTierRegression",
         df.results.1 %>% filter(term == "tierMedium Tier") %>% filter(outcome == "Outcome:\nApplicant\nprior earnings") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )
addParam("\\EffectEarningsExperienceLowTierRegression",
         df.results.1 %>% filter(term == "tierLow Tier") %>% filter(outcome == "Outcome:\nApplicant\nprior earnings") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )


df.results.2 <- readRDS("../computed_objects/compare_experience_hired.rds")


addParam("\\EffectEarningsExperienceLowTierHiredRegression",
         df.results.2 %>% filter(term == "tierLow Tier") %>% filter(outcome == "Outcome:\nHired worker\nprior earnings") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )

addParam("\\EffectEarningsExperienceHighTierHiredRegression",
         df.results.2 %>% filter(term == "tierHigh Tier") %>% filter(outcome == "Outcome:\nHired worker\nprior earnings") %>%
         filter(model == "ShownPref = 1") %$% 
         effect %>% extract.effect 
         )

df.results <- rbind(df.results.1, df.results.2) %>% ungroup %>%
    mutate(outcome = factor(outcome,
                            levels =   c(
                                "Outcome:\nApplicant\nprior earnings",
                                "Outcome:\nHired worker\nprior earnings",
                                "Outcome:\nApplicant\nprior hours", 
                                "Outcome:\nHired worker\nprior hours")
                            )
           ) %>%
    filter(outcome %in%
           c("Outcome:\nApplicant\nprior earnings",
             "Outcome:\nHired worker\nprior earnings")
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
                  ), size = 4) + 
    theme_bw() +
    geom_text_repel(data = df.results %>% filter(model == "ShownPref = 1"),
                    aes(label = gsub("ium", "", gsub("Tier", "", gsub("tier","",term)))),
                    nudge_x = 1, segment.colour = "grey"
                    ) +        
    scale_colour_manual(values = c(brewer.neg, brewer.pos)) +
    theme(legend.position = "none",
          strip.text.y = element_text(angle = 0),
          axis.text.x = element_text(angle = 45, hjust = 1)) +
    xlab("Employer vertical preference revelation to workers") +
    ylab("Log outcome") +
    expand_limits(x = 3)

#+
#    geom_text(aes(label = paste0("n=",formatC(sample.size, big.mark = ",")), x = model, y = 6.5), size = 3)

JJHmisc::writeImage(g, "compare_experience", path = "../writeup/plots/", width = 5, height = 4.5)

