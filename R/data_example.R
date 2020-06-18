#install.packages(tm)
#install.packages(dplyr)
#install.packages("wordcloud")  #wordcloud

library(tm)
library(dplyr)
library(wordcloud)  #wordcloud

df <- data.frame(c(98,68,45,30,10), c("Esse é o tweet número 1", 
                                 "Esse é o tweet número 2", 
                                 "Esse é o tweet número 3",
                                 "Esse é o tweet número 4",
                                 "Esse é o tweet número 5"))

colnames(df) <- c('Quant_Rtweets', 'Tweet')
#View(df)

words <- as.character(df$Tweet)
#words

word.corpus <- Corpus(VectorSource(words))  #Corpus

word.corpus<-word.corpus%>%
  tm_map(removePunctuation)%>% ##eliminar pontuacao
  tm_map(removeNumbers)%>% #sem numeros
  tm_map(stripWhitespace)# sem espacos

word.corpus<-word.corpus%>%
  tm_map(tolower)%>% ##make all words lowercase
  tm_map(removeWords, stopwords("por"))

word.corpus <- tm_map(word.corpus, stemDocument)

word.counts <- as.matrix(TermDocumentMatrix(word.corpus))
word.freq <- sort(rowSums(word.counts), decreasing = TRUE)
head(word.freq)

set.seed(32)

nuvem_palavras <- wordcloud(words = names(word.freq), freq = word.freq, scale = c(3, 0.5), max.words = 100, 
          random.order = TRUE)
