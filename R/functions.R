#install.packages('rtweet')
#install.packages('plyr')
#install.packages('stringr')
#install.packages('dplyr')

library(rtweet)
library(plyr)
library(stringr)
library(dplyr)

# Don't forget to use setwd("path/to/your/directory") to function source works!
source("credentials.R")
source("data_example.R")

twitter_token <- create_token(
  app = getApp(),
  consumer_key = getConsumerKey(),
  consumer_secret = getConsumerSecret(),
  access_token = getAcessToken(),
  access_secret = getAcessSecret())

# The input format datetime should be a string like this: "YYYYMMDDHHMM"
extract_data <- function(text) {
  #rt <- search_tweets(q = text,n = 10,lang = "pt")
   rt <- search_30day(text,
                     n = 1000,
                     fromDate = Sys.Date()-30,
                     toDate = Sys.Date(),
                     env_name = getEnvName(),
                     token = twitter_token)
   
  rt <- rt %>%
    filter(is_retweet == FALSE & lang == 'pt')
    
  return(rt)
}

#dt <- extract_data("Corona V??rus")

#View(dt)

#Function to transform data
#transform_data <- function(tw) {
#
#}

#Function of 5 most recent tweets with the highest number of retweets from one term
five_most_recent_highest_retweets <- function(tw) {
  
  tw_temp <- tw %>%
    
    select(screen_name, urls_t.co, text, quoted_retweet_count) %>%
    arrange(desc(quoted_retweet_count)) %>%
    mutate_if(is.factor, as.character) %>%
    slice(1:5)
  
  colnames(tw_temp) <- c('Usuario', 'URL', 'Tweet','N_Retweets')
  
  return(tw_temp)
  
}

#Function of # most used and their relationships
most_hashtag <- function(twitter_df) {
  vector_hashtags = c()
  hashtags_subset = twitter_df[, c("hashtags")]
  hashtags_subset = hashtags_subset[!is.na(hashtags_subset$hashtags),]
  for (hashtags in hashtags_subset) {
    if (length(hashtags) > 1) {
      for (element in hashtags) {
        vector_hashtags = c(vector_hashtags, element)
      }
    } else {
      vector_hashtags = c(vector_hashtags, names)
    }
  }
  df_count_hashtags = tibble(vector_hashtags) %>%
    count(vector_hashtags, name = "count_hashtags")
  return(df_count_hashtags)
}

#Function of most cited @User accounts in the tweets
most_arroba <- function(twitter_df) {
  vector_names = c()
  names_subset = twitter_df[, c("mentions_screen_name")]
  names_subset = names_subset[!is.na(names_subset$mentions_screen_name),]
  for (names in names_subset) {
    if (length(names) > 1) {
      for (element in names) {
        vector_names = c(vector_names, element)
      }
    } else {
        vector_names = c(vector_names, names)
    }
  }
  df_count_names = tibble(vector_names) %>% count(vector_names, name = "count_names")
  return(df_count_names)
}

#Function of most used words in tweets disregarding stopwords
most_words <- function() {
  
}

geraViewTopTweets <- function(df) {
  testelinha = 0
  if (dim(df)[1] == 5) {
    linha = 5
  } else {
    linha = dim(df)[1]
  }
  
  vetor_html = list()
  
  for (i in 1:linha){
    tweet <- df[i, 'Tweet']
    vetor_html[[i]] <- geraHTML(df[i,])
  }
  
  return (vetor_html)
  
}

geraHTML <- function(tweet_linha){
  return(
    tags$div(class="list-group",
             tags$a(href=tweet_linha['URL'], class="list-group-item list-group-item-action flex-column align-items-start active",
                    tags$div(class="d-flex w-100 justify-content-between",
                             tags$h5(class="mb-1", tweet_linha['Usuario']),
                             tags$small(paste(as.character(tweet_linha['N_Retweets']),' retweets'))
                    ),                        
                    fluidRow(
                      column(12,
                             tags$p(tweet_linha['Tweet'])
                      )
                    )                        
             )
    ))
}
