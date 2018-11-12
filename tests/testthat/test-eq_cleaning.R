context("Cleaning functions")

test_that("eq_clean_data", {
  test_df <- data.frame(
    DAY = c("01", "02", "03", NA),
    MONTH = c("04", "05", "06", NA),
    YEAR = c("2001", "2002", "2003", NA),
    LATITUDE = c("42.658", "34.649", "53.200", NA),
    LONGITUDE = c("19.883", "45.799", "6.600", NA)
  )
  expected_df <- data.frame(
    DAY = c("01", "02", "03", NA),
    MONTH = c("04", "05", "06", NA),
    YEAR = c("2001", "2002", "2003", NA),
    LATITUDE = c(42.658, 34.649, 53.200, NA),
    LONGITUDE = c(19.883, 45.799, 6.600, NA),
    DATE = as.Date(c("2001-04-01", "2002-05-02", "2003-06-03", NA))
  )
  expect_identical(eq_clean_data(test_df), expected_df)
})

test_that("eq_location_clean", {
  test_df <- data.frame(LOCATION_NAME = c("ITALY: LACUS CIMINI",
                                          "SYRIAN COASTS",
                                          NA,
                                          "INDIA  : N"))
  expected_df <- data.frame(LOCATION_NAME = c("Lacus Cimini",
                                              "Syrian Coasts",
                                              NA,
                                              "N"),
                            stringsAsFactors = FALSE)
  expect_identical(eq_location_clean(test_df), expected_df)
})
