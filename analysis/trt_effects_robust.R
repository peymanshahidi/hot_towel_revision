#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

df.combo <- readRDS("../computed_objects/trt_effects_robust.rds") %>%
    mutate(tier = factor(tier, levels = c("Pooled", "Low Tier", "Medium Tier", "High Tier"))) %>%
    mutate(tier.estimate = !(tier == "Pooled")) %>%
    filter(outcome != "Any interviews?") 
        
dodge.amount <- 0.5

format.effect <- . %>%
    multiply_by(100) %>%
    round(1)

df.combo$sample.size <- with(df.combo, ifelse(tier == "Pooled", paste0("n=", formatC(n,big.mark = ","), ";g=", formatC(num.groups, big.mark =",")),
                                              paste0("n=", formatC(n,big.mark = ","))))


df.combo$Sample <- with(df.combo, factor(sample))

pd <- position_dodge(0.5)
g <- ggplot(data = df.combo, aes(x = tier, y = delta, shape = Sample, colour = Sample)) +
    geom_point(position = pd) + 
    facet_wrap(~outcome, ncol = 3, scale = "free_y")  +
    geom_path(aes(group = interaction(tier.estimate, sample)), position = pd) + 
    geom_errorbar(aes(ymin = delta - 2*delta.se,
                      ymax = delta + 2*delta.se),
                   width = 0, height = 0, position = pd) +
    theme_bw() +
    geom_hline(yintercept = 0, colour = "red", linetype = "dashed") +
    ylab("Effect of preference revelation (ShownPref = 1)") + xlab("") +
    theme(legend.position = "top",
          axis.text.x = element_text(angle = 30, hjust = 1))     

JJHmisc::writeImage(g, "trt_effects_robust", path = "../writeup/plots/", width = 8, height = 8)

