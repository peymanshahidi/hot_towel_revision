#' Hot Towel tier, choices by category 
#'
#' Hot Towel tier, choices by category 
#'
#' @return ggplot2 object
#' @export

ChoicesByCat <- function() {
    DT.prop.by.cat <- readRDS(system.file("extdata/choices_by_cat.rds", package = "HotTowelR"))    
    g.choices.by.cat <- ggplot(DT.prop.by.cat, aes(x = factor(tier.label), y = frac, fill = factor(contractor.shown))) +
    geom_bar(stat = "identity", colour = "black",  position = position_dodge(.9)) +
        geom_errorbar(aes(ymin = frac - 2*se, ymax = frac + 2*se), position = position_dodge(0.9), width = 0.2) + 
        facet_wrap(~level1.label, ncol = 3) +
            scale_fill_manual("ShownPref", labels = c("FALSE", "TRUE"), values = c("white", "grey")) +
                theme_bw() +
                    xlab("Price/Qualtity Tier Selection") + 
                        scale_y_continuous(labels = percent) + 
        ylab("Fraction of employers selecting this tier")
    g.choices.by.cat
}
