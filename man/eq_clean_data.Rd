% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eq_cleaning.R
\name{eq_clean_data}
\alias{eq_clean_data}
\title{Cleans raw NOAA data frame}
\usage{
eq_clean_data(noaase_raw)
}
\arguments{
\item{noaase_raw}{Raw NOAA data frame read with a function like
\code{readr::read_delim}.}
}
\value{
Clean NOAA data frame, with a date column created by uniting the
year, month, day and converting it to the Date class and LATITUDE and
LONGITUDE columns converted to numeric class.
}
\description{
Takes raw NOAA data frame and returns a clean data frame, with a
date column created by uniting the year, month, day and converting it to the
Date class and converts LATITUDE and LONGITUDE columns to numeric class.
}
\examples{
\dontrun{
  noaase_raw <- readr::read_delim("inst/extdata/earthquakes.tsv.gz", "\\t")
  noaase_clean <- eq_clean_data(noaase_raw)
}

}
