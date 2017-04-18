
context("Testing altmetrics")
test_that("str_length is number of characters", {
  z <- altmetrics(doi ='10.1038/480426a')
  expect_is(z, "altmetric")
  # Test for an isbn
  ib <- altmetrics(isbn = "978-3-319-25557-6")
  expect_is(ib, "altmetric")
  expect_s3_class(z, "altmetric")
  expect_s3_class(altmetric_data(z), "data.frame")
})

context("Testing helpers")

test_that("Helper functions do as expected") {
  # This will test that compact does remove NULL
  expect_equal(length(ee_compact(list(a = 1, b = NULL, c = 5))), 2)
  # This will test that prefix_fix actually adds a prefix of text/
  expect_equal(nchar(prefix_fix("1", "doi")), 5)
}
