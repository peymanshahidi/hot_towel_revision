#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

df.combo <- readRDS("../computed_objects/trt_effects.rds") %>%
    mutate(tier = factor(tier, levels = c("Pooled", "Low Tier", "Medium Tier", "High Tier"))) %>%
    mutate(tier.estimate = !(tier == "Pooled")) %>%
    filter(
        !(outcome %in%
          c("Feedback to worker",
            "Feedback to employer",
            "Recommend platform score")
        )) %>%
    filter(outcome != "Any interviews?") 
        
dodge.amount <- 0.5


addParam <- JJHmisc::genParamAdder("../writeup/params_trt_effects.tex")

format.effect <- . %>%
    multiply_by(100) %>%
    round(1)


addParam("\\TotalSampleSize",
         df.combo %>% filter(outcome == "Any hires?") %>%
         filter(tier == "Pooled") %$% n %>%
         formatC(big.mar = ",")
         )

addParam("\\TotalFilledSampleSize",
         df.combo %>% filter(outcome == "Log wage of hired worker") %>%
         filter(tier == "Pooled") %$% n %>%
         formatC(big.mar = ",")
         )

addParam("\\NumAppsEffectHigh",
         df.combo %>% filter(outcome == "Log num. applications") %>%
         filter(tier == "High Tier") %$% delta %>%
         format.effect
         )

addParam("\\NumAppsEffectLow",
         df.combo %>% filter(outcome == "Log num. applications") %>%
         filter(tier == "Low Tier") %$% delta %>%
         format.effect
         )


addParam("\\WageEffectLow",
         df.combo %>% filter(outcome == "Log wage of hired worker") %>%
         filter(tier == "Low Tier") %$% delta %>%
         format.effect
         )


addParam("\\WageEffectHigh",
         df.combo %>% filter(outcome == "Log wage of hired worker") %>%
         filter(tier == "High Tier") %$% delta %>%
         format.effect
         )

addParam("\\HoursEffectLow",
         df.combo %>% filter(outcome == "Log hours-worked") %>%
         filter(tier == "Low Tier") %$% delta %>%
         format.effect
         )


addParam("\\HoursEffectHigh",
         df.combo %>% filter(outcome == "Log hours-worked") %>%
         filter(tier == "High Tier") %$% delta %>%
         format.effect
         )

addParam("\\HoursEffectPool",
         df.combo %>% filter(outcome == "Log hours-worked") %>%
         filter(tier == "Pooled") %$% delta %>%
         format.effect
         )

addParam("\\WageBillEffectPool",
         df.combo %>% filter(outcome == "Log total wage bill") %>%
         filter(tier == "Pooled") %$% delta %>%
         format.effect
         )



pct.change <- . %>% (function (x) x[["delta"]]/x[["mu"]]) %>% multiply_by(100) %>% round(1)

    
addParam("\\LowPctHireChange",
         df.combo %>% filter(outcome == "Any hires?") %>%
         filter(tier == "Low Tier") %>% pct.change
         )

df.combo$sample.size <- with(df.combo, ifelse(tier == "Pooled", paste0("n=", formatC(n,big.mark = ","), ";g=", formatC(num.groups, big.mark =",")),
                                              paste0("n=", formatC(n,big.mark = ","))))


g <- ggplot(data = df.combo, aes(x = delta, y = tier)) +
    geom_point(aes(size = n)) +
    geom_path(aes(group = tier.estimate), colour = "grey") + 
    geom_errorbarh(aes(xmin = delta - 2*delta.se,
                       xmax = delta + 2*delta.se),
                   width = 0, height = 0) +
    theme_bw() +
    facet_wrap(~outcome, ncol = 1) + 
    geom_vline(xintercept = 0, colour = "red", linetype = "dashed") +
    xlab("Effect of preference revelation (ShownPref = 1)") + ylab("") +
    theme(legend.position = "none") +
    geom_vline(data = df.combo %>% filter(tier == "Pooled"),
               aes(xintercept = delta), colour = "blue", linetype = "dotted") +
    geom_rect(data = df.combo %>% filter(tier == "Pooled"),
              aes(ymin = -Inf, ymax = Inf, xmin = delta - 1.96*delta.se, xmax = delta + 1.96*delta.se), fill = "blue",  alpha = 0.2) +
    geom_text(aes(x = 0.125, y = tier, label = sample.size), size = 2) +
    expand_limits(x = 0.15)
    

JJHmisc::writeImage(g, "trt_effects", path = "../writeup/plots/", width = 5, height = 5)

