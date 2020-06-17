import tw_auth as tw
import pandas as import pd



# FUNCTION OF 5 MOST RECENT TWEETS WITH THE HIGHEST NUMBER OF RETWEETS

def five_most_recent_highest_retweets(query = 'felicidade', retweets = 5, lang = 'pt', items = 200):
    
    RETWEETS = []

    for tweet in tw.tweepy.Cursor(api.search,
                        q= query, 
                        lang= lang,
                        result_type='recent',
                        tweet_mode = 'extended'  # collect the full text (over 140 characters)
                        ).items(items):

                        if (tweet.retweet_count > 0):

                            RETWEETS.append([tweet.full_text, tweet.retweet_count])

                        df = pd.DataFrame(RETWEETS, columns = ['tweet', 'retweet_count']).sort_values(by='retweet_count', ascending=False)
                        df = df.drop_duplicates()
    return df.head(retweets)

# FUNCTION TO TRANSFORM DATA

def transform_data():

    #code

    return pass

# FUNCTION OF # MOST USED AND THEIR RELATIONSHIP

def most_hashtag():

    #code

    return pass

# FUNCTION OF MOST CITED @USER ACCOUNTS IN THE TWEETS

def most_arroba():

    #code

    return pass

# FUNCTION OF MOST USED WORDS IN TWEETS DISREGARDING STOPWORDS

def most_words():

    #code

    return pass