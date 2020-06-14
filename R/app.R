install.packages('rtweet')
install.packages('plyr')
install.packages('stringr')
install.packages("shiny")
#install.packages('tm')
#install.packages('sentimentr')
#install.packages('Rstem',repos = "http://www.omegahat.net/R")

library(rtweet)
library(plyr)
library(stringr)
library(shiny)
library(ggplot2)
#library(tm)
#library(sentimentr)
#library(Rstem)


twitter_token <- create_token(
  app = "",
  consumer_key = "",
  consumer_secret = "",
  access_token = "",
  access_secret = "")

search_term <- readline("Qual termo você quer buscar?")

rt <- NULL

tw <- search_30day(q = search_term[1],n = 10)

# Check if  the from datetime isn't before to 30 days
# This function it's necessary 'cuz the function to extract tweets, has a 30 days of limit range
check_datetime <- function(eDatetime) {
  
}

# The input format datetime should be a string like this: "YYYYMMDDHHMM"
extract_data <- function(fDatetime, eDatetime) {
  rt <- search_30day(search_term[1],
                     n = 10,
                     fromDate = fDatetime,
                     toDate = eDatetime,
                     env_name = "",
                     token = twitter_token)
  return(rt)
    
}

extract_data(fDatetime = "YYYYMMDDHHMM", eDatetime = "YYYYMMDDHHMM")

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

#CREATE SHINY APP

ui <- fluidPage(
  titlePanel("DSA Mentoring: Twitter Sentiment Analisys"),
  
  
  sidebarLayout(
    
    sidebarPanel(
      # Copy the line below to make a text input box
      textInput("text", label = h3("Text input"), value = "Enter text..."),
      
      hr(),
      fluidRow(column(3, verbatimTextOutput("value")))
    ),
    
    mainPanel(
      fluidRow(
        column(4,
               selectInput("man",
                           "Manufacturer:",
                           c("All",
                             unique(as.character(mpg$manufacturer))))
        ),
        column(4,
               selectInput("trans",
                           "Transmission:",
                           c("All",
                             unique(as.character(mpg$trans))))
        ),
        column(4,
               selectInput("cyl",
                           "Cylinders:",
                           c("All",
                             unique(as.character(mpg$cyl))))
        )
      ),
      # Create a new row for the table.
      DT::dataTableOutput("table")
    )
  )
  
  # Create a new Row in the UI for selectInputs
  
)

server <- function(input, output) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- search_tweets(q = input$text,n = 10,lang = "pt")
    #if (input$man != "All") {
    #  data <- data[data$manufacturer == input$man,]
    #}
    #if (input$cyl != "All") {
    #  data <- data[data$cyl == input$cyl,]
    #}
    #if (input$trans != "All") {
    #  data <- data[data$trans == input$trans,]
    #}
    data
  }))
  
  #output$value <- renderPrint({ input$text })
  
}

shinyApp(ui = ui, server = server)



