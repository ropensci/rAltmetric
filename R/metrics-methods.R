#' Print a summary for an altmetric object
#' @export
#' @param x An object of class \code{Altmetric}
#' @param ... additional arguments
print.altmetric <- function(x, ...) {
  if (inherits(x, "altmetric"))  {
string <- "Altmetrics on: \"%s\" with altmetric_id: %s published in %s."
vals   <- c(x$title,  x$altmetric_id, x$journal)
 if("journal" %in% names(x)) {
  cat(do.call(sprintf, as.list(c(string, vals))))
 } else {
   string <- "Altmetrics on: \"%s\" with altmetric_id: %s"
   cat(do.call(sprintf, as.list(c(string, vals))))
 }
  cat("\n")
  stats <- x[grep("^cited", names(x))]
  stats <- data.frame(stats, stringsAsFactors = FALSE)
  print(data.frame(stats = t(stats)))
  }
}
