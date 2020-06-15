#install.packages('rtweet')
#install.packages('plyr')
#install.packages('stringr')
#install.packages("shiny")
#install.packages('tm')
#install.packages('sentimentr')
#install.packages('Rstem',repos = "http://www.omegahat.net/R")
#install.packages("shinythemes")
#install.packages(shinythemes)
#install.packages(DT)
#install.packages(wordcloud)

library(rtweet)
library(plyr)
library(stringr)
library(shiny)
library(ggplot2)
#library(tm)
#library(sentimentr)
#library(Rstem)
library(shinythemes)
library(DT)
library(wordcloud)
library(dplyr)

source(file = 'data_example.r')

twitter_token <- create_token(
  app = '',
  consumer_key = '',
  consumer_secret = '',
  access_token = '',
  access_secret = ''
  )

#search_term <- readline("Qual termo você quer buscar?")

rt <- NULL

#tw <- search_30day(q = search_term, n = 10, env_name = 'development')

#tw <- search_30day(q = search_term[1], n = 10, toDate = Sys.Date(), env_name = "research")

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
#    
#}
#
#extract_data(fDatetime = "YYYYMMDDHHMM", eDatetime = "YYYYMMDDHHMM")

extract_data <- function(search_term) {
  rt <- search_30day(search_term,
                     n = 1000,
                     #fromDate = fDatetime,
                     #toDate = eDatetime,
                     env_name = "development",
                     token = twitter_token
                    )
  return(rt)
  
}

#Function to transform data
transform_data <- function() {
  
}
  
#Function of 5 most recent tweets with the highest number of retweets from one term
# testing
five_most_recent_highest_retweets <- function(tw) {
  
  tw_temp <- tw %>%
                filter(is_retweet == FALSE & lang == 'pt') %>%
                select(text, quoted_retweet_count, user_id, screen_name) 
  
  return(as.data.frame(tw_temp))
  
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

#CREATE SHINY APP

ui <- fluidPage(
  theme = shinytheme("flatly"),
  
  fluidRow(
    
    # Application title
    titlePanel("Interactive panel for tracking tweets")
  ),
  
  fluidRow(
    
    column(3,
           textInput("id_txt_search", "Busque uma palavra ou frase:", value = "", width = NULL, placeholder = NULL)
    ),
    #column(3,
    #       textInput("id_txt_data", "A partir de:", value = "", width = NULL, placeholder = NULL)
    #),
    column(4,
           actionButton("id_btn_search", "Realizar pesquisa:")
    )
  ),
  
  #fluidRow(
  
  column(7,
         fluidRow(
           h3("# mais utilizadas"),
           imageOutput("palavras", width = 750, height = 250)
        ),
         fluidRow(
           h3("palavras mais utilizadas"),
           imageOutput("hashtag", width = 750, height = 250)
         )
  ),
  column(5,
         fluidRow(
           h3("Tweets com maior número de retweets"),
           DT::dataTableOutput("tweets") #, width = 50,  height = 50)
         ),
         fluidRow(
           h3("palavras mais utilizadas"),
           plotOutput("usuario", width = 500,  height = 250)
         )
         
  )
  
)

server <- function(input, output) {
  
  #eventReactive(id_btn_search,
  
  observeEvent(input$id_btn_search, {
  
    output$distPlot <- renderPlot({
      
      ggplot(data=df, aes(x=dose, y=len)) +
        geom_bar(stat="identity") +
        coord_flip()
      
    })
    
    #output$tweets <- renderDataTable({df})
    #output$tweets = DT::renderDataTable({
    #df
    #}, )
    
    #output$ex3 <- DT::renderDataTable(
    #  DT::datatable(iris, options = list(paging = FALSE))
    #)
    
    output$tweets <- DT::renderDataTable(
      { 
        DT::datatable(five_most_recent_highest_retweets(extract_data(input$id_txt_search)), 
                      options = list(dom = 't', paging = FALSE))
      }
      )
    
    output$palavras <- renderPlot({
      wordcloud(words = names(word.freq), freq = word.freq, max.words = 100, 
                random.order = TRUE)
    })
    
    output$hashtag <- renderPlot({
      wordcloud(words = names(word.freq), freq = word.freq, max.words = 100, 
                random.order = TRUE)
    })
    
    output$usuario <- renderPlot({
      ggplot(data=df, aes(x=Tweet, reorder(Tweet, -Quant_Rtweets), y=Quant_Rtweets)) +
        geom_bar(stat="identity") +
        coord_flip()
    })
  
  })
}

shinyApp(ui = ui, server = server)



