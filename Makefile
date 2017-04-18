all:
	Rscript -e "devtools::document(); rhub::check(); rmarkdown::render('README.Rmd')"
