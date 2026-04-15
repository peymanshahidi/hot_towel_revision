#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

#df.openings <- HotTowelR::GetOpenings()
df.openings <- readRDS("../etl/transformed/openings.rds")

GetResults <- function(df.est, sample){
    m <- felm(log(num_applications) ~ contractor.shown * tier | 0 | 0 | 0,
              data = df.est)
    df.skel <- expand.grid(contractor.shown = c(TRUE, FALSE),
                           tier = unique(df.est$tier) %>% as.character)
    df.skel$tier <- with(df.skel,
                         factor(tier,
                                levels = c("Low Tier",
                                           "Medium Tier", "High Tier")))
    V <- vcov(m)
    X <- model.matrix(~contractor.shown * tier, data = df.skel)
    df.skel$y.hat <- as.numeric(X %*% coef(m))
    df.skel$se <- sqrt(as.numeric(unname(rowSums((X %*% V) * X))))

    m.pooled <- felm(log(num_applications) ~ contractor.shown | 0 | 0 | 0,
                     data = df.est)
    V <- vcov(m.pooled)
    df.skel.pooled <- expand.grid(contractor.shown = c(TRUE, FALSE),
                                  tier = "Pooled") %>% as.data.frame
    X <- model.matrix(~contractor.shown, data = df.skel.pooled)
    df.skel.pooled$y.hat <- as.numeric(X %*% coef(m.pooled))
    df.skel.pooled$se <- sqrt(as.numeric(unname(rowSums((X %*% V) * X))))
    df.skel <- rbind(df.skel, df.skel.pooled)
    df.skel$pretty.contractor.shown <- with(
        df.skel,
        ifelse(contractor.shown, "ShownPref=1",
               "ShownPref=0"))
    df.skel %<>% mutate(sample = sample)
    df.skel %<>% mutate(sample.size = nrow(model.frame(m.pooled)))
    df.skel
}

df.ambiguous <- subset(df.openings,
                       is.first.opening
                       & (G4 | G5 | G6)
                       & !bad
                       & visibility != "private")

df.explicit <- subset(df.openings, is.first.opening
                      & (G2 | G3)
                      & !bad
                      & visibility != "private")

df.ambig <- GetResults(df.ambiguous %>% filter(num_applications  > 0),
                       sample = "Ambiguous Arm")
df.explicit <- GetResults(df.explicit %>% filter(num_applications  > 0),
                       sample = "Explicit Arm")

df.skel <- rbind(df.explicit, df.ambig) %>%
    mutate(pooled = I(tier == "Pooled"))

pd <- position_dodge(0.2)
g <- ggplot(data = df.skel, aes(x = tier, y = y.hat,
                                group = interaction(contractor.shown, pooled),
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
    geom_dl(aes(label = pretty.contractor.shown),
            method = list(cex = 0.8, "first.points", dl.trans(x = x - 0.2))) +
    theme_bw() + 
    theme(legend.position = "none",
          axis.title.y = element_text(angle = 0),
          axis.text.x = element_text(angle = 30, hjust = 1
                                     #margin = ggplot2:::margins(t = 1),
                                     )
          ) +
    expand_limits(x = c(-2, 4)) +
    facet_wrap(~sample, ncol = 2) + 
    xlab("Employer vertical preferences") +
    ylab("Log\napplication\ncount") +
    geom_errorbar(data = . %>% filter(tier == "Pooled"),
                  aes(x = tier, ymin = y.hat - 2*se, ymax = y.hat + 2*se),
                  position = pd,
                  width = 0.1
                  ) +
    geom_text(data = df.skel %>% filter(tier == "Pooled"), aes(y = 3, label = paste0("n=\n", formatC(sample.size, big.mark = ","))), colour = "black", size = 3)
                                                                                                                      

JJHmisc::writeImage(g, "app_counts",
                    width = 6,
                    height = 3,
                    path = "../writeup/plots/")

