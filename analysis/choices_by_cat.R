#!/usr/bin/env Rscript


suppressPackageStartupMessages(
    library(HotTowelR)
)

## df <- readRDS(system.file("extdata/choices_by_cat.rds",
##                           package = "HotTowelR"))    
df <- readRDS("../etl/transformed/choices_by_cat.rds")

extract.pct <- . %$%
    frac %>%
    mean %>%
    multiply_by(100) %>%
    round(0)

    
addParam <- JJHmisc::genParamAdder("../writeup/params_choices_by_cat.tex")

#addParam("\\fracHigh", df %>% filter(tier.label == "High") %>% extract.pct


pct.high.info.sys <- df %>%
    filter(level1.label == "Networking &\n Info. Sys.") %>%
    filter(tier.label == "High") %>% extract.pct 

addParam("\\fracHighNetworking", pct.high.info.sys)


pct.low.info.sys <- df %>%
    filter(level1.label == "Networking &\n Info. Sys.") %>%
    filter(tier.label == "Low") %>% extract.pct 

addParam("\\fracLowNetworking", pct.low.info.sys)


pct.high.admin.spt <- df %>%
    filter(level1.label == "Administrative Support") %>%
    filter(tier.label == "High") %>% extract.pct 

addParam("\\fracHighAdminSpt", pct.high.admin.spt)

pct.low.admin.spt <- df %>% filter(level1.label == "Administrative Support") %>%
    filter(tier.label == "Low") %>% extract.pct 

addParam("\\fracLowAdminSpt", pct.low.admin.spt)

pct.low.web <- df %>% filter(level1.label == "Web Development") %>%
    filter(tier.label == "Low") %>% extract.pct 

addParam("\\fracLowWeb", pct.low.web)


pretty.delta <- function(delta, delta.se, digits){
    negative.sign <- I(delta < 0)
    label <- paste0(ifelse(negative.sign, "-", " "),
                    formatC(abs(delta),
                            digits = digits,
                            format = "f"),
                    "\n",
                    ifelse(negative.sign," (", "("),
                    formatC(delta.se,
                            digits = digits,
                            format = "f"), ")")
    label
}

df.tests <- df %>%
    group_by(tier.label, level1.label) %>%
    summarise(
        height = max(frac), 
        delta = frac[contractor.shown == TRUE] - frac[contractor.shown == FALSE],
        delta.se = sqrt(se[contractor.shown == TRUE]^2 +
                        se[contractor.shown == FALSE]^2),
        t.stat = delta/delta.se,
        p.value = ifelse(t.stat > 0, 1 - pnorm(t.stat), pnorm(t.stat)),
        label =  pretty.delta(delta, delta.se, 3)
    ) %>%
    mutate(contractor.shown = TRUE)

df %<>% group_by(level1.label) %>%
    mutate(frac.high.tier = mean(frac[tier == "High Tier"]),
           total.N = sum(N))


df$level1.label <- with(df,
                        reorder(level1.label, frac.high.tier, mean))

g.choices.by.cat <- ggplot(df, aes(x = factor(tier.label),
                                   y = frac,
                                   fill = factor(contractor.shown))
                           ) +
    geom_bar(stat = "identity",
             colour = "black",
             position = position_dodge(.9)) +
    geom_errorbar(aes(ymin = frac - 2*se,
                      ymax = frac + 2*se),
                  position = position_dodge(0.9), width = 0.2) + 
    facet_wrap(~level1.label, ncol = 3) +
    scale_fill_manual("ShownPref",
                      labels = c("FALSE", "TRUE"),
                      values = c("white", "grey")) +
    theme_bw() +
    xlab("Vertical preference signal selected") + 
    scale_y_continuous(labels = percent) +
    expand_limits(y = 1.35) + 
    geom_text(data = df.tests,
              aes(x = factor(tier.label), y = 0.3 + height, label = label)) + 
    ylab("% of employers") +
    theme(legend.position = "top") +
    geom_text(data = df %>% filter(tier.label == "Medium" & contractor.shown == TRUE), aes(x = 2, y = 1.3, label = paste0("n=", formatC(total.N, big.mark = ","))))

JJHmisc::writeImage(g.choices.by.cat, "choices_by_cat", width = 6, height = 6, path = plots.path)
