#install.packages("shiny")
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
               plotOutput("usuario", height = 200)   
        ),
      ),
      fluidRow(
        column(width = 6,
               h4("# mais utilizadas"),
               plotOutput("palavras") #
               #imageOutput("palavras") #, width = 750, height = 250)
        ),
        column(width = 6, 
               h4("palavras mais utilizadas"),
               plotOutput("hashtag") #
               #imageOutput("hashtag") #, width = 750, height = 250)
        )
      )
    )
  )
  )


server <- function(input, output) {
    
    observeEvent(input$id_btn_search, {
      
      #tw <- extract_data(input$id_txt_search)
      tw <- read.csv2(file = 'Tweets.csv', encoding = 'UTF-8')
      
      tw_five <- five_most_recent_highest_retweets(tw)
      
      output$moreControls <- renderUI({
        geraViewTopTweets(tw_five)
      })
      
      output$distPlot <- renderPlot({
        
        ggplot(data=df, aes(x=dose, y=len)) +
          geom_bar(stat="identity") +
          coord_flip()
        
      })
      
      
      output$tweets <-renderTable(
        tw_five,
        options = list(dom = 't', 
                       paging = FALSE
        ))
      
      
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



