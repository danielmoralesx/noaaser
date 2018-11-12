#' @title Epicenter map with annotation
#'
#' @description Maps earthquakes epicenters and annotates each point with pop-up
#' window.
#'
#' @param data Filtered data frame with earthquakes to visualize.
#' @param annot_col Choose which column is used for the annotation in the
#' pop-up.
#'
#' @return Leaflet map with earthquakes epicenters marked and the contents in
#' \code{annot_col} as annotation in pop-up window.
#'
#' @import dplyr
#' @import leaflet
#' @importFrom stats as.formula
#'
#' @examples
#' \dontrun{
#'   noaase_raw <- readr::read_delim("inst/extdata/earthquakes.tsv.gz", "\t")
#'   noaase_raw %>%
#'     eq_clean_data() %>%
#'     dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#'     eq_map(annot_col = "DATE")
#' }
#'
#' @export
eq_map <- function(data, annot_col = "DATE") {
  leaflet::leaflet() %>%
    leaflet::addTiles() %>%
    leaflet::addCircleMarkers(data = data,
                              radius = ~ as.numeric(EQ_PRIMARY),
                              lng = ~ LONGITUDE,
                              lat = ~ LATITUDE,
                              popup = as.formula(paste("~", annot_col)))
}

#' @title HTML annotation for epicenter map
#'
#' @description Creates an HTML label that can be used as the annotation text in
#' the leaflet earthquakes epicenters map from \code{eq_map}.
#'
#' @param data Filtered data frame with earthquakes to visualize.
#'
#' @return Character string for each earthquake, containing location (as cleaned
#' by \code{eq_location_clean}), magnitude and total number of deaths.
#'
#' @import dplyr
#'
#' @examples
#' \dontrun{
#'  noaase_raw <- readr::read_delim("inst/extdata/earthquakes.tsv.gz", "\t")
#'  noaase_raw %>%
#'    eq_clean_data() %>%
#'    dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#'    dplyr::mutate(popup_text = eq_create_label(.)) %>%
#'    eq_map(annot_col = "popup_text")
#' }
#'
#'@export
eq_create_label <- function(data) {
  data <- eq_location_clean(data)
  paste(
    "<b>Location:</b>", data$LOCATION_NAME, "<br />",
    "<b>Magnitude:</b>", data$EQ_PRIMARY, "<br />",
    "<b>Total deaths:</b>", data$TOTAL_DEATHS, "<br />"
  )
}
