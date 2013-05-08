

#' Grab altmetric data on any paper
#'
#' This function will retrieve data from Altmetric.com on any paper with an appropriate object identifier. Acceptable identifiers include dois, arXiv ids, pubmed ids and altmetric ids.
#' @param oid \code{oid} Any object ID. Any general object identifier as long as the prefix is "doi","pmid", "arXiv", or "id".
#' @param id The Altmetric \code{id} of a paper. If specifiying directly, the "id" prefix is not necessary.
#' @param doi The \code{doi} of a paper. If specifiying directly, the "doi" prefix is not necessary.
#' @param pmid The \code{pmid} of a paper.If specifiying directly, the "pmid" prefix is not necessary.
#' @param arXiv The \code{arxiv} ID of a paper.If specifiying directly, the "arXiv" prefix is not necessary.
#' @param  apikey An API key obtained from altmetric. The key for this application is '37c9ae22b7979124ea650f3412255bf9' and you are free to use it for academic non-commercial research. But if you start seeing rate limits, please contact support at altmetric.com to get your own.
#'
#' The function returns detailed metrics. For more information on all the fields returned by the function, see the API documentation: (\url{http://api.altmetric.com/docs/call_citations.html}). If you get your own key, you can save it in your \code{.rprofile} as \code{options(altmetricKey="YOUR_KEY")}
#' @param curl passes on curl handle in a vectorized operation
#' @param ... additional parameters
#' @export
#' @return \code{list}
#' @examples \dontrun{
#' altmetrics(doi ='10.1890/ES11-00339.1')
#' Or specfiy the doi with the id
#' altmetrics('doi/10.1890/ES11-00339.1')
#' altmetrics(doi ='10.1038/480426a')
#' Or specfiy the doi with the id
#' You can do the same for other providers such as pmid, id, and arxiv
#' altmetrics('doi/10.1038/480426a')
#'}
altmetrics <- function(oid = NULL, id = NULL, doi = NULL, pmid = NULL, arXiv = NULL, apikey = getOption('altmetricKey'), curl = getCurlHandle(), ...) {

	if(is.null(apikey))
		apikey <- '37c9ae22b7979124ea650f3412255bf9'
		acceptable_identifiers <- c("doi", "arXiv", "id", "pmid")
		# If you start hitting rate limits, email support@altmetric.com
		# to get your own key.

		# If no object identifiers were specified, throw an error
		if(is.null(oid) && is.null(id) && is.null(doi) && is.null(pmid) && is.null(arXiv))
			stop("No valid identfier found. See ?altmetrics for more help", call.=FALSE)

		# If an altmetric id is not prefixed by "id", add it in.
  	    if(!is.null(id)) {
  	    	prefix <- as.list((strsplit(id,'/'))[[1]])[[1]]
  	    	if(prefix != "id")
  	    		id <- paste0("id", "/", id)
  	    }
  	    # If an doi id is not prefixed by "id", add it in.
  	    if(!is.null(doi)) {
  	    	prefix <- as.list((strsplit(doi,'/'))[[1]])[[1]]
  	    	if(prefix != "doi")
  	    		doi <- paste0("doi", "/", doi)
  	    }
  	    # If an arXiv id is not prefixed by "arXiv", add it in.
  	    if(!is.null(arXiv)) {
  	    	prefix <- as.list((strsplit(arXiv,':|/'))[[1]])[[1]]
  	    	arXiv <- paste0("arXiv", "/", as.list((strsplit(arXiv,':|/'))[[1]])[[2]])
  	    }
  	    # If an pubmed id is not prefixed by "pmid", add it in.
  	    if(!is.null(pmid)) {
  	    	prefix <- as.list((strsplit(pmid,'/'))[[1]])[[1]]
  	    	if(prefix != "pmid")
  	    		pmid <- paste0("pmid", "/", pmid)
  	    }


  	    # remove the identifiders that weren't specified
   		identifiers <- compact(list(oid, id, doi, pmid, arXiv))

   		# If user specifies more than one at once, then throw an error
   		# Users should use lapply(object_list, altmetrics) 
   		# to process multiple objects.
   		if(length(identifiers) > 1)
   			stop("Function can only take one object at a time. Use lapply with a list to process multiple objects", call.=FALSE)

  		if(!is.null(identifiers)) {
  				ids <- identifiers[[1]]

          # Fix arXiv
          test <- strsplit(ids, ":")
          if(length(test[[1]]) == 2) {
              ids <- paste0(as.list(strsplit(ids, ":")[[1]])[[1]], "/", as.list(strsplit(ids, ":")[[1]])[[2]])
          }
  					
 				supplied_id <-  as.character(as.list((strsplit(ids,'/'))[[1]])[[1]])
 				# message(sprintf("%s", supplied_id))
 				if(!(supplied_id %in% acceptable_identifiers))
 						stop("Unknown identifier. Please use doi, pmid, arxiv or id (for altmetric id).", call.=F)
 						             
  		}

  		# message(sprintf("%s", identifiers[[1]]))
		url <- "http://api.altmetric.com/v1/"
		url <- paste0(url,  ids, "?key=", apikey)
        metrics <- getURL(url,  curl = curl)
   
   if(metrics == "Not Found") {
    	 message(sprintf("No metrics found on %s", identifiers[[1]]))
    	 return(NULL)
    	} else {
    res <- fromJSON(metrics)
    class(res) <- "altmetric"
    return(res)
}
}
# Make it possible to do either doi or a full list. In case of full list, the first part must be the name of the identifier.


