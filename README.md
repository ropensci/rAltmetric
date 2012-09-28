![altmetric.com](https://raw.github.com/ropensci/rAltmetric/master/altmetric_logo_title.png) 
# rAltmetric

This package provides a way to programmatically query and analyze data from [altmetric.com](http://altmetric.com) for metrics on any publication. The package is pretty straightforward and has only a single function to download metrics. It also includes generic S3 methods to visualize the data.

## Installing the package

```r
library(devtools)
install_github('rAltmetric', 'ropensci')
```

## Quick Tutorial

### Obtaining metrics
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


### Data

```r
> altmetric_data(acuna)
     names counts
1    Feeds      8
2  Google+      1
3    Cited    170
4   Tweets    154
5 Accounts    163
```

### Visualization

```
> plot(acuna)
```

![stats for Acuna's paper](https://raw.github.com/ropensci/rAltmetric/master/acuna.png)


Questions, comments, features requests and issues should go [here](https://github.com/ropensci/rAltmetric/issues/)