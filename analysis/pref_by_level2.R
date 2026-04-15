#!/usr/bin/Rscript

library(HotTowelR)

MIN.OBS <- 200

df.openings <- HotTowelR::GetOpenings()

DT.by.cat <- df.openings[ (is.first.opening),
                         list(avg.tier = mean(contractor_tier),
                              se.tier = sd(contractor_tier)/sqrt(.N),
                              num.obs = .N), by=list(level1, level2)]

df <- DT.by.cat[num.obs > MIN.OBS]

df$level2 <- with(df, reorder(level2, avg.tier, mean))

g.avg.tier.pref.by.cat <- ggplot(data = df) +
    geom_point(aes(x = avg.tier,
                   y = level2)) +
    geom_errorbarh(aes(xmax = avg.tier + 2*se.tier,
                       xmin = avg.tier - 2*se.tier,
                       y = level2, x = avg.tier)) + 
    xlab("Average Tier (Low = 1, Medium = 2, High = 3)") + 
    facet_wrap(~level1, scales = "free", ncol = 1) +
    theme_bw() +
    ylab("") +
    scale_x_continuous(breaks = c(1,2,3)) +
    expand_limits(x = 1) +
    expand_limits(x = 3)

writeImage(g.avg.tier.pref.by.cat, "pref_by_level2", width = 8, height = 12, path = plots.path)
