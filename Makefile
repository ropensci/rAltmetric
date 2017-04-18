all:
	Rscript -e "devtools::document(); rhub::check(); rmarkdown::render('README.Rmd', output_format = 'all')"
	rm README.html
