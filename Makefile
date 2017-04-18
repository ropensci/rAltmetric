all:
	Rscript -e "devtools::document(); rhub::check(); rmarkdown::render('README.Rmd', output_format = 'all'); pkgdown::build_site()"
	rm README.html
