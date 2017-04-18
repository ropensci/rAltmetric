#' Query data from the Altmetric.com API
#'
#' @param oid  An object ID
#' @param id An altmetric.com id for a scholarly paper
#' @param doi A DOI
#' @param pmid A pubmed ID
#' @param arXiv An Arxiv id.
#' @param apikey Your API `key`. By default the package ships with a key, but mostly as a demo. If the key becomes overused, then it is likely that you will start to see API limit errors
#' @param foptions Additional options for `httr`
#' @param ... additional options
#'
#' @export
#' @examples
#' z <- altmetrics(doi ='10.1038/480426a')
#' # If you desire a `list` instead, then simply turn off the `flatten` argument

altmetrics <-
  function(oid = NULL,
           id = NULL,
           doi = NULL,
           pmid = NULL,
           arXiv = NULL,
           apikey = getOption('altmetricKey'),
           foptions = list(),
           ...) {
    if (is.null(apikey))
      apikey <- '37c9ae22b7979124ea650f3412255bf9'

    acceptable_identifiers <- c("doi", "arXiv", "id", "pmid")
    # If you start hitting rate limits, email support@altmetric.com
    # to get your own key.


    if (all(sapply(list(oid, doi, pmid, arXiv), is.null)))
      stop("No valid identfier found. See ?altmetrics for more help", call. =
             FALSE)


    # If an altmetric id is not prefixed by "id", add it in.
    if (!is.null(id)) {
      prefix <- as.list((strsplit(id, '/'))[[1]])[[1]]
      if (prefix != "id")
        id <- paste0("id", "/", id)
    }
    # If an doi id is not prefixed by "id", add it in.
    if (!is.null(doi)) {
      prefix <- as.list((strsplit(doi, '/'))[[1]])[[1]]
      if (prefix != "doi")
        doi <- paste0("doi", "/", doi)
    }
    # If an arXiv id is not prefixed by "arXiv", add it in.
    if (!is.null(arXiv)) {
      prefix <- as.list((strsplit(arXiv, ':|/'))[[1]])[[1]]
      arXiv <-
        paste0("arxiv", "/", as.list((strsplit(arXiv, ':|/'))[[1]])[[2]])
    }
    # If an pubmed id is not prefixed by "pmid", add it in.
    if (!is.null(pmid)) {
      prefix <- as.list((strsplit(pmid, '/'))[[1]])[[1]]
      if (prefix != "pmid")
        pmid <- paste0("pmid", "/", pmid)
    }


    # remove the identifiders that weren't specified
    identifiers <- ee_compact(list(oid, id, doi, pmid, arXiv))


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
      stop("Unknown identifier. Please use doi, pmid, arxiv or id (for altmetric id).",
           call. = F)
    base_url <- "http://api.altmetric.com/v1/"
    args <- list(key = apikey)
    request <-
      httr::GET(paste0(base_url, ids), query = args, foptions)

    results <-
      jsonlite::fromJSON(httr::content(request, as = "text"), flatten = TRUE)
    results <- rlist::list.flatten(results)
    class(results) <- "altmetric"
    results
  }


#' Returns a data.frame from an S3 object of class altmetric
#'
#' @param alt_obj An object of class altmetric
#'
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
