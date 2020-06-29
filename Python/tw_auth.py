# pip install tweepy

import tweepy

# KEY READING - PUBLIC MODE

with open('.kt/twtk.txt', 'r') as file:
    CONSUMER_KEY = file.readline().strip('\n')
    CONSUMER_SECRET_KEY = file.readline().strip('\n')

## CONSUMER KEYS CONNECTION

auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET_KEY)

## API USER ACCESS

api = tweepy.API(auth, wait_on_rate_limit=True, wait_on_rate_limit_notify=True, timeout=60)