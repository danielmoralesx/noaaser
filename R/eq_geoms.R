GeomTimeline <- ggplot2::ggproto(
  "GeomTimeline",
  Geom,
  required_aes = c("x"),
  default_aes = ggplot2::aes(size = 4,
                             color = "grey",
                             fill = "grey",
                             alpha = 0.6,
                             shape = 19,
                             stroke = 0),
  draw_key = ggplot2::draw_key_point,
  draw_panel = function(data, panel_scales, coord) {
    if (!("y" %in% colnames(data))) data$y <- 0.2
    coords <- coord$transform(data, panel_scales)

    pnts <- grid::pointsGrob(
      x = coords$x,
      y = coords$y,
      size = grid::unit(coords$size / 3, "char"),
      pch = coords$shape,
      gp = grid::gpar(alpha = coords$alpha,
                      col = coords$colour,
                      fill = coords$fill)
    )

    unique_y <- unique(coords$y)
    lns <- grid::polylineGrob(
      x = grid::unit(rep(c(0.02, 0.98), each = length(unique_y)), "npc"),
      y = grid::unit(c(unique_y, unique_y), "npc"),
      id = rep(seq_along(unique_y), 2),
      gp = grid::gpar(alpha = coords$alpha,
                      col = "grey")
    )

    grid::gList(pnts, lns)
  }
)

#' @title Earthquake timeline plots
#'
#' @description Timeline ggplot2 geom for NOAA significant earthquakes database.
#'
#' @inheritParams ggplot2::geom_point
#'
#' @import ggplot2
#' @import grid
#'
#' @section Aesthetics:
#' \code{geom_timeline} understands the following aesthetics (required
#' aesthetics are in bold):
#' \itemize{
#'   \item \strong{x}
#'   \item y
#'   \item alpha
#'   \item colour
#'   \item fill
#'   \item shape
#'   \item size
#'   \item stroke
#' }
#'
#' @examples
#' \dontrun{
#' noaase_raw <- readr::read_delim("inst/extdata/earthquakes.tsv.gz", "\t")
#' noaase_raw %>%
#'   eq_clean_data() %>%
#'   filter(YEAR >= 2000, COUNTRY == "USA") %>%
#'   ggplot(ggplot2::aes(x = DATE,
#'                       size = as.numeric(EQ_PRIMARY),
#'                       color = as.numeric(TOTAL_DEATHS))) +
#'   geom_timeline() +
#'   theme_classic() +
#'   labs(size = "Richter scale value", color = "# deaths") +
#'   theme(axis.line.y = ggplot2::element_blank(),
#'         axis.ticks.y = ggplot2::element_blank(),
#'         axis.title.y = ggplot2::element_blank(),
#'         legend.position = "bottom") +
#'   ggplot2::guides(size = ggplot2::guide_legend(order = 1))
#' }
#'
#' @export
geom_timeline <- function(mapping = NULL, data = NULL, stat = "identity",
                           position = "identity", na.rm = FALSE,
                           show.legend = NA, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = GeomTimeline, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

GeomTimelineLabel <- ggplot2::ggproto(
  "GeomTimelineLabel",
  Geom,
  required_aes = c("x", "label"),
  default_aes = ggplot2::aes(alpha = 0.6),
  draw_key = ggplot2::draw_key_blank,
  setup_data = function(data, params) {
    if (!is.null(params$n_max)) {
      if (!("size" %in% colnames(data))) {
        stop("Using 'n_max' requires 'size' aesthetics.")
      }
      data <- data %>%
        dplyr::group_by_("group") %>%
        dplyr::top_n(params$n_max, size) %>%
        dplyr::ungroup()
    }
    data
  },
  draw_panel = function(data, panel_scales, coord, n_max) {
    if (!("y" %in% colnames(data))) data$y <- 0.2

    coords <- coord$transform(data, panel_scales)
    lbl_height <- 0.15 / length(unique(data$group))

    lns <- grid::polylineGrob(
      x = grid::unit(c(coords$x, coords$x), "npc"),
      y = grid::unit(c(coords$y, coords$y + lbl_height), "npc"),
      id = rep(seq_along(coords$y), 2),
      gp = grid::gpar(alpha = coords$alpha,
                      col = "grey")
    )

    lbls <- grid::textGrob(
      label = paste0(" ", coords$label),
      x = grid::unit(coords$x, "npc"),
      y = grid::unit(coords$y + lbl_height, "npc"),
      just = "left",
      rot = 45
    )

    grid::gList(lns, lbls)
  }
)

#' @title Labels for earthquake timeline plots
#'
#' @description Provide labels for \code{geom_timeline}.
#'
#' @import dplyr
#' @import ggplot2
#' @import grid
#'
#' @inheritParams ggplot2::geom_text
#' @param n_max Integer that if provided, only displays labels for the top
#' \code{n_max} Richter scale value earthquakes per country.
#'
#' @section Aesthetics:
#' \code{geom_timeline} understands the following aesthetics (required
#' aesthetics are in bold):
#' \itemize{
#'   \item \strong{x}
#'   \item \strong{label}
#'   \item y
#'   \item alpha
#' }
#'
#' @examples
#' \dontrun{
#'   noaase_raw <- readr::read_delim("inst/extdata/earthquakes.tsv.gz", "\t")
#'   noaase_raw %>%
#'     eq_clean_data() %>%
#'     eq_location_clean() %>%
#'     filter(YEAR >= 2000, COUNTRY %in% c("USA", "CHINA")) %>%
#'     ggplot(ggplot2::aes(x = DATE,
#'                         y = COUNTRY,
#'                         size = as.numeric(EQ_PRIMARY),
#'                         color = as.numeric(TOTAL_DEATHS),
#'                         label = LOCATION_NAME)) +
#'     geom_timeline() +
#'     geom_timeline_label(n_max = 5) +
#'     theme_classic() +
#'     labs(size = "Richter scale value", color = "# deaths") +
#'     theme(axis.line.y = ggplot2::element_blank(),
#'           axis.ticks.y = ggplot2::element_blank(),
#'           axis.title.y = ggplot2::element_blank(),
#'           legend.position = "bottom") +
#'     ggplot2::guides(size = ggplot2::guide_legend(order = 1))
#' }
#'
#' @export
geom_timeline_label <- function(mapping = NULL, data = NULL, stat = "identity",
                                position = "identity", na.rm = FALSE,
                                show.legend = NA, inherit.aes = TRUE,
                                n_max = NULL, ...) {
  ggplot2::layer(
    geom = GeomTimelineLabel, mapping = mapping, data = data, stat = stat,
    position = position, show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(n_max = n_max, na.rm = na.rm, ...)
  )
}
