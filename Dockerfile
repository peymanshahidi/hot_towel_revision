FROM ubuntu:latest
RUN apt-get update
RUN apt-get -y install tzdata
RUN apt-get -y install pkg-config
RUN apt-get -y install r-recommended
RUN apt-get -y install texlive-full
RUN apt-get -y install make
RUN apt-get -y install libcurl4-gnutls-dev

RUN apt-get -y install build-essential
RUN apt-get -y install libxml2-dev
RUN apt-get -y install libssl-dev
RUN apt-get -y install libnlopt-dev

#setup R configs
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile

RUN Rscript -e 'install.packages("devtools")'
RUN Rscript -e 'library(devtools); install_github("johnjosephhorton/JJHmisc")'


RUN mkdir hot_towel
COPY . hot_towel/ 
RUN cd hot_towel/analysis && ./install_HotTowelR.R
