#' Application pool percentiles for a number of outcomes of interest
#'
#' Application pool percentiles for a number of outcomes of interest
#'
#' @param df.apps the applications data set 
#' @param outcome The name of the outcome of interest (e.g., hourly wage bid)
#' @param outcome.min lowest value for the outcome
#' @param outcom.max max value for the outcome
#' @param transform.func a function to transform the outcome measure (e.g., log)
#' @return a list of models
#' @export 

appPoolPercentiles <- function(df.apps, outcome, outcome.min, outcome.max, transform.func = function(x) x){

    df.q <- data.frame(q = c(0.25, 0.50, 0.75, 0.90)) %>%
        mutate(dummy.col = 1)

    df.apps %<>%
        filter(outcome > outcome.min) %>%
        filter(outcome < outcome.max) %>%
        filter(ambigious.arm == TRUE) %>%
        filter(is.first.opening == TRUE) %>%
        select(outcome, economic_opening, cs, tier, ambigious.arm,
               is.first.opening, level1, level2) %>%
        mutate(dummy.col = 1) 
    
    df.combo <- df.apps %>% left_join(df.q, by = "dummy.col") %>%
        group_by(economic_opening, tier, cs, level1, level2, q) %>%
        summarise(mu = mean(outcome),
                  sigma = sd(outcome),
                  pct = quantile(outcome, q[1])
                  )

    m.25 <- lm(pct ~ cs * tier , df.combo %>% filter(q == 0.25))
    m.50 <- lm(pct ~ cs * tier , df.combo %>% filter(q == 0.50))
    m.75 <- lm(pct ~ cs * tier , df.combo %>% filter(q == 0.75))
    m.90 <- lm(pct ~ cs * tier , df.combo %>% filter(q == 0.90))
    m.50.re <- lme4::lmer(pct ~ cs * tier + (1|level2), data = df.combo %>%
                          filter(q == 0.50))
    list("25" = m.25, "50" = m.50, "75" =  m.75, "90" = m.90, "re" = m.50.re)
}
