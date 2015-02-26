#' Returns base API url
#' 
#' Returns the base API url for version 1 of altmetric
#' @noRd
api_url <- function() {
  "http://api.altmetric.com/v1/"
}


#' @noRd
altmetric_compact <- function(l) Filter(Negate(is.null), l)

