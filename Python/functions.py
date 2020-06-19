import tw_auth as tw
import pandas as import pd

# FUNCTION OF 5 MOST RECENT TWEETS WITH THE HIGHEST NUMBER OF RETWEETS

query = 'felicidade'
q_filter = ' -filter:retweet'

def extract_data(query=query, head=5, lang='pt', items=200):
    
    TWITTER_DATA = []

    for tweet in tw.tweepy.Cursor(tw.api.search,
                                  q=query,
                                  lang=lang,
                                  result_type='recent',
                                  tweet_mode='extended'  # collect the full text (over 140 characters)
                                  ).items(items):

        TWITTER_DATA.append([tweet.id, tweet.created_at, tweet.user.location, tweet.full_text.replace('\n', ' '), 
                                          tweet.retweet_count, [e['text'] for e in tweet._json['entities']['hashtags']]])

        df = pd.DataFrame(TWITTER_DATA, columns=['id','timestamp', 'location', 'tweet', 'retweet_count', 'hashtag'])
        
    return df


def five_most_recent_highest_retweets(data = df, head=5):
    
    df_five = data[['tweet', 'retweet_count']].drop_duplicates() # delete all duplicated texts
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

def most_arroba(data = df, query=''.join([query, q_filter])):

    tweets = df['tweet']
    arroba = []

    for line in tweets:
        word_split = line.split()
        for word in word_split:
            if word.startswith("@"):
                arroba.append(word)

    return pd.DataFrame(users)[0].value_counts()

# FUNCTION OF MOST USED WORDS IN TWEETS DISREGARDING STOPWORDS

def most_words():

    #code

    pass