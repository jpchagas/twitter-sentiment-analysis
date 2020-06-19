import tw_auth as tw

import pandas as pd
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
                                  # collect the full text (over 140 characters)
                                  tweet_mode='extended'
                                  ).items(items):

        if ("RT @" in tweet.full_text):

            RETWEET.append([tweet.id, tweet.created_at, tweet.user.location, tweet.full_text.replace('\n', ' '),
                            tweet.retweet_count, [e['text'] for e in tweet._json['entities']['hashtags']]])

        else:

            TWEET.append([tweet.id, tweet.created_at, tweet.user.location, tweet.full_text.replace('\n', ' '),
                          tweet.retweet_count, [e['text'] for e in tweet._json['entities']['hashtags']]])

    return TWEET, RETWEET


def five_most_recent_highest_retweets(data=rtw, head=5):

    rtweets = pd.DataFrame(data, columns=[
                           'id', 'timestamp', 'location', 'tweet', 'retweet_count', 'hashtags'])
    df_five = rtweets[['tweet', 'retweet_count']
                      ].drop_duplicates()  # delete all duplicated texts
    # aggregate the same texts and adds up the number of different retweets.
    df_five = df_five.groupby('tweet').sum()
    # put retweets_count in descending order
    df_five = df_five.sort_values(by='retweet_count', ascending=False)

    return df_five.head(head)

# FUNCTION TO TRANSFORM DATA


def transform_data():

    # code

    pass

# FUNCTION OF # MOST USED AND THEIR RELATIONSHIP


def most_hashtag(df_tweets):
    import pandas as pd
    import numpy as np
    from mlxtend.frequent_patterns import apriori
    from mlxtend.preprocessing import TransactionEncoder
    from mlxtend.frequent_patterns import association_rules

    data = df_tweets.hashtags.apply(lambda x: np.nan if len(x) <= 0 else x)
    hashtags = list(data.dropna())

    te = TransactionEncoder()
    te_ary = te.fit(hashtags).transform(hashtags)
    df = pd.DataFrame(te_ary, columns=te.columns_)
    frequent_itemsets = apriori(df, min_support=0.026, use_colnames=True)

    rules = association_rules(
        frequent_itemsets, metric="lift", min_threshold=1)

    return rules


# FUNCTION OF MOST CITED @USER ACCOUNTS IN THE TWEETS


def most_arroba(data=tw):

    tw = pd.DataFrame(data, columns=[
                      'id', 'timestamp', 'location', 'tweet', 'retweet_count', 'hashtags'])

    tweets = tw['tweet']
    arroba = []

    for line in tweets:
        word_split = line.split()
        for word in word_split:
            if word.startswith("@"):
                arroba.append(word)

    top_10 = pd.DataFrame(arroba)[0].value_counts(
    ).sort_values(ascending=False).head(10)

    return top_10

# FUNCTION OF MOST USED WORDS IN TWEETS DISREGARDING STOPWORDS


def most_words(df_tweets):

    import pandas as pd
    import nltk
    import re
    import plotly

    from nltk.corpus import stopwords
    from wordcloud import WordCloud
    import matplotlib.pyplot as plt
    from nltk.tokenize import word_tokenize
    from string import punctuation

    def get_all_text(tweets):
        txt = ''
        for t in tweets:
            txt += t
        return txt

    all_text = get_all_text(df_tweets.tweet_text)

    sub_text = re.sub('[-|0-9]', '', all_text)
    sub_text = re.sub(r'[-./*_~ºª¿{}æ·?#!$&%@,":"";()\']', '', sub_text)
    sub_text = re.sub(r'http\S+', '', sub_text)
    sub_text = sub_text.lower()
    sub_text = re.sub('ai', 'ia', sub_text)
    sub_text = re.sub('mias', 'mais', sub_text)

    nltk_stopwords = nltk.corpus.stopwords.words('portuguese')
    my_stopwords = ['pra', 'pro', 'tb', 'vc', 'aí', 'tá', 'ah',
                    'eh', 'oh', 'msm', 'q', 'r', 'lá', 'ue', 'ué', 'pq']

    def RemoveStopWords(text):
        stopwords = set(nltk_stopwords + my_stopwords + list(punctuation))
        word = [i for i in text.split() if not i in stopwords]
        return (" ".join(word))

    clean_txt = RemoveStopWords(sub_text)

    words = word_tokenize(clean_txt)

    return words
