#' Internal function to match provider names
#'
#' @param provider provider name
#' @keywords internal
return_prov <- function(provider) {
	services <- data.frame(type = c("cited_by_gplus_count", "cited_by_fbwalls_count", "cited_by_posts_count", "cited_by_tweeters_count", "cited_by_accounts_count", "cited_by_feeds_count", "cited_by_rdts_count", "cited_by_msm_count", "cited_by_delicious_count", "cited_by_forum_count", "cited_by_qs_count"), names = c("Google+", "Facebook", "Cited", "Tweets", "Accounts", "Feeds", "Reddit", "MSM", "Delicious", "Forums", "QS"))

	return(services$names[which(services$type == provider)])
}

#' Print a summary for an altmetric object
#' @method print altmetric
#' @param alt_obj An object of class \code{Altmetric}
print.altmetric <- function(alt_obj) {
	string <- "Altmetrics on: \"%s\" with doi %s (altmetric_id: %s) published in %s."
    vals   <- c(alt_obj$title, alt_obj$doi, alt_obj$altmetric_id, alt_obj$journal)
    cat(do.call(sprintf, as.list(c(string, vals))))
    cat("\n")
    stats <- melt(alt_obj[grep("^cited", names(alt_obj))])
stats$names <- unname(sapply(stats$L1, return_prov))
stats$names <- factor(stats$names, levels = stats$names[rev(order(stats$value))])
 print(stats)
}



#' Plots metrics for an altmetric object
#' 
#' @method plot altmetric
#' @param alt_obj An object of class \code{Altmetric}
plot.altmetric <- function(alt_obj) {
stats <- melt(alt_obj[grep("^cited", names(alt_obj))])
stats$names <- unname(sapply(stats$L1, return_prov))
stats$names <- factor(stats$names, levels = stats$names[rev(order(stats$value))])

# Grab the donut image
donut <- readPNG(getURLContent(alt_obj$images[[2]]))

# Now make a pretty plot
ggplot(stats, aes(names, value)) + geom_point(size = 4, colour = 'steelblue') + ggtitle(alt_obj$title) + xlab("Provider") + ylab("Hits") + theme(panel.background = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), panel.border = element_blank(),
        axis.line = element_line(colour = "black")) + annotation_raster(donut, xmin = dim(stats)[1]-1, xmax = dim(stats)[1], ymin = max(stats$value)-60, ymax = max(stats$value), interpolate = T) + theme(title = element_text(family = "Helvetica", colour = "#0680b0", face="bold"), axis.text = element_text(family="Courier", colour = "#3f3f3f"), axis.title = element_text(colour="#3f3f3f")) 
}