#' Returns a data frame of metrics for a paper
#'
#' @param alt_obj altmetrics object
#' @export
#' @return data.frame
#' @examples \dontrun{
#' altmetric_data(altmetrics('10.1038/489201a'))
#'}
altmetric_data <- function(alt_obj) {
  value <- NA
  if (is(alt_obj, "altmetric"))  {
    
    # Pull our readers and cohorts before squashing the list
    reader <- alt_obj$readers
    cohort <- alt_obj$cohorts
    alt_obj <- alt_obj[-which(names(alt_obj)=="readers")]
    alt_obj <- alt_obj[-which(names(alt_obj)=="cohorts")]
    
    # Remove TQ if it exists
    if("tq" %in% names(alt_obj)) {
      alt_obj <- alt_obj[-which(names(alt_obj)=="tq")]
    }
    
    # Basic stats
    alt_obj$issns <- paste0(alt_obj$issns, collapse = '', sep = ",")
    basic_stuff <- data.frame(matrix(rep(NA, 10), nrow =1))
    names(basic_stuff) <-  names(alt_obj)[1:10]
    basic_data <- data.frame(t(unlist(alt_obj[1:10])))
    # basics <- rbind.fill(basic_stuff, basic_data)[-1, ]
    basics <- basic_data
    
    # Readers to data.frame
    readers <- unrowname(t(data.frame(reader)))
    cohorts <- data.frame("pub" = NA, "sci" = NA, "com" = NA, "doc" = NA)
    cohorts2 <- data.frame(unrowname(t(data.frame(cohort))))
    cohorts <- rbind.fill(cohorts, cohorts2)[-1,]
    
    # Context (hard to standardize so excluding this for now)
    # context <- ldply(alt_obj$context, function(foo) t(data.frame(foo)))
    # names(context) <- c("type", "count", "rank", "pct")
    # more_metrics <- dcast(melt(context, id.var="type"), 1~variable+type)[, -1]
    # # 1, 18
    
    # Counts to data.frame
    stats_base <- data.frame("cited_by_gplus_count" =NA, "cited_by_fbwalls_count" =NA,"cited_by_posts_count" =NA, "cited_by_tweeters_count" =NA, "cited_by_accounts_count" =NA, "cited_by_feeds_count" =NA, "cited_by_rdts_count" =NA, "cited_by_msm_count" =NA, "cited_by_delicious_count" =NA, "cited_by_forum_count" = NA, "cited_by_qs_count" = NA, "cited_by_rh_count" = NA)
#     stats <- melt(alt_obj[grep("^cited", names(alt_obj))])
    stats <- data.frame(alt_obj[grep("^cited", names(alt_obj))])
#     stats <- dcast(stats, 1~value+L1)[, -1]
#     names(stats) <- gsub("^[0-9]_","", names(stats))
    stats <- rbind.fill(stats_base, stats)[-1,]
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
    # return(data.frame(basic_stuff, stats,  score = alt_obj$score, readers, url = alt_obj$url, added_on = alt_obj$added_on, published_on = alt_obj$published_on, subjects = alt_obj$subjects, scopus_subjects = alt_obj$scopus_subjects, last_updated = alt_obj$last_updated, readers_count = alt_obj$readers_count, more_metrics, details_url = alt_obj$details_url))
    
    return(data.frame(basics, stats,  score = alt_obj$score, readers, url = alt_obj$url, 
                      added_on = alt_obj$added_on, published_on = alt_obj$published_on, 
                      subjects = alt_obj$subjects, scopus_subjects = alt_obj$scopus_subjects, 
                      last_updated = alt_obj$last_updated, readers_count = alt_obj$readers_count, 
                      details_url = alt_obj$details_url))
  }
  
}




#' Returns cleaner metric source names (mostly for internal use)
#'
#' @param provider the data provider
#' @export
#' @keywords internal
#' @examples \dontrun{
#' return_provider('cited_by_gplus_count')
#'}
return_provider <- function(provider) {
	services <- data.frame(type = c("cited_by_gplus_count", "cited_by_fbwalls_count", "cited_by_posts_count", "cited_by_tweeters_count", "cited_by_accounts_count", "cited_by_feeds_count", "cited_by_rdts_count", "cited_by_msm_count", "cited_by_delicious_count", "cited_by_forum_count", "cited_by_qs_count"), names = c("Google+", "Facebook", "Cited", "Tweets", "Accounts", "Feeds", "Reddit", "MSM", "Delicious", "Forums", "QS"))

	return(services$names[which(services$type == provider)])
}