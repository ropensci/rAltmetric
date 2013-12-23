
#' Print a summary for an altmetric object
#' @method print altmetric
#' @S3method print altmetric
#' @param x An object of class \code{Altmetric}
#' @param ... additional arguments
print.altmetric <- function(x, ...) {
    value <- NA

	string <- "Altmetrics on: \"%s\" with altmetric_id: %s published in %s."
    vals   <- c(x$title,  x$altmetric_id, x$journal)
    cat(do.call(sprintf, as.list(c(string, vals))))
    cat("\n")

    stats <- melt(x[grep("^cited", names(x))])
    stats$names <- unname(sapply(stats$L1, return_provider))
    stats$names <- factor(stats$names, levels = stats$names[rev(order(stats$value))])
    
    print( data.frame(provider = stats$names, count = stats$value))
}



#' Plots metrics for an altmetric object
#' 
#' @method plot altmetric
#' @S3method plot altmetric
#' @param x An object of class \code{Altmetric}
#' @import ggplot2
#' @importFrom reshape2 melt
#' @importFrom png readPNG
#' @importFrom RCurl getURLContent
#' @param ... additional arguments
plot.altmetric <- function(x, ...) {

value <- NA
# just to trick check()    
if (!is(x, "altmetric"))   
    stop("Not an altmetric object")

stats <- melt(x[grep("^cited", names(x))])
stats$names <- unname(sapply(stats$L1, return_provider))
stats$names <- factor(stats$names, levels = stats$names[rev(order(stats$value))])
stats <- stats[-(which(stats$L1=="cited_by_accounts_count")),]
# Grab the donut image
donut <- readPNG(getURLContent(x$images[[2]]))

# Now return a pretty plot
ggplot(stats, aes(names, value)) + geom_point(size = 4, colour = 'steelblue') + ggtitle(x$title) + xlab("Provider") + ylab("Hits") + theme(panel.background = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), panel.border = element_blank(),
        axis.line = element_line(colour = "black")) + annotation_raster(donut, xmin = dim(stats)[1]-1, xmax = dim(stats)[1], ymin = max(stats$value)-(.2*max(stats$value)), ymax = max(stats$value), interpolate = T) + theme(title = element_text(family = "Helvetica", colour = "#0680b0", face="bold"), axis.text = element_text(family="Courier", colour = "#3f3f3f"), axis.title = element_text(colour="#3f3f3f")) 
}

