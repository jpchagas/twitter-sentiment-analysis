import plotly.express as px
import streamlit as st
import pandas as pd
import numpy as np
import altair as alt
import pydeck as pdk
from wordcloud import WordCloud
import matplotlib.pyplot as plt
from nltk import FreqDist
import networkx as nx


from functions import *


"""
# Twitter Busca


"""

# Extração de tweets com a palavra input


@st.cache
def load_data(p_input):
    df = extract_data(p_input)
    return df


st.sidebar.markdown(""" ## Insira uma palavra para buscar: """)
input_word = st.sidebar.text_input('')

st.sidebar.markdown(""" ### Selecione as opções de busca: """)
check1 = st.sidebar.checkbox('Os 5 tweets mais retweetados')
check2 = st.sidebar.checkbox('Os 10 usuários mais citados')
check3 = st.sidebar.checkbox('As palavras mais usadas')
check4 = st.sidebar.checkbox('As hashtags mais usada e suas relações')


if input_word != '':
    df_tweets = load_data(input_word)

    #######################################################################

    # 5 TWEETS MAIS RETWEETADOS

    if check1:

        tweets_5 = five_most_recent_highest_retweets(
            df_tweets)  # Chamada da função

        # Mostra o resultado dos 5 tweets na tela

        """ ### 5 Tweets mais retweetados:""", tweets_5

    #######################################################################

    # @ MAIS CITADOS

    if check2:

        users = most_arroba(df_tweets)  # chamada da função

        """ ### Usuários mais citados """
        users.plot.barh(stacked=True)

        plot_users = px.bar(users, y=users.index, x='count',
                            text='count', color='count')
        plot_users['layout']['yaxis']['autorange'] = "reversed"

        st.plotly_chart(plot_users)

    #######################################################################

    # PALAVRAS MAIS USADAS

    if check3:

        words = most_words(df_tweets)  # chamada da funçao

        freq_all_words = FreqDist(words)
        freq_df = pd.DataFrame(data=freq_all_words.most_common(
            10), columns=['Word', 'Frequency'])

        # Plota as palavras mais frequentes

        """ ### As mais palavras mais usadas """
        plot_freq = px.bar(freq_df, y='Word', x='Frequency',
                           orientation='h', text='Frequency')
        plot_freq['layout']['yaxis']['autorange'] = "reversed"

        st.plotly_chart(plot_freq)

        # Plota a nuvem de palavras
        """ ### Nuvem de palavras """

        words_str = ' '.join(words)  # word list into a string

        wordcloud = WordCloud(max_font_size=100, width=1520,
                              height=535, max_words=100).generate(words_str)
        plt.figure(figsize=(16, 9))
        plt.imshow(wordcloud, interpolation="bilinear")
        plt.axis("off")
        st.pyplot()

    #######################################################################

    # ASSOCIAÇÃO DE HASHTAGS

    if check4:

        rules = most_hashtag(df_tweets)  # Chamada da função

        rules.antecedents = rules.antecedents.apply(lambda x: next(iter(x)))
        rules.consequents = rules.consequents.apply(lambda x: next(iter(x)))

        """ ### Como as hashtags mais usadas se associam """
        fig, ax = plt.subplots(figsize=(16, 9))
        GA = nx.from_pandas_edgelist(
            rules, source='antecedents', target='consequents')
        nx.draw(GA, with_labels=True)
        st.pyplot()

    #######################################################################

else:
    """ ### Por favor, insira uma palavra no campo de busca na barra ao lado """
