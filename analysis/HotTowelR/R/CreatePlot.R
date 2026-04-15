#' Creates a plot showing changes in outcomes by tier
#'
#' Creates a plot showing changes in outcomes by tier
#'
#' @param models
#' @param ylab
#' @return ggplot2 graphics
#' @export 

CreatePlot <- function(models, ylab){
    df.apps.fx <- expand.grid(cs = c(TRUE, FALSE),
                          tier = c("Low Tier", "Medium Tier", "High Tier")
                              )
    df.apps.fx.25 <- df.apps.fx
    df.apps.fx.25$pct <- 25
    df.apps.fx.25$y <- predict(models$`25`, newdata = df.apps.fx.25)
    df.apps.fx.25$se <- predict(models$`25`, newdata = df.apps.fx.25, se.fit = TRUE)$se.fit
    df.apps.fx.50 <- df.apps.fx
    df.apps.fx.50$pct <- 50
    df.apps.fx.50$y <- predict(models$`50`, newdata = df.apps.fx.50)
    df.apps.fx.50$se <- predict(models$`50`, newdata = df.apps.fx.50, se.fit = TRUE)$se.fit
    df.apps.fx.90 <- df.apps.fx
    df.apps.fx.90$pct <- 90
    df.apps.fx.90$y <- predict(models$`90`, newdata = df.apps.fx.90)
    df.apps.fx.90$se <- predict(models$`90`, newdata = df.apps.fx.90, se.fit = TRUE)$se.fit
    df.apps.fx.combined <- rbind(df.apps.fx.25, df.apps.fx.50, df.apps.fx.90) 
    df.apps.fx.combined$Percentile <- with(df.apps.fx.combined, factor(pct))

    df.delta <- data.table(df.apps.fx.combined)[, list(pct.change = y[cs == TRUE] - y[cs== FALSE],
                                                       pct.change.se = sqrt(se[cs == TRUE]^2 + se[cs == FALSE]^2),
                                                   mid.point = mean(y),
                                                   pos = y[cs == TRUE] > y[cs == FALSE]),
                                            by = list(tier, pct)]
    
    g <- ggplot(data = df.apps.fx.combined,
                aes(x = cs, y = y)) +
                    geom_line(aes(group = Percentile), colour = "grey") +
                        geom_point(aes(x = cs, y = y)) + 
                            geom_errorbar(aes(ymin = y - 2*se, ymax = y + 2*se), width = 0.01) + 
                                facet_wrap(~tier, ncol = 3) +
                                    xlab("Workers shown buyer price/quality preference?") +
                                            ylab(ylab) +
                                                geom_text(data = df.delta,
                                                          aes(x = 1.5,
                                                              y = mid.point,
                                        #label = paste0(round(pct.change * 100, 2), "%", "(", round(100*pct.change.se, 2), ")"),
                                                              label = paste0(round(pct.change * 100, 2), "%"),
                                                              colour = factor(pos)
                                                              )
                                                          ) +
                                                              geom_text(data = subset(df.apps.fx.combined, cs == TRUE),
                                                                        aes(x = 2,
                                                                            y = y,
                                                                            label = paste0(" ", Percentile, "th"),
                                                                            hjust = -0.1), size = 3) + 
                                                              scale_colour_manual(values =
                                                                                      c("TRUE" = "#228b22",
                                                                                        "FALSE" = "red")) +
                                                                                             theme(legend.position = "none",
                                                                                                    panel.background =  element_rect(fill = "white", colour = NA), 
                                                                                                    panel.border =      element_rect(fill = NA, colour="grey50"), 
                                                                                                    panel.grid.major =  element_line(colour = "grey90", size = 0.2),
                                                                                                    panel.grid.minor =  element_line(colour = "grey98", size = 0.5)
                                                                                                    )
    g
}
