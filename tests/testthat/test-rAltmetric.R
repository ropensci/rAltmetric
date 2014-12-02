
context('Altmetrics are returned')

test_that("We are able to retrieve regular metrics", {

    x <- altmetrics(doi ='10.1038/480426a')
    expect_is(x, "altmetric")
    expect_true("pmid" %in% names(x))

    xx <- altmetric_data(altmetrics(doi='10.1038/489201a'))
    expect_is(xx, "data.frame")
})
