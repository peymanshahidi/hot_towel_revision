#!/usr/bin/Rscript

library(HotTowelR)

df.openings <- HotTowelR::GetOpenings() %>%
    mutate(
        frac.viewed = num_viewed / num_applications
    )

file.name.no.ext <- "app_counts"
out.file <- paste0("../writeup/tables/", file.name.no.ext, ".tex")

df.explicit <- subset(df.openings, is.first.opening
                      & (G2 | G3)
                      & !bad
                      & visibility != "private"
                      & num_applications > 0)

df.ambiguous <- subset(df.openings,
                       is.first.opening
                       & (G4 | G5 | G6)
                       & !bad
                       & visibility != "private"
                       & num_applications > 0)

summary(df.explicit$num_applications)

library(magrittr)
library(dplyr)

m <- lm(frac.viewed  ~ contractor.shown * tier,
        data = df.ambiguous %>% filter(num_applications < 100))


m.1 <- felm(log1p(num_applications) ~ contractor.shown * tier | level2 + I(prior_spend > 0) + engagement_duration_label| 0 | 0,
        data = df.explicit)
stargazer(m.1, type = "text")



m.2 <- felm(log1p(num_applications) ~ contractor.shown * tier | level2 + job_desc_length| 0 | 0,
        data = df.explicit %>% filter(num_viewed < 10))

m.1 <- felm(log1p(num_applications) ~ contractor.shown * tier | 0 | 0 | 0,
        data = df.ambiguous %>% filter(num_viewed < 10))
m.2 <- felm(log1p(num_applications) ~ contractor.shown * tier | level2 + job_desc_length| 0 | 0,
        data = df.ambiguous %>% filter(num_viewed < 10))

stargazer(m.1, m.2, type = "text")

summary(m)

m <- lm(log(num_applications) ~ contractor.shown * tier, data = df.explicit)

m.apps.ambig.1 <- lm(log(num_applications) ~ contractor.shown,
                     data = df.ambiguous)
m.apps.ambig.3 <- lm(log(num_applications) ~ contractor.shown * tier,
                     data = df.ambiguous)

