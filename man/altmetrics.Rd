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
  use it. But if you start seeing rate limits, please
  contact support at altmetric.com to get your own.

  Although the package comes with its own API key, once the
  number of users increases, it is likely that you will
  start hitting api limits. In that case, you should
  contact support at altmetric.com and obtain your own. You
  can specify your own key either inline OR, for
  simplicity, add it to your .rprofile as follows.

  option(altmetricKey = 'YOUR_KEY')}

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

