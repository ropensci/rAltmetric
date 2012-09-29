
#' Print a summary for an altmetric object
#' @method print altmetric
#' @S3method print altmetric
#' @param alt_obj An object of class \code{Altmetric}
print.altmetric <- function(alt_obj) {
    value <- NA

	string <- "Altmetrics on: \"%s\" with doi %s (altmetric_id: %s) published in %s."
    vals   <- c(alt_obj$title, alt_obj$doi, alt_obj$altmetric_id, alt_obj$journal)
    cat(do.call(sprintf, as.list(c(string, vals))))
    cat("\n")

    stats <- melt(alt_obj[grep("^cited", names(alt_obj))])
    stats$names <- unname(sapply(stats$L1, return_provider))
    stats$names <- factor(stats$names, levels = stats$names[rev(order(stats$value))])
    
    print( data.frame(provider = stats$names, count = stats$value))
}



#' Plots metrics for an altmetric object
#' 
#' @method plot altmetric
#' @S3method plot altmetric
#' @param alt_obj An object of class \code{Altmetric}
plot.altmetric <- function(alt_obj) {

value <- NA
# just to trick check()    
if (!is(alt_obj, "altmetric"))   
    stop("Not an altmetric object")

stats <- melt(alt_obj[grep("^cited", names(alt_obj))])
stats$names <- unname(sapply(stats$L1, return_provider))
stats$names <- factor(stats$names, levels = stats$names[rev(order(stats$value))])

# Grab the donut image
donut <- readPNG(getURLContent(alt_obj$images[[2]]))

# Now return a pretty plot
ggplot(stats, aes(names, value)) + geom_point(size = 4, colour = 'steelblue') + ggtitle(alt_obj$title) + xlab("Provider") + ylab("Hits") + theme(panel.background = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), panel.border = element_blank(),
        axis.line = element_line(colour = "black")) + annotation_raster(donut, xmin = dim(stats)[1]-1, xmax = dim(stats)[1], ymin = max(stats$value)-(.2*max(stats$value)), ymax = max(stats$value), interpolate = T) + theme(title = element_text(family = "Helvetica", colour = "#0680b0", face="bold"), axis.text = element_text(family="Courier", colour = "#3f3f3f"), axis.title = element_text(colour="#3f3f3f")) 
}

