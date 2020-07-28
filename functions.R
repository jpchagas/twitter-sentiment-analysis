#install.packages('rtweet')
#install.packages('plyr')
#install.packages('stringr')
#install.packages('dplyr')
#install.packages('tm')
#install.packages('wordcloud2')
#install.packages('tidyverse')
#install.packages('splitstackshape') 

library(rtweet)
library(plyr)
library(stringr)
library(dplyr)
library(tidyverse)
library(wordcloud2)
library(tm)
library(plyr)

# Don't forget to use setwd("path/to/your/directory") to function source works!
source("credentials.R")
#source("data_example.R")

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
most_hashtag <- function(tw) {
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
  tw_count_hashtags = tibble(vector_hashtags) %>%
    count(vector_hashtags, name = "count_hashtags")
  return(tw_count_hashtags)
}

hashtags_relationships <- function(twiitter_tw) {
  
  two_or_more_hashtags = c()
  
  only_hashtags = twiitter_tw %>%
    subset(!is.na(hashtags), select = hashtags)
  
  for (element in only_hashtags) {
    if (length(element)>1) {
      two_or_more_hashtags = c(two_or_more_hashtags, element)
    }
  }
  
  # unique items
  str_un <- unique(unlist(stri_split_fixed(two_or_more_hashtags,' ')))
  
  # create a dataframe with dimensions:
  # length(shopping_items) x length(str_un)
  df <- as.data.frame(matrix(rep(0,length(str_un)*length(two_or_more_hashtags)),ncol=length(str_un)))
  names(df) <- str_un
  
  # positions of 1's in each column
  vecs <- map(str_un,grep,two_or_more_hashtags)
  
  sapply(1:length(str_un), function(x) df[,x][vecs[[x]]] <<- 1)
  df[] <- lapply(df,as.factor)
  
  rules = df %>%
    as("transactions") %>%
    apriori(parameter = list(supp = 0.001, conf = 0.7, minlen=2)) %>%
    head(n = 10, by = "confidence")
  
  #return(plot(rules, method = "graph",  engine = "graphviz"))
  return(plot(rules, method = "graph"))
}

#Function of most cited @User accounts in the tweets
most_arroba <- function(tw) {
  vector_names = c()
  names_subset = tw[, c("mentions_screen_name")]
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
  
  vector_names <- tibble(vector_names)
  colnames(vector_names) <-  c("Usuario")
  
  tw_count_names <- vector_names %>%
    cSplit('Usuario', ' ') %>%
    unlist() %>%
    tibble() %>%
    drop_na() %>%
    count(".") %>%
    arrange(desc(freq)) %>%
    slice(1:5)
  
  colnames(tw_count_names) <- c("Usuario", "Frequencia")
  
  return(tw_count_names)
}

#Function of most used words in tweets disregarding stopwords
most_words <- function(tw) {
  
  to_lower <- tolower(tw$text)
  
  stopw <- unlist(read_table(file = '../portuguese_stopwords.txt', col_names = FALSE))
  
  removes<- removeWords(to_lower, stopw)
  removes<- removeWords(removes, stopwords(kind='pt'))
  removes<- removeWords(removes, c('pra', 'pro', 'tb', 'vc', 'a', 'tÃ¡', 'ah', 'eh', 'oh', 'msm', 'q', 'r', 'lÃ¡', 'ue', 'uÃ©', 'pq', 'http', 'https', 'u', 'co', ' ', 't'))
  
  removes <- str_replace_all(removes, c('^@', '_'), '')
  
  palavras <- strsplit(removes, "\\W+")
  Words <- unlist(palavras)
  
  Words <- tibble(Words)
  colnames(Words) <-  c("Palavra")
  
  tw_count_words <- Words %>%
    cSplit('Palavra', ' ') %>%
    unlist() %>%
    tibble() %>%
    drop_na() %>%
    count(".") %>%
    arrange(desc(freq)) %>%
    slice(1:10)
  
  colnames(tw_count_words) <- c("Palavra", "Frequencia")
  
  return(tw_count_words)
}


geraViewTopTweets <- function(tw) {
  testelinha = 0
  if (dim(tw)[1] == 5) {
    linha = 5
  } else {
    linha = dim(tw)[1]
  }
  
  vetor_html = list()
  
  for (i in 1:linha){
    tweet <- tw[i, 'Tweet']
    vetor_html[[i]] <- geraHTML(tw[i,])
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
