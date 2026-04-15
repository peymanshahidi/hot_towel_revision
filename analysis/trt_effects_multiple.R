#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)

df.combo.1 <- readRDS("../computed_objects/trt_effects.rds") %>%
    mutate(tier = factor(tier, levels = c("Pooled", "Low Tier", "Medium Tier", "High Tier"))) %>%
    mutate(tier.estimate = !(tier == "Pooled")) %>%
    filter(
        !(outcome %in%
          c("Feedback to worker",
            "Feedback to employer",
            "Recommend platform score")
        )) %>%
    filter(outcome != "Any interviews?") %>%
    mutate(sample = "All")

df.combo.2 <- readRDS("../computed_objects/trt_effects_ambiguous.rds") %>%
    mutate(tier = factor(tier, levels = c("Pooled", "Low Tier", "Medium Tier", "High Tier"))) %>%
    mutate(tier.estimate = !(tier == "Pooled")) %>%
    filter(
        !(outcome %in%
          c("Feedback to worker",
            "Feedback to employer",
            "Recommend platform score")
        )) %>%
    filter(outcome != "Any interviews?") %>%
    mutate(sample = "Ambig")


df.combo <- rbind(df.combo.1, df.combo.2)

dodge.amount <- 0.5


g <- ggplot(data = df.combo, aes(x = delta, y = tier, colour = sample)) +
    geom_point() +
    geom_path(aes(group = tier.estimate), colour = "grey") + 
    geom_errorbarh(aes(xmin = delta - 2*delta.se, xmax = delta + 2*delta.se),
                   width = 0, height = 0) +
    theme_bw() +
    facet_wrap(~outcome, ncol = 1) + 
    geom_vline(xintercept = 0, colour = "red", linetype = "dashed") +
    xlab("Treatment effect") + ylab("") +
    theme(legend.position = "none") 
    

writeImage(g, "trt_effects", path = "../writeup/plots/", width = 5, height = 6)

