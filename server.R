library(shiny)
library(ggplot2)
library(RColorBrewer)
library(tm)
library(sentimentr)
library(vctrs)

source("functions.R")

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