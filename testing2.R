doi_data <- read.csv('~/Github/ropensci/rAltmetric/dois.csv', header = T)

> doi_data
                         doi
1        10.1038/nature09210
2    10.1126/science.1187820
3 10.1016/j.tree.2011.01.009
4             10.1086/664183


library(plyr)
# First, let's get the metrics
raw_metrics <- llply(doi_data$doi, altmetrics, .progress = 'text')
# Now let's pull the data together
metric_data <- ldply(raw_metrics, altmetric_data)
# Now save this to a spreadsheet for further analysis/vizualization
dim(altmetric_data(raw_metrics[[1]]))
dim(altmetric_data(raw_metrics[[2]]))
dim(altmetric_data(raw_metrics[[3]]))
dim(altmetric_data(raw_metrics[[4]]))

