## Emacs, make this -*- mode: sh; -*-

## start with the Docker 'base R' Debian-based image
FROM rocker/r-devel-ubsan-clang:latest

MAINTAINER "Mario Annau" mario.annau@gmail.com

RUN apt-get update -qq \
	&& apt-get install -t unstable -y --no-install-recommends \
		libhdf5-dev \
    libxml2-dev

RUN ASAN_OPTIONS=detect_leaks=0 \
    Rdevel -e "install.packages(c('Rcpp', 'testthat', 'roxygen2', 'highlight', 'zoo', 'microbenchmark', 'knitr', 'rmarkdown', 'nycflights13', 'bit64'))"
