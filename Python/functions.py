import tw_auth as tw

import pandas as import pd
import numpy as np

import plotly
import matplotlib.pyplot as plt


from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from nltk import FreqDist

from wordcloud import WordCloud
from string import punctuation


# FUNCTION OF 5 MOST RECENT TWEETS WITH THE HIGHEST NUMBER OF RETWEETS

query = 'covid'

def extract_data(query, head=5, lang='pt', items=500):
    
    RETWEET = []
    TWEET = []

    for tweet in tw.tweepy.Cursor(tw.api.search,
                                  q=query,
                                  lang=lang,
                                  result_type='recent',
                                  tweet_mode='extended'  # collect the full text (over 140 characters)
                                  ).items(items):

        if ("RT @" in tweet.full_text):

            RETWEET.append([tweet.id, tweet.created_at, tweet.user.location, tweet.full_text.replace('\n', ' '), 
                                          tweet.retweet_count, [e['text'] for e in tweet._json['entities']['hashtags']]])

        else:

            TWEET.append([tweet.id, tweet.created_at, tweet.user.location, tweet.full_text.replace('\n', ' '), 
                                          tweet.retweet_count, [e['text'] for e in tweet._json['entities']['hashtags']]])
        
    return TWEET, RETWEET


def five_most_recent_highest_retweets(data = rtw, head=5):
    
    rtweets = pd.DataFrame(data, columns=['id', 'timestamp', 'location', 'tweet', 'retweet_count', 'hashtags'])
    df_five = rtweets[['tweet', 'retweet_count']].drop_duplicates() # delete all duplicated texts
    df_five = df_five.groupby('tweet').sum() # aggregate the same texts and adds up the number of different retweets.
    df_five = df_five.sort_values(by='retweet_count', ascending = False) # put retweets_count in descending order

    return df_five.head(head)

# FUNCTION TO TRANSFORM DATA

def transform_data():

    #code

    pass

# FUNCTION OF # MOST USED AND THEIR RELATIONSHIP

def most_hashtag():

    #code

    pass

# FUNCTION OF MOST CITED @USER ACCOUNTS IN THE TWEETS

def most_arroba(data = tw):

    tw = pd.DataFrame(data, columns=['id', 'timestamp', 'location', 'tweet', 'retweet_count', 'hashtags'])

    tweets = tw['tweet']
    arroba = []

    for line in tweets:
        word_split = line.split()
        for word in word_split:
            if word.startswith("@"):
                arroba.append(word)

    top_10 = pd.DataFrame(arroba)[0].value_counts().sort_values(ascending=False).head(10)

    return top_10

# FUNCTION OF MOST USED WORDS IN TWEETS DISREGARDING STOPWORDS

def most_words():

    #code

    pass