
# start from the rocker/r-ver:3.5.0 image
FROM rocker/r-ver:3.5.0
MAINTAINER André Calero Valdez <andrecalerovaldez@gmail.com>

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev

# install plumber
#RUN R -e "install.packages('plumber')"
#RUN R -e "install.packages('recommenderlab')"
#RUN R -e "install.packages('dplyr')"

RUN install2.r plumber
RUN install2.r recommenderlab
RUN install2.r dplyr
RUN install2.r readr
RUN install2.r feather


# copy everything from the current directory into the container
# COPY / /

# open port 80 to traffic
EXPOSE 80
EXPOSE 8000

# when the container starts, start the main.R script
# ENTRYPOINT ["Rscript", "serv.r"]
