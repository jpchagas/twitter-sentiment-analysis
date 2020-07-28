#install.packages("shiny")
#install.packages('tm')
#install.packages('sentimentr')
#install.packages('Rstem',repos = "http://www.omegahat.net/R")
#install.packages('ggplot2')
#install.packages('vctrs')
#install.packages('modelr')


library(shiny)
library(ggplot2)
library(RColorBrewer)
library(tm)
library(sentimentr)
library(vctrs)
#library(Rstem)

source("functions.R")


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


server <- function(input, output) {
    
    observeEvent(input$id_btn_search, {
      
      if (input$id_txt_search != "") {
       
        tw <- extract_data(input$id_txt_search)
        write_as_csv(tw, file_name = 'Tweets.csv')
        tw <-  read_twitter_csv(file = 'Tweets.csv')
        
        tw_five <- five_most_recent_highest_retweets(tw)
        
        output$moreControls <- renderUI({
          geraViewTopTweets(tw_five)
        })
        
        output$usuario <- renderPlot({
          
          ggplot(data=most_arroba(tw), aes(x=reorder(Usuario, +Frequencia), y=Frequencia)) +
            geom_bar(stat="identity", fill='lightblue') +
            xlab('Usuários') + 
            ylab('Citações') + 
            theme_minimal(base_size = 12) +
            coord_flip() 
          
        })
        
        
        output$palavras <- renderPlot({
          ggplot(data=most_words(tw), aes(x=reorder(Palavra, +Frequencia), y=Frequencia)) +
            geom_bar(stat="identity", fill='lightblue') +
            xlab('Palavras') + 
            ylab('Citações') + 
            theme_minimal(base_size = 12) +
            coord_flip() 
          
        })
        
        output$hashtag <- renderPlot({
          hashtags_relationships(tw)
        })
        
        
      }
    })
  }

shinyApp(ui = ui, server = server)