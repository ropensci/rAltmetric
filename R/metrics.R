

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

#' Returns a data frame of metrics for a paper
#'
#' @param alt altmetrics object
#' @export
#' @return data.frame
#' @examples \dontrun{
#' altmetric_data(altmetrics('10.1038/489201a'))
#'}
altmetric_data <- function(alt) {
return_prov <- function(provider) {
	services <- data.frame(type = c("cited_by_gplus_count", "cited_by_fbwalls_count", "cited_by_posts_count", "cited_by_tweeters_count", "cited_by_accounts_count", "cited_by_feeds_count", "cited_by_rdts_count", "cited_by_msm_count", "cited_by_delicious_count", "cited_by_forum_count", "cited_by_qs_count"), names = c("Google+", "Facebook", "Cited", "Tweets", "Accounts", "Feeds", "Reddit", "MSM", "Delicious", "Forums", "QS"))

	return(services$names[which(services$type == provider)])
}

stats <- melt(alt[grep("^cited", names(alt))])
stats$names <- unname(sapply(stats$L1, return_prov))
stats$names <- factor(stats$names, levels = stats$names[rev(order(stats$value))])
return(data.frame(names = stats[, 3], counts = stats[ , 1]))
}