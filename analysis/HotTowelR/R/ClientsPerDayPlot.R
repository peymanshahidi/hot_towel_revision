#' Plot of clients allocated per day
#'
#' Plot of clients allocated per day
#'
#' @return ggplot2 object
#' @export

ClientsPerDayPlot <- function() {
    df.by.day <- readRDS(system.file("extdata/qt_by_day.rds", package = "HotTowelR"))
    g.alloc <- ggplot(data = df.by.day,
                  aes(x = as.Date(day),
                      y = num.obs,
                      colour =
                      factor(test_cell_id))) +
    geom_point() +
    geom_line(aes(group = test_cell_id)) +
    theme_bw() +
    xlab("Day") +
    ylab("Number of employers allocated") +
    scale_y_continuous(labels = scales::comma)
}
