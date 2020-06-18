import tw_auth as tw
import pandas as import pd



# FUNCTION OF 5 MOST RECENT TWEETS WITH THE HIGHEST NUMBER OF RETWEETS

def five_most_recent_highest_retweets(query='felicidade', head=5, lang='pt', items=200):
    RETWEETS = []

    for tweet in tw.tweepy.Cursor(api.search,
                                  q=query,
                                  lang=lang,
                                  result_type='recent',
                                  tweet_mode='extended'  # collect the full text (over 140 characters)
                                  ).items(items):

        if (tweet.retweet_count > 0):
            RETWEETS.append([tweet.full_text, tweet.retweet_count])  # collect tweet text and the number of retweets

        df = pd.DataFrame(RETWEETS, columns=['tweet', 'retweet_count']).drop_duplicates()  # delete all duplicated texts
        df = df.groupby('tweet').sum()  # aggregate the same texts and adds up the number of different retweets.
        df = df.sort_values(by='retweet_count', ascending=False)  # put retweets_count in descending order

    return df.head(head)

# FUNCTION TO TRANSFORM DATA

def transform_data():

    #code

    return pass

# FUNCTION OF # MOST USED AND THEIR RELATIONSHIP

def most_hashtag():

    #code

    return pass

# FUNCTION OF MOST CITED @USER ACCOUNTS IN THE TWEETS

def most_arroba(query='felicidade -filter:retweets', lang='pt', items=100):
    TWEETS = []
    users = []

    for tweet in tw.tweepy.Cursor(api.search,
                                  q=query,
                                  lang=lang,
                                  result_type='recent',
                                  tweet_mode='extended'  # collect the full text (over 140 characters)
                                  ).items(items):

        TWEETS.append(tweet.full_text)

        for line in TWEETS:
            word_split = line.split()
            for word in word_split:
                if word.startswith("@"):
                    users.append(word)

    return pd.DataFrame(users)[0].value_counts()

# FUNCTION OF MOST USED WORDS IN TWEETS DISREGARDING STOPWORDS

def most_words():

    #code

    return pass