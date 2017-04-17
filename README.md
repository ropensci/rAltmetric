
<!-- README.md is generated from README.Rmd. Please edit that file -->
![altmetric.com](https://raw.github.com/ropensci/rAltmetric/master/altmetric_logo_title.png)

rAltmetric
==========

This package provides a way to programmatically retrieve altmetric data from [altmetric.com](http://altmetric.com) for any publication with the appropriate identifer. The package is really simple to use and only has two major functions: One (`altmetrics()`) to download metrics and another (`altmetric_data()`) to extract the data into a `data.frame`. It also includes generic S3 methods to plot/print metrics for any altmetric object.

Questions, features requests and issues should go [here](https://github.com/ropensci/rAltmetric/issues/).

Installing the package
======================

A stable version is available from CRAN. To install

``` r
install.packages('rAltmetric')

or install the development version

devtools::install_github("ropensci/rAltmetric")
```

Quick Tutorial
==============

Obtaining metrics
-----------------

There was a recent paper by [Acuna et al](http://www.nature.com/news/2010/100616/full/465860a.html) that received a lot of attention on Twitter. What was the impact of that paper?

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
knitr::kable(results)
```

| title                                                                                    | doi                        | pmid     | tq                                                                                                                   | ads\_id             | uri                                                         | altmetric\_jid           | issns1    | issns2    | journal                       | cohorts.sci | abstract                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | abstract\_source | context.all.count | context.all.mean | context.all.rank | context.all.pct | context.all.higher\_than | context.journal.count | context.journal.mean | context.journal.rank | context.journal.pct | context.journal.higher\_than | context.similar\_age\_3m.count | context.similar\_age\_3m.mean | context.similar\_age\_3m.rank | context.similar\_age\_3m.pct | context.similar\_age\_3m.higher\_than | context.similar\_age\_journal\_3m.count | context.similar\_age\_journal\_3m.mean | context.similar\_age\_journal\_3m.rank | context.similar\_age\_journal\_3m.pct | context.similar\_age\_journal\_3m.higher\_than | type    | altmetric\_id | schema | is\_oa | cited\_by\_fbwalls\_count | cited\_by\_feeds\_count | cited\_by\_msm\_count | cited\_by\_policies\_count | cited\_by\_posts\_count | cited\_by\_tweeters\_count | cited\_by\_accounts\_count | last\_updated | score  | history.1y | history.6m | history.3m | history.1m | history.1w | history.6d | history.5d | history.4d | history.3d | history.2d | history.1d | history.at | url                                            | published\_on | subjects | scopus\_subjects | readers.citeulike | readers.mendeley | readers.connotea | readers\_count | images.small                                                                 | images.medium                                                                 | images.large                                                                  | details\_url                                              | cited\_by\_rh\_count | added\_on  | pmc        | tq1                                                                                             | tq2                                                                                                            | tq3                                                                                                                     | cohorts.pub | publisher\_subjects.name1 | publisher\_subjects.name2 | publisher\_subjects.scheme1 | publisher\_subjects.scheme2 | scopus\_subjects1 | scopus\_subjects2                    | issns3    | issns4    | cohorts.doc | publisher\_subjects.name | publisher\_subjects.scheme |
|:-----------------------------------------------------------------------------------------|:---------------------------|:---------|:---------------------------------------------------------------------------------------------------------------------|:--------------------|:------------------------------------------------------------|:-------------------------|:----------|:----------|:------------------------------|:------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------|:------------------|:-----------------|:-----------------|:----------------|:-------------------------|:----------------------|:---------------------|:---------------------|:--------------------|:-----------------------------|:-------------------------------|:------------------------------|:------------------------------|:-----------------------------|:--------------------------------------|:----------------------------------------|:---------------------------------------|:---------------------------------------|:--------------------------------------|:-----------------------------------------------|:--------|:--------------|:-------|:-------|:--------------------------|:------------------------|:----------------------|:---------------------------|:------------------------|:---------------------------|:---------------------------|:--------------|:-------|:-----------|:-----------|:-----------|:-----------|:-----------|:-----------|:-----------|:-----------|:-----------|:-----------|:-----------|:-----------|:-----------------------------------------------|:--------------|:---------|:-----------------|:------------------|:-----------------|:-----------------|:---------------|:-----------------------------------------------------------------------------|:------------------------------------------------------------------------------|:------------------------------------------------------------------------------|:----------------------------------------------------------|:---------------------|:-----------|:-----------|:------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------|:------------|:--------------------------|:--------------------------|:----------------------------|:----------------------------|:------------------|:-------------------------------------|:----------|:----------|:------------|:-------------------------|:---------------------------|
| Coupled dynamics of body mass and population growth in response to environmental change  | 10.1038/nature09210        | 20651690 | 29 Coupled dynamics of body mass and population growth in response to environmental change, 2010, nature \#365papers | 2010Natur.466..482O | <http://www.nature.com/doifinder/10.1038/nature09210>       | 4f6fa50a3cf058f610003160 | 0028-0836 | 1476-4687 | Nature                        | 3           | Environmental change has altered the phenology, morphological traits and population dynamics of many species. However, the links underlying these joint responses remain largely unknown owing to a paucity of long-term data and the lack of an appropriate analytical framework. Here we investigate the link between phenotypic and demographic responses to environmental change using a new methodology and a long-term (1976-2008) data set from a hibernating mammal (the yellow-bellied marmot) inhabiting a dynamic subalpine habitat. We demonstrate how earlier emergence from hibernation and earlier weaning of young has led to a longer growing season and larger body masses before hibernation. The resulting shift in both the phenotype and the relationship between phenotype and fitness components led to a decline in adult mortality, which in turn triggered an abrupt increase in population size in recent years. Direct and trait-mediated effects of environmental change made comparable contributions to the observed marked increase in population growth. Our results help explain how a shift in phenology can cause simultaneous phenotypic and demographic changes, and highlight the need for a theory integrating ecological and evolutionary dynamics in stochastic environments.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | pubmed           | 7264069           | 6.364767530532   | 116555           | 98              | 7147917                  | 44990                 | 69.002743070528      | 9948                 | 77                  | 35042                        | 6658527                        | 6.67976925944                 | 114556                        | 98                           | 6543970                               | 44442                                   | 68.663520577845                        | 9690                                   | 78                                    | 34752                                          | article | 101553        | 1.5.4  | FALSE  | 1                         | 7                       | 1                     | 1                          | 13                      | 3                          | 13                         | 1455178091    | 60.836 | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 60.836     | <http://dx.doi.org/10.1038/nature09210>        | 1279929600    | science  | General          | 0                 | 309              | 0                | 309            | <https://altmetric-badges.a.ssl.fastly.net/?size=64&score=61&types=mbbbbtfd> | <https://altmetric-badges.a.ssl.fastly.net/?size=100&score=61&types=mbbbbtfd> | <https://altmetric-badges.a.ssl.fastly.net/?size=180&score=61&types=mbbbbtfd> | <http://www.altmetric.com/details.php?citation_id=101553> | NA                   | NA         | NA         | NA                                                                                              | NA                                                                                                             | NA                                                                                                                      | NA          | NA                        | NA                        | NA                          | NA                          | NA                | NA                                   | NA        | NA        | NA          | NA                       | NA                         |
| Stochastic Community Assembly Causes Higher Biodiversity in More Productive Environments | 10.1126/science.1187820    | 20508088 | @DrCraigMc Jon Chase has had some papers in this area. Here's one: (paywall) @ethanwhite                             | 2010Sci...328.1388C | <http://www.sciencemag.org/cgi/doi/10.1126/science.1187820> | 4f6fa4df3cf058f610001f6b | 1095-9203 | 0036-8075 | Science                       | 1           | Net primary productivity is a principal driver of biodiversity; large-scale regions with higher productivity generally have more species. This pattern emerges because beta-diversity (compositional variation across local sites) increases with productivity, but the mechanisms underlying this phenomenon are unknown. Using data from a long-term experiment in replicate ponds, I show that higher beta-diversity at higher productivity resulted from a stronger role for stochastic relative to deterministic assembly processes with increasing productivity. This shift in the relative importance of stochasticity was most consistent with the hypothesis of more intense priority effects leading to multiple stable equilibria at higher productivity. Thus, shifts in community assembly mechanisms across a productivity gradient may underlie one of the most prominent biodiversity gradients on the planet.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | pubmed           | 4680920           | 5.6987154988182  | 490656           | 89              | 4190450                  | 30551                 | 26.643469067103      | 11613                | 61                  | 18938                        | 236122                         | 4.4221538448509               | 23219                         | 90                           | 212903                                | 990                                     | 22.587763397371                        | 387                                    | 60                                    | 603                                            | article | 513292        | 1.5.4  | FALSE  | NA                        | 1                       | NA                    | NA                         | 3                       | 1                          | 3                          | 1404225266    | 9.004  | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 9.004      | <http://dx.doi.org/10.1126/science.1187820>    | 1276214400    | science  | General          | 2                 | 816              | 0                | 818            | <https://altmetric-badges.a.ssl.fastly.net/?size=64&score=10&types=bbbtt111> | <https://altmetric-badges.a.ssl.fastly.net/?size=100&score=10&types=bbbtt111> | <https://altmetric-badges.a.ssl.fastly.net/?size=180&score=10&types=bbbtt111> | <http://www.altmetric.com/details.php?citation_id=513292> | 1                    | 1325282516 | NA         | NA                                                                                              | NA                                                                                                             | NA                                                                                                                      | NA          | NA                        | NA                        | NA                          | NA                          | NA                | NA                                   | NA        | NA        | NA          | NA                       | NA                         |
| Why intraspecific trait variation matters in community ecology                           | 10.1016/j.tree.2011.01.009 | 21367482 | NA                                                                                                                   | NA                  | NA                                                          | 4f6fa5153cf058f6100036aa | 01695347  | 0169-5347 | Trends in Ecology & Evolution | 2           | Natural populations consist of phenotypically diverse individuals that exhibit variation in their demographic parameters and intra- and inter-specific interactions. Recent experimental work indicates that such variation can have significant ecological effects. However, ecological models typically disregard this variation and focus instead on trait means and total population density. Under what situations is this simplification appropriate? Why might intraspecific variation alter ecological dynamics? In this review we synthesize recent theory and identify six general mechanisms by which trait variation changes the outcome of ecological interactions. These mechanisms include several direct effects of trait variation per se and indirect effects arising from the role of genetic variation in trait evolution.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | pubmed           | 7455222           | 6.4766214020979  | 351394           | 95              | 7104165                  | 1690                  | 14.963259917111      | 308                  | 81                  | 1382                         | 70849                          | 5.7718318936314               | 3597                          | 94                           | 67252                                 | 24                                      | 10.614608695652                        | 5                                      | 79                                    | 19                                             | article | 220221        | 1.5.4  | FALSE  | NA                        | 2                       | NA                    | NA                         | 11                      | 7                          | 9                          | 1449066060    | 20.43  | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 20.43      | <http://dx.doi.org/10.1016/j.tree.2011.01.009> | 1298937600    | NA       | NA               | 5                 | 1628             | 0                | 1633           | <https://altmetric-badges.a.ssl.fastly.net/?size=64&score=21&types=bbtttttt> | <https://altmetric-badges.a.ssl.fastly.net/?size=100&score=21&types=bbtttttt> | <https://altmetric-badges.a.ssl.fastly.net/?size=180&score=21&types=bbtttttt> | <http://www.altmetric.com/details.php?citation_id=220221> | NA                   | 1313082277 | PMC3088364 | Nice paper: Why infraspecific trait variation matters in community ecology (Bolnick et al 2011) | @JacquelynGill Think I owe u a recap the sess on intraspecific variation; but their TREE piece is a good start | Bolnick onto ecological reasons: Jensen's inequality; 'portfolio effect' (bet hedge), or size-dep food web. See \#esa11 | 5           | Biological Sciences       | Environmental Sciences    | era                         | era                         | Life Sciences     | Agricultural and Biological Sciences | NA        | NA        | NA          | NA                       | NA                         |
| Enemies Maintain Hyperdiverse Tropical Forests                                           | 10.1086/664183             | 22322219 | \#Janzen-Connell \#tropicalforestecology \#diversity \#AmNat \#goodpapers                                            | NA                  | <http://www.journals.uchicago.edu/doi/10.1086/664183>       | 4f6fa4e83cf058f61000222c | 00030147  | 15375323  | American Naturalist           | 1           | Understanding tropical forest tree diversity has been a major challenge to ecologists. In the absence of compensatory mechanisms, two powerful forces, drift and competition, are expected to erode diversity quickly, especially in communities containing scores or hundreds of rare species. Here, I review evidence bearing on four compensatory mechanisms that have been subsumed under the terms "density dependence" or "negative density dependence": (1) intra- and (2) interspecific competition and the action of (3) density-responsive and (4) distance-responsive biotic agents, as postulated by Janzen and Connell. To achieve ontological integration, I examine evidence based on studies employing seeds, seedlings, and saplings. Available evidence points overwhelmingly to the action of both host-generalist and host-restricted biotic agents as causing most seed and seedling mortality, implying that species diversity is maintained via top-down forcing. The overall effect of most host-generalist seed predators and herbivores is to even out the distribution of surviving propagules. Spatially restricted recruitment appears to result mainly, if not exclusively, from the actions of host-restricted agents, principally microarthropods and fungi, that attack hosts in a distance-dependent fashion as Janzen and Connell proposed. Near total failure of propagules close to reproductive conspecifics ensures that successful reproduction occurs through a scant rain of dispersed seeds. Densities of dispersed seeds and seedlings arising from them are so low as to generally preclude the operation of density dependence, at least during early ontogenetic stages. I conclude that Janzen and Connell were essentially correct and that diversity maintenance results from top-down forcing acting in a spatially nonuniform fashion. | pubmed           | 4507072           | 5.1258131841361  | 1650467          | 62              | 2824446                  | 1439                  | 5.7728484005563      | 919                  | 34                  | 502                          | 234126                         | 4.3073090528567               | 59976                         | 73                           | 172086                                | 25                                      | 3.97075                                | 9                                      | 64                                    | 16                                             | article | 601635        | 1.5.4  | FALSE  | NA                        | NA                      | NA                    | NA                         | 3                       | 2                          | 3                          | 1334188800    | 2.5    | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 0          | 2.5        | <http://dx.doi.org/10.1086/664183>             | 1330560000    | NA       | NA               | 0                 | 239              | 0                | 239            | <https://altmetric-badges.a.ssl.fastly.net/?size=64&score=3&types=ttttt111>  | <https://altmetric-badges.a.ssl.fastly.net/?size=100&score=3&types=ttttt111>  | <https://altmetric-badges.a.ssl.fastly.net/?size=180&score=3&types=ttttt111>  | <http://www.altmetric.com/details.php?citation_id=601635> | 1                    | 1329155066 | NA         | NA                                                                                              | NA                                                                                                             | NA                                                                                                                      | NA          | NA                        | NA                        | NA                          | NA                          | Medicine          | Health Sciences                      | 0003-0147 | 1537-5323 | 1           | Biological Sciences      | era                        |

Further reading
---------------

-   [Metrics: Do metrics matter?](http://www.nature.com/news/2010/100616/full/465860a.html)
-   [The altmetrics manifesto](http://altmetrics.org/manifesto/)

To cite package ‘rAltmetric’ in publications use:

``` coffee
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
