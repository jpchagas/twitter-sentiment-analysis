install.packages("shiny")
#install.packages('tm')
#install.packages('sentimentr')
#install.packages('Rstem',repos = "http://www.omegahat.net/R")


library(shiny)
library(ggplot2)
source("functions.R")
#library(tm)
#library(sentimentr)
#library(Rstem)


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
      #fluidRow(
      #  column(4,
      #         selectInput("man",
      #                     "Manufacturer:",
      #                     c("All",
      #                       unique(as.character(mpg$manufacturer))))
      #  ),
      #  column(4,
      #         selectInput("trans",
      #                     "Transmission:",
      #                     c("All",
      #                       unique(as.character(mpg$trans))))
      #  ),
      #  column(4,
      #         selectInput("cyl",
      #                     "Cylinders:",
      #                     c("All",
      #                       unique(as.character(mpg$cyl))))
       # )
      #),
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



