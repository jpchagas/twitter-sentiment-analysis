install.packages("rtweet")
install.packages("plyr")
install.packages("stringr")
install.packages("lubridate")

library(rtweet)
library(plyr)
library(stringr)
library(lubridate)

source("credentials.R")

twitter_token <- create_token(
  app = getApp(),
  consumer_key = getConsumerKey(),
  consumer_secret = getConsumerSecret(),
  access_token = getAcessToken(),
  access_secret = getAcessSecret())

# This function should return 2 values: the actual and formatted datetime and the 30th day ago.
get_datestimes <- function() {
  actual_datetime = format(now(), "%Y%m%d%H%M")
  thirtieth_day = format((now()-days(30)), "%Y%m%d%H%M")
  return(c(actual_datetime, thirtieth_day))
}

# The input format datetime should be a string like this: "YYYYMMDDHHMM"
extract_data <- function() {
  rt <- search_30day("covid19",
                     n = 50,
                     fromDate = get_datestimes()[2],
                     toDate = get_datestimes()[1],
                     env_name = getEnvName(),
                     token = twitter_token)
  return(as.data.frame(rt))
}

#Function to transform data
transform_data <- function() {
  
}

#Function of 5 most recent tweets with the highest number of retweets from one term
five_most_recent_highest_retweets <- function() {
  
}

#Function of # most used and their relationships
most_hashtag <- function() {
  
}

#Function of most cited @User accounts in the tweets
most_arroba <- function() {
  
}

#Function of most used words in tweets disregarding stopwords
most_arroba <- function() {
  
}