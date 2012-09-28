![altmetric.com](https://raw.github.com/ropensci/rAltmetric/master/altmetric_logo_title.png) 
# rAltmetric

This package provides a way to programmatically way to query and analyze data from [altmetric.com](http://altmetric.com) for metrics on any publication. The package is pretty straightforward and has only a single function to download metrics. Soon I will include generic methods to visualize the data to complete the package. Until those are finished, you cannot install the package. But sourcing `metrics.R` should be sufficient in the meantime (make sure you load `RJSONIO`, `RCurl` and `XML` before running the function).

## Installing the package

```r
library(devtools)
install_github('rAltmetric', 'ropensci')
```

## Quick Tutorial

There was a recent paper by Acuna et al that received a lot of attention on Twitter. What was the impact of that paper?

```
library(rAltmetric)
acuna <- altmetrics('10.1038/489201a')
> acuna
Altmetrics on: "Future impact: Predicting scientific success" with doi 10.1038/489201a (altmetric_id: 942310) published in Nature.

> plot(acuna)
```

![stats for Acuna's paper](https://raw.github.com/ropensci/rAltmetric/master/acuna.png)


Questions, comments, features requests and issues should go [here](https://github.com/ropensci/rAltmetric/issues/)