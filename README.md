
<!-- README.md is generated from README.Rmd. Please edit that file -->
![altmetric.com](altmetric_logo_title.png)

rAltmetric
==========

![](http://cranlogs.r-pkg.org/badges/rAltmetric)
[![Travis-CI Build Status](https://travis-ci.org/ropensci/rAltmetric.svg?branch=master)](https://travis-ci.org/ropensci/rAltmetric)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/ropensci/rAltmetric?branch=master&svg=true)](https://ci.appveyor.com/project/ropensci/rAltmetric)
[![Coverage Status](https://img.shields.io/codecov/c/github/ropensci/rAltmetric/master.svg)](https://codecov.io/github/ropensci/rAltmetric?branch=master)

This package provides a way to programmatically retrieve altmetrics from various publication types (books, newsletters, articles, peer-reviewed papers and more) from [altmetric.com](http://altmetric.com). The package is really simple to use and only has two major functions: - `altmetrics` - Pass it a doi, isbn, uri, arxiv id or other to get metrics - `altmetric_data` Pass it the results from the previous call to get a tidy `data.frame`

Questions, features requests and issues should go [here](https://github.com/ropensci/rAltmetric/issues/).

Installing the package
======================

A stable version is available from CRAN. To install

``` r
install.packages('rAltmetric')
👷 or  the dev version
devtools::install_github("ropensci/rAltmetric")
```

Quick Tutorial
==============

Obtaining metrics
-----------------

There was a 2010 paper by [Acuna et al](http://www.nature.com/news/2010/100616/full/465860a.html) that received a lot of attention on Twitter. What was the impact of that paper?

``` r
library(rAltmetric)
acuna <- altmetrics(doi = "10.1038/465860a")
acuna
#> Altmetrics on: "Metrics: Do metrics matter?" with altmetric_id: 385053 published in Nature.
#>                         stats
#> cited_by_fbwalls_count      3
#> cited_by_feeds_count        3
#> cited_by_gplus_count        2
#> cited_by_msm_count          1
#> cited_by_policies_count     1
#> cited_by_posts_count       31
#> cited_by_tweeters_count    20
#> cited_by_accounts_count    30
```

Data
----

To obtain the metrics in tabular form for further processing, run any object of class `altmetric` through `altmetric_data()` to get data that can easily be written to disk as a spreadsheet.

``` r
altmetric_data(acuna)
#>                         title             doi     pmid
#> 1 Metrics: Do metrics matter? 10.1038/465860a 20559361
#>                                                                         tq1
#> 1 Survey of how metrics are used in hiring, promotion and tenure decisions.
#>                                                                                                   tq2
#> 1 Should some professions be excluded from performance metrics? #metrics #kpi #performancemeasurement
#>                                                tq3
#> 1 “@Nanomedicina: Publications: Do metrics matter?
#>                                               tq4            altmetric_jid
#> 1 Do metrics matter? #oaweek13 (in talk @pgroth ) 4f6fa50a3cf058f610003160
#>      issns1    issns2 journal cohorts.pub cohorts.sci cohorts.com
#> 1 0028-0836 1476-4687  Nature          13           5           2
#>   context.all.count context.all.mean context.all.rank context.all.pct
#> 1           7133716  6.3030007714043           130911              98
#>   context.all.higher_than context.journal.count context.journal.mean
#> 1                 7003174                 44393       68.76030910975
#>   context.journal.rank context.journal.pct context.journal.higher_than
#> 1                10546                  76                       33847
#>   context.similar_age_3m.count context.similar_age_3m.mean
#> 1                        76598              5.330816089403
#>   context.similar_age_3m.rank context.similar_age_3m.pct
#> 1                        1082                         98
#>   context.similar_age_3m.higher_than context.similar_age_journal_3m.count
#> 1                              75516                                  894
#>   context.similar_age_journal_3m.mean context.similar_age_journal_3m.rank
#> 1                     54.580732362822                                 262
#>   context.similar_age_journal_3m.pct
#> 1                                 70
#>   context.similar_age_journal_3m.higher_than type altmetric_id schema
#> 1                                        632 news       385053  1.5.4
#>   is_oa cited_by_fbwalls_count cited_by_feeds_count cited_by_gplus_count
#> 1 FALSE                      3                    3                    2
#>   cited_by_msm_count cited_by_policies_count cited_by_posts_count
#> 1                  1                       1                   31
#>   cited_by_tweeters_count cited_by_accounts_count last_updated  score
#> 1                      20                      30   1454625692 53.388
#>   history.1y history.6m history.3m history.1m history.1w history.6d
#> 1          0          0          0          0          0          0
#>   history.5d history.4d history.3d history.2d history.1d history.at
#> 1          0          0          0          0          0     53.388
#>                                 url   added_on published_on subjects
#> 1 http://dx.doi.org/10.1038/465860a 1317207766   1276646400  science
#>   scopus_subjects readers.citeulike readers.mendeley readers.connotea
#> 1         General                 3              303                2
#>   readers_count
#> 1           308
#>                                                                 images.small
#> 1 https://altmetric-badges.a.ssl.fastly.net/?size=64&score=54&types=mbtttfdg
#>                                                                 images.medium
#> 1 https://altmetric-badges.a.ssl.fastly.net/?size=100&score=54&types=mbtttfdg
#>                                                                  images.large
#> 1 https://altmetric-badges.a.ssl.fastly.net/?size=180&score=54&types=mbtttfdg
#>                                               details_url
#> 1 http://www.altmetric.com/details.php?citation_id=385053
```

You can save these data into a clean spreadsheet format:

``` r
acuna_data <- altmetric_data(acuna)
readr::write_csv(acuna_data, path = 'acuna_altmetrics.csv')
```

Gathering metrics for many DOIs
===============================

For a real world use-case, one might want to get metrics on multiple publications. If so, just read them from a spreadsheet and `llply` through them like the example below.

``` r
library(rAltmetric)
ids <- c(
    "10.1038/nature09210",
    "10.1126/science.1187820",
    "10.1016/j.tree.2011.01.009",
    "10.1086/664183"
  )

alm <- function(x) {
  altmetrics(doi = x) %>% altmetric_data()
}

z <- lapply(ids, alm) 
results <- bind_rows(z) 
```

Further reading
---------------

-   [Metrics: Do metrics matter?](http://www.nature.com/news/2010/100616/full/465860a.html)
-   [The altmetrics manifesto](http://altmetrics.org/manifesto/)

To cite package ‘rAltmetric’ in publications use:

``` r
  Karthik Ram (2017). rAltmetric: Retrieves altmerics data for any
  published paper from altmetrics.com. R package version 0.3.
  http://CRAN.R-project.org/package=rAltmetric

A BibTeX entry for LaTeX users is

  @Manual{,
    title = {rAltmetric: Retrieves altmerics data for any published paper from
altmetrics.com},
    author = {Karthik Ram},
    year = {2017},
    note = {R package version 0.7},
    url = {http://CRAN.R-project.org/package=rAltmetric},
  }
```

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
