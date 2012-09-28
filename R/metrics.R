

#' Grab altmetric data on any paper
#'
#' This function will retrieve data from Altmetric.com on any paper with a doi.
#' @param doi \code{doi} of a paper.
#' @param  apikey An API key obtained from altmetric. The key for this application is '37c9ae22b7979124ea650f3412255bf9' and you are free to use it. But if you start seeing rate limits, please contact support at altmetric.com to get your own.
#'
#' Although the package comes with its own API key, once the number of users increases, it is likely that you will start hitting api limits. In that case, you should contact support at altmetric.com and obtain your own. You can specify your own key either inline OR, for simplicity, add it to your .rprofile as follows.
#'
#' option(altmetricKey = 'YOUR_KEY')
#'
#' @param curl passes on curl handle in a vectorized operation
#' @param ... additional parameters
#' @export
#' @return \code{list}
#' @examples \dontrun{
#' altmetrics(doi ='10.1890/ES11-00339.1')
#' altmetrics(doi ='10.1038/480426a')
#'}
altmetrics <- function(doi = NA, apikey = getOption('altmetricKey'), curl = getCurlHandle(), ...) {
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
# Readers
readers <- unrowname(t(data.frame(alt$readers)))
cohorts <- unrowname(t(data.frame(alt$cohorts)))

# Context
context <- ldply(alt$context, function(foo) t(data.frame(foo)))
names(context) <- c("type", "count", "rank", "pct")
more_metrics <- dcast(melt(context, id.var="type"), 1~variable+type)

# fix added_on date and published_on date

return(data.frame(title = alt$title, doi = alt$doi, nlmid = alt$nlmid, altmetric_jid = alt$altmetric_jid, issns = alt$issns, journal = alt$journal, altmetric_id = alt$altmetric_id, schema = alt$schema, is_oa = alt$is_oa, cited_by_feeds_count = alt$cited_by_posts_count, cited_by_gplus_count = alt$cited_by_posts_count, cited_by_posts_count = alt$cited_by_posts_count, cited_by_tweeters_count = alt$cited_by_tweeters_count, cited_by_accounts_count = alt$cited_by_accounts_count,  score = alt$score, readers, cohorts, url = alt$url, added_on = alt$added_on, published_on = alt$published_on, subjects = alt$subjects, scopus_subjects = alt$scopus_subjects, last_updated = alt$last_updated, readers_count = alt$readers_count, more_metrics, details_url = alt$details_url ))
           
}




#' Returns cleaner metric source names
#'
#' @param provider the data provider
#' @export
#' @examples \dontrun{
#' return_provider('cited_by_gplus_count')
#'}
return_provider <- function(provider) {
	services <- data.frame(type = c("cited_by_gplus_count", "cited_by_fbwalls_count", "cited_by_posts_count", "cited_by_tweeters_count", "cited_by_accounts_count", "cited_by_feeds_count", "cited_by_rdts_count", "cited_by_msm_count", "cited_by_delicious_count", "cited_by_forum_count", "cited_by_qs_count"), names = c("Google+", "Facebook", "Cited", "Tweets", "Accounts", "Feeds", "Reddit", "MSM", "Delicious", "Forums", "QS"))

	return(services$names[which(services$type == provider)])
}