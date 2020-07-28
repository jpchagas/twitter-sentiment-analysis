#install.packages("shiny")
#install.packages('tm')
#install.packages('sentimentr')
#install.packages('Rstem',repos = "http://www.omegahat.net/R")
#install.packages('ggplot2')
#install.packages('vctrs')
#install.packages('modelr')


library(shiny)
library(ggplot2)
library(RColorBrewer)
library(tm)
library(sentimentr)
library(vctrs)
#library(Rstem)

source("functions.R")


#CREATE SHINY APP

port <- Sys.getenv('PORT')

shiny::runApp(
  appDir = getwd(),
  host = '0.0.0.0',
  port = as.numeric(port)
)