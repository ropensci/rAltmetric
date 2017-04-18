
context("Testing altmetrics")
test_that("str_length is number of characters", {
  z <- altmetrics(doi ='10.1038/480426a')
  expect_is(z, "altmetric")
  # Test for an isbn
  ib <- altmetrics(isbn = "978-3-319-25557-6")
  expect_is(ib, "altmetric")
})

