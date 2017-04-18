#' Query data from the Altmetric.com API
#'
#' @param oid  An object ID
#' @param id An altmetric.com id for a scholarly paper
#' @param doi A DOI
#' @param pmid A pubmed ID
#' @param arXiv An Arxiv id.
#' @param isbn ISBN
#' @param uri Any URI
#' @param apikey Your API `key`. By default the package ships with a key, but mostly as a demo. If the key becomes overused, then it is likely that you will start to see API limit errors
#' @param foptions Additional options for `httr`
#' @param ... additional options
#' @importFrom httr stop_for_status status_code warn_for_status
#' @export
#' @examples
#' \dontrun{
#' altmetrics(doi ='10.1038/480426a')
#' # For ISBNs
#' ib <- altmetrics(isbn = "978-3-319-25557-6")
#' }
altmetrics <-
  function(oid = NULL,
           id = NULL,
           doi = NULL,
           pmid = NULL,
           arXiv = NULL,
           isbn = NULL,
           uri = NULL,
           apikey = getOption('altmetricKey'),
           foptions = list(),
           ...) {
    if (is.null(apikey))
      apikey <- '37c9ae22b7979124ea650f3412255bf9'

    acceptable_identifiers <- c("doi", "arXiv", "id", "pmid", "isbn", "uri")
    # If you start hitting rate limits, email support@altmetric.com
    # to get your own key.


    if (all(sapply(list(oid, doi, pmid, arXiv, isbn, uri), is.null)))
      stop("No valid identfier found. See ?altmetrics for more help", call. =
             FALSE)

    # If any of the identifiers are not prefixed by that text:
    if (!is.null(id)) id <- prefix_fix(id, "id")
    if (!is.null(doi)) doi <- prefix_fix(doi, "doi")
    if (!is.null(isbn)) isbn <- prefix_fix(isbn, "isbn")
    if (!is.null(uri)) uri <- prefix_fix(uri, "uri")
    if (!is.null(arXiv)) arXiv <- prefix_fix(arXiv, "arxiv")
    if (!is.null(pmid)) pmid <- prefix_fix(pmid, "pmid")


    # remove the identifiers that weren't specified
    identifiers <- ee_compact(list(oid, id, doi, pmid, arXiv, isbn, uri))


    # If user specifies more than one at once, then throw an error
    # Users should use lapply(object_list, altmetrics)
    # to process multiple objects.
    if (length(identifiers) > 1)
      stop(
        "Function can only take one object at a time. Use lapply with a list to process multiple objects",
        call. = FALSE
      )

    if (!is.null(identifiers)) {
      ids <- identifiers[[1]]
    }

    # Fix arXiv
    test <- strsplit(ids, ":")
    if (length(test[[1]]) == 2) {
      ids <-
        paste0(as.list(strsplit(ids, ":")[[1]])[[1]], "/", as.list(strsplit(ids, ":")[[1]])[[2]])
    }

    supplied_id <-
      as.character(as.list((strsplit(ids, '/'))[[1]])[[1]])

     # message(sprintf("%s", supplied_id))
    if (!(supplied_id %in% acceptable_identifiers))
      stop("Unknown identifier. Please use doi, pmid, isbn, uri, arxiv or id (for altmetric id).",
           call. = F)
    base_url <- "http://api.altmetric.com/v1/"
    args <- list(key = apikey)
    request <-
      httr::GET(paste0(base_url, ids), query = args, foptions)
    if(status_code(request) == 404) {
    stop("No metrics found for object")
    } else {
    stop_for_status(request)
    results <-
      jsonlite::fromJSON(httr::content(request, as = "text"), flatten = TRUE)
    results <- rlist::list.flatten(results)
    class(results) <- "altmetric"
    results

    }
  }


#' Returns a data.frame from an S3 object of class altmetric
#' @param alt_obj An object of class altmetric
#' @export
altmetric_data <- function(alt_obj) {
  if (inherits(alt_obj, "altmetric"))  {
    res <- data.frame(t(unlist(alt_obj)), stringsAsFactors = FALSE)
  }
  res
}

#' @noRd
ee_compact <- function(l)
  Filter(Negate(is.null), l)

#' @noRd
prefix_fix <- function(x, type = "doi") {
        prefix <- as.list((strsplit(x, '/'))[[1]])[[1]]
      if (prefix != type)
        paste0(type, "/", x)
}
