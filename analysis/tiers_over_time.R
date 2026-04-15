#!/usr/bin/env Rscript

suppressPackageStartupMessages(
    library(HotTowelR)
)

df.raw <- readRDS("../etl/transformed/tiers_over_time.rds")

df.raw %<>% mutate(year = year(timestamp),
                   month = month(timestamp)
                   )

df.by.month <- df.raw %>% group_by(year, month) %>%
    summarise(
        num.openings = length(year),
        num.low = sum(tier == 1, na.rm = TRUE),
        num.med = sum(tier == 2, na.rm = TRUE),
        num.high = sum(tier == 3, na.rm = TRUE)
    ) %>%
    mutate(
        frac.pref = (num.low + num.med + num.high)/num.openings,
        ) %>%
    mutate(
        frac.med = num.med / (num.openings * frac.pref),
        frac.low = num.low / (num.openings * frac.pref),
        frac.high = num.high / (num.openings * frac.pref)
    ) %>%
    filter(frac.pref > 0.1)




g <- ggplot(data = df.by.month %>% filter(year > 2007),
            aes(x = month, y = num.openings)) +
    geom_line() + 
    facet_wrap(~year, ncol = 12)

g <- ggplot(data = df.by.month %>% filter(year > 2007),
            aes(x = month, y = frac.pref)) +
    geom_line() + 
    facet_wrap(~year, ncol = 12)

g <- ggplot(data = df.by.month %>% filter(year > 2007),
            aes(x = month, y = frac.pref)) +
    geom_line() + 
    facet_wrap(~year, ncol = 12)


df.melted <- df.by.month %>%
    select(frac.low, frac.med, frac.high, month, year) %>%
    as.data.frame %>% 
    melt(id.vars = c("month", "year")) %>%
    mutate(t = month/12 + year) %>%
    filter(t <= 2015) %>%
    mutate(pretty.variable = factor(variable,
                                    levels = c("frac.low", "frac.med", "frac.high"),
                                    labels = c("Low", "Med", "High"))) %>%
    mutate(t = lubridate::date_decimal(t))


exp.ended <- lubridate::date_decimal(11/12 + 2013)

g <- ggplot(data = df.melted,
            aes(x = t,
                y = value,
                linetype = variable,
                shape = variable)
            ) +
    geom_line(aes(group = variable)) +
    geom_point() + 
    theme_bw() +
    xlab("Month") +
    ylab("Fraction") +
    geom_vline(xintercept = exp.ended, 
               colour = "red",
               linetype = "dashed",
               alpha = 0.25) +
    geom_text_repel(data = df.melted %>%
                        filter(t == max(t)), 
                    aes(label = pretty.variable),
                    segment.color = "grey") +     
    scale_y_continuous(labels = percent) +
    expand_limits(x = lubridate::date_decimal(2015.1), y = 0) +
    theme(legend.position = "none") + 
    annotate("text",
             x = exp.ended,
             y = 0.1,
             label = "Experiment\nended",
             colour = "red") +
    ylab("Fraction\nof employers\nselecting a tier") +
    theme(axis.title.y = element_text(angle = 0))

JJHmisc::writeImage(g, "tiers_over_time", path = "../writeup/plots/", width = 5, height = 2)
