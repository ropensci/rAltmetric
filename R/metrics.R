#' Metrics
#'
#' Returns metrics for any standard identifier such as doi, arxiv, pmid, id, or ads.
#' @param identifier The identifier passed in the format "identifier/id".
#' @export
#' @import assertthat
#' @examples \dontrun{
#' foo <- metrics(identifier = "arxiv/1108.2455")
#' # This is a failed example
#' foo <- metrics(identifier = "arxiv/1108.24553")
#' # Now for a PMID
#' pm <- metrics(identifier = "pmid/21148220")
#'}
metrics <- function(identifier) {
   assert_that(!is.null(identifier))
   type <- dirname(identifier)
   possible_types <- c("doi", "id", "arxiv", "pmid", "ads", "uri")
   assert_that(type %in% possible_types)
   metrics_url <- paste0(api_url(), dirname(identifier), "/", basename(identifier))
   # message(sprintf("Calling %s \n", metrics_url))
   data <- GET(metrics_url)
   if(data$status_code == 404) {
     message("No metrics found")
     NULL
   } else {
   # warn_for_status(data)
   results <- content(data, as = 'text')
   # Needs more clean up here
   res <- jsonlite::fromJSON(results, flatten = TRUE)
   res <- sapply(res, flatten_nested_list)
   do.call(cbind, res)
   }
}

#' @param panda input foo
#' @noRd
flatten_nested_list <- function(panda) {
  fnames <- names(panda)
  z <- data.frame(t(unlist(panda)))
  names(z) <- fnames
  z
}


