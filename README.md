![altmetric.com](https://raw.github.com/ropensci/rAltmetric/master/altmetric_logo_title.png) 
# rAltmetric

This package provides a way to programmatically query and analyze data from [altmetric.com](http://altmetric.com) for metrics on any publication. The package is pretty straightforward and has only a single function to download metrics. It also includes generic S3 methods to visualize the data.

# Installing the package

```r
# If you don't already have the devtools library, run
install.packages('devtools')

library(devtools)
install_github('rAltmetric', 'ropensci')
```

# Quick Tutorial

## Obtaining metrics
There was a recent paper by Acuna et al that received a lot of attention on Twitter. What was the impact of that paper?

```r
library(rAltmetric)
acuna <- altmetrics('10.1038/489201a')
 acuna
Altmetrics on: "Future impact: Predicting scientific success" with doi 10.1038/489201a (altmetric_id: 942310) published in Nature.
  value    names
1     8    Feeds
2     1  Google+
3   170    Cited
4   154   Tweets
5   163 Accounts

```


## Data
To obtain the metrics in tabular form for further processing, run any object of class through `altmetric_data()` to get data that can easily be written to disk as a spreadsheet.

```r
> altmetric_data(acuna)
altmetric_data(acuna)
                                         title
1 Future impact: Predicting scientific success
              doi   nlmid            altmetric_jid     issns
1 10.1038/489201a 0410462 4f6fa50a3cf058f610003160 0028-0836
  journal altmetric_id schema is_oa cited_by_feeds_count
1  Nature       942310  1.5.4 FALSE                  173
  cited_by_gplus_count cited_by_posts_count
1                  173                  173
  cited_by_tweeters_count cited_by_accounts_count   score
1                     156                     166 184.598
  mendeley connotea citeulike pub sci com doc
1        0        0        11  62  84   6   8
                                                                url
1 http://www.nature.com/nature/journal/v489/n7415/full/489201a.html
    added_on published_on subjects scopus_subjects
1 1347471425   1347404400  science         General
  last_updated readers_count X1 count_all count_journal
1   1348828350            11  1    754555         13972
  count_similar_age_1m count_similar_age_3m
1                22408                56213
  count_similar_age_journal_1m count_similar_age_journal_3m
1                          508                         1035
  rank_all rank_journal rank_similar_age_1m
1   754043        13759               22339
  rank_similar_age_3m rank_similar_age_journal_1m
1               56074                         459
  rank_similar_age_journal_3m pct_all pct_journal
1                         947   99.93       98.48
  pct_similar_age_1m pct_similar_age_3m
1              99.69              99.75
  pct_similar_age_journal_1m pct_similar_age_journal_3m
1                      90.35                      91.50
                                              details_url
1 http://www.altmetric.com/details.php?citation_id=942310
```

You can save these data into a nice spreadsheet format:

```
acuna_data <- altmetric_data(acuna)
write.csv(acuna_data, file = 'acuna_altmetrics.csv')
```

## Visualization
For any altmetric object you can quickly visualize the statistics with a generic plot function. The plot overlays the Altmetric donut on top. If you prefer a customized plot, just work with the raw data generated from `almetric_data()`

```
> plot(acuna)
```

![stats for Acuna's paper](https://raw.github.com/ropensci/rAltmetric/master/acuna.png)



Questions, comments, features requests and issues should go [here](https://github.com/ropensci/rAltmetric/issues/)