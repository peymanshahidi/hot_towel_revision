#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

variable.mapping <- list(
    "lhr_charge_rate" = "Log wage bid",
    "lhourly_rate_snap" = "Log profile rate",
    "pct.markup" = "Markup", 
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

df.delta %<>% filter(pretty.variable %in% as.character(variable.mapping)[1:3])

addParam <- JJHmisc::genParamAdder("../writeup/params_signal_effects_wage_bidding.tex")

extract.effect <- .  %$% delta %>% mean %>%
                         multiply_by(100) %>% round(1)

addParam("\\WageBidEffectHighTier",
         df.delta %>%
         filter(tier == "High Tier") %>% 
         filter(variable == "lhr_charge_rate") %>%
         extract.effect 
         )

addParam("\\WageBidEffectMedTier",
         df.delta %>%
         filter(tier == "Medium Tier") %>% 
         filter(variable == "lhr_charge_rate") %>%
         extract.effect 
         )

addParam("\\WageBidEffectLowTier",
         df.delta %>%
         filter(tier == "Low Tier") %>% 
         filter(variable == "lhr_charge_rate") %>%
         extract.effect 
         )

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
    facet_wrap(~pretty.variable, ncol = 1) +
    theme_bw() +
    geom_text_repel(data = df.delta %>%
                        filter(q == max(q)),
                    aes(label = gsub("ium", "", gsub("Tier", "", tier))),
                    nudge_x = 0.25,
                    segment.color = "grey") +        
    scale_shape(name = "Tier") +
    expand_limits(x = 1.07) + 
    xlab("Quantile of the application pool") +
    ylab("Difference in log outcomes quantile \n from vertical preference being shown") +
    theme(legend.position = "none") +
    scale_x_continuous(breaks = seq(0.05, 0.95, 0.1))

writeImage(g, "signal_effects_wage_bidding", path = "../writeup/plots/", width = 5, height = 4)

