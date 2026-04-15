#!/usr/bin/Rscript

library(HotTowelR)
library(magrittr)
library(dplyr)
#library(ggrepel)
library(directlabels)

variable.mapping <- list(
    "lhr_charge_rate" = "Log wage bid",
    "lhourly_rate_snap" = "Log profile rate",
    "lprior_hours" = "Log experience (hours)",
    "lprior_earnings" = "Log experience (earnings)"
    )

df.delta <- readRDS("../computed_objects/signal_effects.rds")

df.delta$pretty.variable <- as.character(with(df.delta,
                                              variable.mapping[as.character(variable)]))

labels.in.order <- as.character(unlist(variable.mapping[names(variable.mapping)]))

df.delta$pretty.variable <- with(df.delta, factor(pretty.variable,
                                                  levels = labels.in.order))

df.delta$small.tier <- with(df.delta, substr(tier,1,1))
                            
dodge.amount <- 0.05
g <- ggplot(data = df.delta, aes(x = q, y = delta, shape = factor(tier))) +
    geom_hline(yintercept = 0, colour = "red", linetype = "dashed", alpha = 0.5) + 
    geom_line(aes(group = tier, linetype = tier),position = position_dodge(dodge.amount)) +
    geom_point(position = position_dodge(dodge.amount)) +
    geom_errorbar(aes(
        ymin = delta - 2*se.delta,
        ymax = delta + 2*se.delta),
        width = 0,
        position = position_dodge(dodge.amount),
        alpha = 0.25) + 
                                        #    facet_wrap(~pretty.variable, ncol = 1, scale = "free_y") +
    facet_wrap(~pretty.variable, ncol = 1) +
    theme_bw() +
    geom_dl(aes(label=tier),
            method = list("last.points",
                          cex = 0.75,
                          hjust = -.25)
            )+
    scale_shape(name = "Tier") +
    expand_limits(x = 1.20) + 
    xlab("Quantile of the application pool") +
    ylab("Difference in log outcomes quantile \n from vertical preference being shown") +
    theme(legend.position = "none")

writeImage(g, "signal_effects", path = "../writeup/plots/", width = 5, height = 7)

