context("Leaflet maps functions")

test_that("eq_map", {
  test_df <- data.frame(
    EQ_PRIMARY = c(4.9, 5.0),
    LATITUDE = c(42.658, 34.649),
    LONGITUDE = c(19.883, 45.799),
    DATE = c(as.Date("2018-01-04"), NA),
    TOTAL_DEATHS = c(NA, NA)
  )
  expect_identical(eq_map(test_df)$x$limits$lat, c(34.649, 42.658))
  expect_identical(eq_map(test_df, "TOTAL_DEATHS")$x$limits$lng,
                   c(19.883, 45.799))
})

test_that("eq_create_label", {
  test_df <- data.frame(LOCATION_NAME = c(NA, "Hualien"),
                        EQ_PRIMARY = c(NA, "6.4"),
                        TOTAL_DEATHS = c(NA, "17"))
  expected_result <- c(
    paste("<b>Location:</b> NA <br />",
          "<b>Magnitude:</b> NA <br />",
          "<b>Total deaths:</b> NA <br />"),
    paste("<b>Location:</b> Hualien <br />",
          "<b>Magnitude:</b> 6.4 <br />",
          "<b>Total deaths:</b> 17 <br />")
  )
  expect_identical(eq_create_label(test_df), expected_result)
})
