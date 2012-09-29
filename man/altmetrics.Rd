\name{altmetrics}
\alias{altmetrics}
\title{Grab altmetric data on any paper}
\usage{
  altmetrics(doi = NA, apikey = getOption("altmetricKey"),
    curl = getCurlHandle(), ...)
}
\arguments{
  \item{doi}{\code{doi} of a paper.}

  \item{apikey}{An API key obtained from altmetric. The key
  for this application is
  '37c9ae22b7979124ea650f3412255bf9' and you are free to
  use it for academic non-commercial research. But if you
  start seeing rate limits, please contact support at
  altmetric.com to get your own.

  The function returns detailed metrics. For more
  information on all the fields returned by the function,
  see the API documentation:
  (\url{http://api.altmetric.com/docs/call_citations.html}).
  If you get your own key, you can save it in your
  \code{.rprofile} as
  \code{options(altmetricKey="YOUR_KEY")}}

  \item{curl}{passes on curl handle in a vectorized
  operation}

  \item{...}{additional parameters}
}
\value{
  \code{list}
}
\description{
  This function will retrieve data from Altmetric.com on
  any paper with a doi.
}
\examples{
\dontrun{
altmetrics(doi ='10.1890/ES11-00339.1')
altmetrics(doi ='10.1038/480426a')
}
}

