install.packages('rtweet')
install.packages('plyr')
install.packages('stringr')

library(rtweet)
library(plyr)
library(stringr)

source("credentials.R")

twitter_token <- create_token(
  app = getApp(),
  consumer_key = getConsumerKey(),
  consumer_secret = getConsumerSecret(),
  access_token = getAcessToken(),
  access_secret = getAcessSecret())

# Check if  the from datetime isn't before to 30 days
# This function it's necessary 'cuz the function to extract tweets, has a 30 days of limit range
check_datetime <- function(eDatetime) {
  
}

# The input format datetime should be a string like this: "YYYYMMDDHHMM"
#extract_data <- function(fDatetime, eDatetime) {
#  rt <- search_30day(search_term[1],
#                     n = 10,
#                     fromDate = fDatetime,
#                     toDate = eDatetime,
#                     env_name = "",
#                     token = twitter_token)
#  return(rt)
#}

#extract_data(fDatetime = "YYYYMMDDHHMM", eDatetime = "YYYYMMDDHHMM")


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