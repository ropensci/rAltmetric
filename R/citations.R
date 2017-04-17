#' Retrieves most popular articles over a defined time period
#'
#' The time period can be any of the following: '1d', '2d', '3d', '4d', '5d', '6d', '1w', '1m', '3m', '6m', '1y'
#' @param day The time period over which metrics are required. Allowed options include '1d', '2d', '3d', '4d', '5d', '6d', '1w', '1m', '3m', '6m', '1y'resu
#' @param  page Page number
#' @param  num_results Max number of results per page. Cannot exceed \code{100}.
#' @param  cited_in One or more comma delimited options from: facebook, blogs, linkedin, video, pinterest, gplus, twitter, reddit, news, f1000, rh, qna, forum, peerreview
#' @param  doi_prefix A DOI prefix (the bit before the first slash, e.g. 10.1038)
#' @param  nlmid Comma delimited list of journal NLM IDs. Include only articles from journals with the supplied NLM journal IDs (only journals indexed in PubMed have NLM IDs).
#' @param  subject Comma delimited list of slugified journal subjects. Include only articles from journals matching any of the supplied NLM subject ontology term(s).
#' @param foptions A list of additional arguments for \code{httr}. There is no reason to use this argument except for debugging purposes.
#' @import httr
#' @export
#' @examples
#' citations(day = '1d')
#' # Only Facebook mentions
#' fb_1week <- citations('1w', cited_in = "facebook")
citations <- function(day, page = NULL, num_results = 100, cited_in = NULL, doi_prefix = NULL, nlmid = NULL, subject = NULL, foptions = list()) {
  assert_that(!is.null(day))
  possible <- c('1d', '2d', '3d', '4d', '5d', '6d', '1w', '1m', '3m', '6m', '1y')
  assert_that(day %in% possible)
  # 100 is the max results one can get per page
  assert_that(num_results <= 100)
  args <- as.list( altmetric_compact(c(page = page, num_results = num_results, cited_in = cited_in, doi_prefix = doi_prefix, nlmid = nlmid, subject = subject)))
  citations_url <- paste0(api_url(), "citations/", day, "/")
  data <- GET(citations_url, query = args, foptions)
  warn_for_status(data)
  results <- content(data, as = 'text')
  res <- jsonlite::fromJSON(results, flatten = TRUE)
  res$results <- as.data.frame(apply(res$results, 2, flat_list))
  res$query <- data.frame(t(unlist(res$query)))
  class(res) <- "altmetric"
  res
}


#' NoRd
#' @param foo input column
flat_list <- function(foo) {
  if(identical(class(foo), "list")) {
    foo <- vapply(foo, paste, collapse = ", ", character(1L))
  }
  foo
}
