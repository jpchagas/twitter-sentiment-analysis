# init.R
#
# Example R code to install packages if not already installed
#



my_packages = c("shiny","tm","sentimentr","Rstem","ggplot2","vctrs","modelr","rtweet","plyr","stringr","dplyr","tm","wordcloud2","tidyverse","splitstackshape","testthat")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

invisible(sapply(my_packages, install_if_missing))