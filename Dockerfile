## Emacs, make this -*- mode: sh; -*-

## start with the Docker 'base R' Debian-based image
FROM rocker/r-devel-ubsan-clang:latest

MAINTAINER "Mario Annau" mario.annau@gmail.com

ENV CC="clang-4.0 -fsanitize=address,undefined -fno-sanitize=float-divide-by-zero -fno-omit-frame-pointer"
ENV CFLAGS="-fsanitize=address,undefined -fno-sanitize=float-divide-by-zero -fno-omit-frame-pointer"
ENV HDF5_RELEASE_URL="https://support.hdfgroup.org/ftp/HDF5/releases"
ENV HDF5_VERSION=1.10.1
ENV LD_LIBRARY_PATH=/usr/local/lib

# Install apt dependencies
RUN apt-get update -qq \
	&& apt-get install -t unstable -y --no-install-recommends \
	  wget \
    libxml2-dev

# Install HDF5 release from source
#RUN wget "$HDF5_RELEASE_URL/hdf5-${HDF5_VERSION%.*}/hdf5-$HDF5_VERSION/src/hdf5-$HDF5_VERSION.tar.gz" \
#  && tar -xzf "hdf5-$HDF5_VERSION.tar.gz" \
#  && cd "hdf5-$HDF5_VERSION"

# Use HDF5 Release version 1.10.1 with ASAN fixes
RUN git clone -b hdf5_1_10_1 https://github.com/mannau/hdf5.git hdf5
  && cd hdf5
  
RUN ASAN_OPTIONS=detect_leaks=0 \
    CC="clang-4.0 -fsanitize=address,undefined -fno-sanitize=float-divide-by-zero -fno-omit-frame-pointer" \
    ./configure --prefix=/usr/local

RUN ASAN_OPTIONS=detect_leaks=0 make install && cd ..

RUN ASAN_OPTIONS=detect_leaks=0 \
    Rdevel -e "install.packages(c('Rcpp', 'testthat', 'roxygen2', 'highlight', 'zoo', 'microbenchmark', 'knitr', 'rmarkdown', 'nycflights13', 'bit64'))"
