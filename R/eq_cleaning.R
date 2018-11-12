#' @title Cleans raw NOAA data frame
#'
#' @description Takes raw NOAA data frame and returns a clean data frame, with a
#' date column created by uniting the year, month, day and converting it to the
#' Date class and converts LATITUDE and LONGITUDE columns to numeric class.
#'
#' @param noaase_raw Raw NOAA data frame read with a function like
#' \code{readr::read_delim}.
#'
#' @return Clean NOAA data frame, with a date column created by uniting the
#' year, month, day and converting it to the Date class and LATITUDE and
#' LONGITUDE columns converted to numeric class.
#'
#' @import dplyr
#'
#' @examples
#' \dontrun{
#'   noaase_raw <- readr::read_delim("inst/extdata/earthquakes.tsv.gz", "\t")
#'   noaase_clean <- eq_clean_data(noaase_raw)
#' }
#'
#' @export
eq_clean_data <- function(noaase_raw) {
  noaase_raw %>%
    dplyr::mutate(
      DATE = as.Date(paste0(.data$DAY, "/", .data$MONTH, "/", .data$YEAR),
                     format = "%d/%m/%Y"),
      LATITUDE = as.numeric(as.character(.data$LATITUDE)),
      LONGITUDE = as.numeric(as.character(.data$LONGITUDE))
    )
}

#' @title Cleans location name column from raw NOAA data frame
#'
#' @description Takes raw NOAA data frame and returns a data frame with
#' LOCATION_NAME column clean, by stripping out the country name (including the
#' colon) and converting names to title case (as opposed to all caps).
#'
#' @param noaase_raw Raw NOAA data frame read with a function like
#' \code{readr::read_delim}.
#'
#' @return NOAA data frame, with LOCATION_NAME column cleaned by stripping out
#' the everything before the last colon (including the colon and space, usually
#' means country name, but there could be another subregion name) and converting
#' names to title case (as opposed to all caps).
#'
#' @import dplyr
#'
#' @examples
#' \dontrun{
#'   noaase_raw <- readr::read_delim("inst/extdata/earthquakes.tsv.gz", "\t")
#'   noaase_loc <- eq_location_clean(noaase_raw)
#' }
#'
#' @export
eq_location_clean <- function(noaase_raw) {
  noaase_raw %>%
    dplyr::mutate(
      LOCATION_NAME = stringr::str_to_title(
        sub(".*:\\s*", "", .data$LOCATION_NAME)
      )
    )
}
