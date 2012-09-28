

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
#' @param alt_obj altmetrics object
#' @export
#' @return data.frame
#' @examples \dontrun{
#' altmetric_data(altmetrics('10.1038/489201a'))
#'}
altmetric_data <- function(alt_obj) {
# Remove TQ
reader <- alt_obj$readers
cohort <- alt_obj$cohorts
alt_obj <- alt_obj[-which(names(alt_obj)=="readers")]
alt_obj <- alt_obj[-which(names(alt_obj)=="cohorts")]

if("tq" %in% names(alt_obj)) {
   alt_obj <- alt_obj[-which(names(alt_obj)=="tq")]
}

# Basic stats
alt_obj$issns <- paste0(alt_obj$issns, collapse = '', sep = ",")
basic_stuff <- data.frame(matrix(rep(NA, 10), nrow =1))
names(basic_stuff) <-  names(alt_obj)[1:10]
basic_data <- data.frame(t(unlist(alt_obj[1:10])))
basics <- rbind.fill(basic_stuff, basic_data)[-1, ]

# Readers
readers <- unrowname(t(data.frame(reader)))
cohorts <- data.frame("pub" = NA, "sci" = NA, "com" = NA, "doc" = NA)
cohorts2 <- data.frame(unrowname(t(data.frame(cohort))))
cohorts <- rbind.fill(cohorts, cohorts2)[-1,]

# Context (hard to standardize so excluding this for now)
# context <- ldply(alt_obj$context, function(foo) t(data.frame(foo)))
# names(context) <- c("type", "count", "rank", "pct")
# more_metrics <- dcast(melt(context, id.var="type"), 1~variable+type)[, -1]
# # 1, 18

# Counts
stats_base <- data.frame("cited_by_gplus_count" =NA, "cited_by_fbwalls_count" =NA,"cited_by_posts_count" =NA, "cited_by_tweeters_count" =NA, "cited_by_accounts_count" =NA, "cited_by_feeds_count" =NA, "cited_by_rdts_count" =NA, "cited_by_msm_count" =NA, "cited_by_delicious_count" =NA, "cited_by_forum_count" = NA, "cited_by_qs_count" = NA, "cited_by_rh_count" = NA)
stats <- melt(alt_obj[grep("^cited", names(alt_obj))])
stats2 <- dcast(stats, 1~value+L1)[, -1]
names(stats2) <- gsub("^[0-9]_","", names(stats2))
stats3 <- rbind.fill(stats_base, stats2)[-1,]
# 1, 11

alt_obj$subjects <- paste0(alt_obj$subjects, collapse='', sep=",")
alt_obj$scopus_subjects <- paste0(alt_obj$scopus_subjects, collapse='', sep=", ")

if(length(alt_obj$added_on) ==0 || is.null(alt_obj$added_on)) {
	alt_obj$added_on <- NA

}
if(length(alt_obj$published_on) ==0 || is.null(alt_obj$published_on)) {
	alt_obj$published_on <- NA
}


# Removing more_metrics for the time being
# return(data.frame(basic_stuff, stats3,  score = alt_obj$score, readers, url = alt_obj$url, added_on = alt_obj$added_on, published_on = alt_obj$published_on, subjects = alt_obj$subjects, scopus_subjects = alt_obj$scopus_subjects, last_updated = alt_obj$last_updated, readers_count = alt_obj$readers_count, more_metrics, details_url = alt_obj$details_url))

 return(data.frame(basic_stuff, stats3,  score = alt_obj$score, readers, url = alt_obj$url, added_on = alt_obj$added_on, published_on = alt_obj$published_on, subjects = alt_obj$subjects, scopus_subjects = alt_obj$scopus_subjects, last_updated = alt_obj$last_updated, readers_count = alt_obj$readers_count, details_url = alt_obj$details_url))
           
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