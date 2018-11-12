context("Geom functions")

test_that("geom_timeline", {
  ggplt <- data.frame(
    DATE = as.Date(c("2010-01-01", "2012-01-01", "2014-01-01")),
    COUNTRY = c("BRAZIL", "BRAZIL", "BRAZIL"),
    EQ_PRIMARY = c(3, 4, 5),
    TOTAL_DEATHS = c(5, 10, 20)
  ) %>%
    ggplot(ggplot2::aes(x = DATE,
                        size = as.numeric(EQ_PRIMARY),
                        color = as.numeric(TOTAL_DEATHS))) +
    geom_timeline() +
    theme_classic() +
    labs(size = "Richter scale value", color = "# deaths") +
    theme(axis.line.y = ggplot2::element_blank(),
          axis.ticks.y = ggplot2::element_blank(),
          axis.title.y = ggplot2::element_blank(),
          legend.position = "bottom") +
    ggplot2::guides(size = ggplot2::guide_legend(order = 1))
  expect_is(ggplt, "ggplot")
  expect_identical(ggplt$data$EQ_PRIMARY, c(3, 4, 5))
})

test_that("geom_timeline_label", {
  ggplt <- data.frame(
    DATE = as.Date(c("2010-01-01", "2012-01-01", "2014-01-01")),
    COUNTRY = c("BRAZIL", "BRAZIL", "BRAZIL"),
    EQ_PRIMARY = c(3, 4, 5),
    TOTAL_DEATHS = c(5, 10, 20),
    LOCATION_NAME = c("São Paulo", "Rio de Janeiro", "Campinas")
  ) %>%
    ggplot(ggplot2::aes(x = DATE,
                        size = as.numeric(EQ_PRIMARY),
                        color = as.numeric(TOTAL_DEATHS),
                        label = LOCATION_NAME)) +
    geom_timeline() +
    geom_timeline_label(n_max = 5) +
    theme_classic() +
    labs(size = "Richter scale value", color = "# deaths") +
    theme(axis.line.y = ggplot2::element_blank(),
          axis.ticks.y = ggplot2::element_blank(),
          axis.title.y = ggplot2::element_blank(),
          legend.position = "bottom") +
    ggplot2::guides(size = ggplot2::guide_legend(order = 1))
  expect_is(ggplt, "ggplot")
  expect_identical(ggplt$data$LOCATION_NAME,
                   factor(c("São Paulo", "Rio de Janeiro", "Campinas")))
})
