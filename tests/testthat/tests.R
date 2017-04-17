
context("Testing altmetrics")
test_that("str_length is number of characters", {
  z <- altmetrics(doi ='10.1038/480426a')
  expect_is(z, "altmetric")
})

