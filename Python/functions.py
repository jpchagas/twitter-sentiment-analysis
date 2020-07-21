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

q_query = ' -filter:retweets'


def extract_data(query, head=5, lang='pt', items=200):
    # RETWEET = []
    TWEET = []
    for tweet in tw.tweepy.Cursor(tw.api.search,
                                  q=query+q_query,
                                  lang=lang,
                                  result_type='recent',
                                  # collect the full text (over 140 characters)
                                  tweet_mode='extended'
                                  ).items(items):
        # if ("RT @" in tweet.full_text):
        #     RETWEET.append([tweet.id, tweet.created_at, tweet.user.location, tweet.full_text.replace('\n', ' '),
        #                                   tweet.retweet_count, [e['text'] for e in tweet._json['entities']['hashtags']]])
        # else:
        TWEET.append([tweet.id, tweet.created_at, tweet.user.location, tweet.full_text.replace('\n', ' '),
                      tweet.retweet_count, [e['text'] for e in tweet._json['entities']['hashtags']]])
        TW = pd.DataFrame(TWEET, columns=[
                          'id', 'timestamp', 'location', 'tweet', 'Retweets', 'hashtags'])
        # rtw = pd.DataFrame(data, RETWEET=['id', 'timestamp', 'location', 'tweet', 'retweet_count', 'hashtags'])
    return TW


def five_most_recent_highest_retweets(tw, head=5):

    # delete all duplicated texts
    df_five = tw[['tweet', 'Retweets']].drop_duplicates()
    # aggregate the same texts and adds up the number of different retweets.
    df_five = df_five.groupby('tweet').sum()
    # put retweets_count in descending order
    df_five = df_five.sort_values(by='Retweets', ascending=False).head(head)

    return df_five


# FUNCTION OF # MOST USED AND THEIR RELATIONSHIP


def most_hashtag(df_tweets):
    import pandas as pd
    import numpy as np
    from mlxtend.frequent_patterns import apriori
    from mlxtend.preprocessing import TransactionEncoder
    from mlxtend.frequent_patterns import association_rules

    data = df_tweets.hashtags.apply(lambda x: np.nan if len(x) <= 0 else x)
    all_hashtags = list(data.dropna())

    hashtags = []
    for i in all_hashtags:
        for j in i:
            hashtags.append(j)

    hash_str = ''
    for i in hashtags:
        hash_str += i + ' '

        hash_str = hash_str.lower()
        hashtags2 = hash_str.split()

    freq = FreqDist(hashtags2)
    hash_most_freq = pd.DataFrame(data=freq.most_common(
        10), columns=['Hashtag', 'Frequency'])
    list_freq = list(hash_most_freq.Hashtag)

    all_hashtags_lower = [[h.lower() for h in line] for line in all_hashtags]

    def select_hashtag(freq, all_hash):
        select = []

        for list_hash in all_hash:
            for f in freq:
                if (len(list_hash) >= 2 and (f in list_hash)):
                    select.append(list_hash)
                    break
                else:
                    pass
        return select

    select = select_hashtag(list_freq, all_hashtags_lower)

    te = TransactionEncoder()
    te_ary = te.fit(select).transform(select)
    df = pd.DataFrame(te_ary, columns=te.columns_)
    frequent_itemsets = apriori(df, min_support=0.2, use_colnames=True)

    rules = association_rules(
        frequent_itemsets, metric="lift", min_threshold=1)

    return rules


# FUNCTION OF MOST CITED @USER ACCOUNTS IN THE TWEETS


def most_arroba(data):

    tweets = data['tweet']
    arroba = []

    for line in tweets:
        word_split = line.split()
        for word in word_split:
            if word.startswith("@"):
                arroba.append(word)

    top_10 = pd.DataFrame(arroba, columns=['count'])[
        'count'].value_counts().sort_values(ascending=False).head(10)

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

    all_text = get_all_text(df_tweets.tweet)

    sub_text = re.sub('[-|0-9]', '', all_text)
    sub_text = re.sub(r'[-./*_~ºª¿{}æ·?#!$&%@,":"";()\']', '', sub_text)
    sub_text = re.sub(r'http\S+', '', sub_text)
    sub_text = sub_text.lower()
    sub_text = re.sub('ai', 'ia', sub_text)

    nltk_stopwords = nltk.corpus.stopwords.words('portuguese')
    my_stopwords = ['pra', 'pro', 'tb', 'vc', 'aí', 'tá', 'ah',
                    'eh', 'oh', 'msm', 'q', 'r', 'lá', 'ue', 'ué', 'pq']

    s = pd.read_csv('../portuguese_stopwords.txt', header=None)
    stop = s.values.tolist()
    stopwords2 = []
    for i in stop:
        stopwords2.append(i[0])

    def RemoveStopWords(text):
        stopwords = set(nltk_stopwords + my_stopwords +
                        stopwords2 + list(punctuation))
        word = [i for i in text.split() if not i in stopwords]
        return (" ".join(word))

    clean_txt = RemoveStopWords(sub_text)

    words = word_tokenize(clean_txt)

    return words
