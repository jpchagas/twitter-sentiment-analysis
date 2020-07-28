library(shiny)
library(ggplot2)
library(RColorBrewer)
library(tm)
library(sentimentr)
library(vctrs)

ui <- fluidPage(theme = "bootstrap.css", 
  titlePanel("DSA Mentoring: Twitter Sentiment Analisys"),
  
  tags$style(type='text/css', "#id_btn_search { width:100%; margin-top: 20px}"),
  
  # Application title
  #titlePanel("Interactive panel for tracking tweets"),
  
  sidebarLayout(
    
    sidebarPanel(
      fluidRow(
        column(6, 
               textInput("id_txt_search", "Busque uma palavra ou frase:")
        ),
        column(6, 
               actionButton("id_btn_search", "Realizar pesquisa:", class='btn btn-primary')
        )
      ),
      fluidRow(
        column(12, 
               uiOutput("moreControls")
        )
      )
    ),
    
    mainPanel(
      #fluidRow(
      #  column(12,
      #  h4("Tweets com maior número de retweets"),
      #  dataTableOutput("tweets")
      #  )
      #),
      #hr(),
      
      fluidRow(
        column(width = 12,
               h4("@Users mais citados"),
               plotOutput("usuario", height = 175)   
        )
      ),
      br(),
      fluidRow(
        column(width = 6,
               h4("# mais utilizadas e seus relacionamentos"),
               plotOutput("hashtag") #
               #imageOutput("palavras") #, width = 750, height = 250)
        ),
        column(width = 6, 
               h4("palavras mais utilizadas"),
               plotOutput("palavras")
               #imageOutput("hashtag") #, width = 750, height = 250)
        )
      )
    )
  )
  )