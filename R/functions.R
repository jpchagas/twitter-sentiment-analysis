#install.packages('rtweet')
#install.packages('plyr')
#install.packages('stringr')
#install.packages('dplyr')
#install.packages('tidyverse')


library(rtweet)
library(plyr)
library(stringr)
library(dplyr)
library(tidyverse)


# Don't forget to use setwd("path/to/your/directory") to function source works!
source("credentials.R")
source("data_example.R")

twitter_token <- create_token(
  app = getApp(),
  consumer_key = getConsumerKey(),
  consumer_secret = getConsumerSecret(),
  access_token = getAcessToken(),
  access_secret = getAcessSecret())

# This function aim treat the input text from shiny and returns the the string 
# ready to the extract tweets function
treat_input <- function(input_words) {
  if (length(input_words) == 1) {
    return(input_words[1])
  } else {
    concat_words = paste(input_words, collapse = " OR ")
    return(concat_words)
  }
}

# The input format datetime should be a string like this: "YYYYMMDDHHMM"
extract_data <- function(text) {
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


#Function of 5 most recent tweets with the highest number of retweets from one term
five_most_recent_highest_retweets <- function(tw) {
  
  print(head(tw))
  
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
  hashtags_subset %>%
    subset(subset = !is.na(hashtags), select = hashtags)
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

hashtags_relationships <- function(twiitter_df) {
  two_or_more_hashtags = c()
  only_hashtags = twiitter_df %>%
    subset(!is.na(hashtags), select = hashtags)
  for (element in only_hashtags) {
    if (length(element)>1) {
      two_or_more_hashtags = c(two_or_more_hashtags, element)
    }
  }
  rules = two_or_more_hashtags %>%
    as("transactions") %>%
    apriori(parameter = list(supp = 0.001, conf = 0.7, minlen=2)) %>%
    head(n = 10, by = "confidence")
  return(plot(rules, method = "graph",  engine = "htmlwidget"))
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
