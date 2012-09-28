

#' Grab altmetric data on any paper
#'
#' This function will retrieve data from Altmetric.com on any paper with a doi.
#' @param doi \code{doi} of a paper.
#' @param  apikey An API key obtained from altmetric. The key for this application is '37c9ae22b7979124ea650f3412255bf9' and you are free to use it. But if you start seeing rate limits, please contact support at altmetric.com to get your own.
#' @param curl passes on curl handle in a vectorized operation
#' @param ... additional parameters
#' @export
#' @return \code{list}
#' @examples \dontrun{
#' altmetrics(doi ='10.1890/ES11-00339.1')
#' altmetrics(doi ='10.1038/480426a')
#'}
altmetrics <- function(doi = NA, apikey = NULL, curl = getCurlHandle(), ...) {
	if(is.null(apikey))
		apikey <- '37c9ae22b7979124ea650f3412255bf9'

    if(is.null(doi))
		stop("No doi supplied", call.=FALSE)

		args <- list(key = apikey)
		url <- "http://api.altmetric.com/v1/doi/"
		args$doi <- as.character(doi)

	
		url <- paste0(url, doi, "?key=", apikey)
    metrics <- getURL(url,  curl = curl)
   
   if(metrics == "Not Found") {
    	 message(sprintf("No metrics found on %s", doi))
    	} else {
    res <- fromJSON(metrics)
    class(res) <- "altmetric"
    return(res)
}
}
