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
import webbrowser as wb

from PIL import Image
from pathlib import Path  # para a logo
import base64  # para a logo

from functions import *

# LOGO

# Main


def img_to_bytes(img_path):
    img_bytes = Path(img_path).read_bytes()
    encoded = base64.b64encode(img_bytes).decode()
    return encoded

# Side bar


sidebar_html = "<img src='data:image/png;base64,{}' class='img-fluid'>".format(
    img_to_bytes("logo.png"))


st.sidebar.markdown(sidebar_html, unsafe_allow_html=True,)

# FIM LOGO

"""
# Bem vind@! Que tal analisar uns tweets?

O **Twitter** é uma rede social que permite ao usuário expor o que pensa, enviar e receber 
atualizações de outros usuários, acompanhar notícias, avaliar produtos e serviços, etc. 
Isso torna essa rede social uma grande fonte de dados onde é possível buscar pelo assunto de interesse 
ou, mais profissionalmente, saber como o produdo ou serviço da sua empresa está sendo visto pelo cosumidor.
"""

# Extração de tweets com a plavra input


@st.cache
def load_data(p_input):
    df = extract_data(p_input)
    return df

# SIDE BAR


st.sidebar.markdown(" ")
st.sidebar.markdown(" ")
st.sidebar.markdown(
    """ Definimos uma busca dos **500 tweets** mais recentes para análise!""")
st.sidebar.markdown(""" ## Insira uma palavra para buscar: """)

# word input
input_word = st.sidebar.text_input('')

# checks
st.sidebar.markdown(""" ### Selecione as opções de busca: """)
check1 = st.sidebar.checkbox('Os 5 tweets mais retweetados')
check2 = st.sidebar.checkbox('Os 10 usuários mais citados')
check3 = st.sidebar.checkbox('As palavras mais usadas')
check4 = st.sidebar.checkbox('As hashtags mais usada e suas relações')


#### LINKEDINS

st.sidebar.markdown('**Hey! Dá uma olhada no nosso time:**')
# st.sidebar.markdown('')
if st.sidebar.button('Denis Dinardi'):
    denis = 'https://www.linkedin.com/in/denisdinardi/'
    wb.open_new_tab(denis)
if st.sidebar.button('Edson Guilherme'):
    edson = 'https://www.linkedin.com/in/edson-guilherme-appoloni-correia-19897134/'
    wb.open_new_tab(edson)
if st.sidebar.button('João Pedro'):
    joao = 'https://www.linkedin.com/in/joão-chagas/'
    wb.open_new_tab(joao)
if st.sidebar.button('Nayara Moura'):
    nayara = 'https://www.linkedin.com/in/nayara-cfm/'
    wb.open_new_tab(nayara)
if st.sidebar.button('Paulo Lima'):
    paulo = 'https://www.linkedin.com/in/dspaulolima'
    wb.open_new_tab(paulo)
    

# FIM SIDE BAR

# FUNCTIONS

if input_word != '':
    df_tweets = load_data(input_word)
    st.sidebar.markdown(len(input_word))

    #######################################################################

    # 5 TWEETS MAIS RETWEETADOS

    if check1:

        """ ### Os 5 Tweets Mais Retweetados:"""
        tweets_5 = five_most_recent_highest_retweets(
            df_tweets)  # Chamada da função

        # Mostra o resultado dos 5 tweets na tela

        st.table(tweets_5)

    #######################################################################

    # @ MAIS CITADOS

    if check2:

        users = most_arroba(df_tweets)  # chamada da função

        """ ### @ Usuários Mais Citados """

        plot_users = px.bar(users, y=users.index, x='count',
                            text='count', labels={})
        plot_users['layout']['yaxis']['autorange'] = "reversed"

        st.plotly_chart(plot_users)

    #######################################################################

    # PALAVRAS MAIS USADAS

    if check3:

        words = most_words(df_tweets)  # chamada da funçao

        freq_all_words = FreqDist(words)
        freq_df = pd.DataFrame(data=freq_all_words.most_common(
            10), columns=['Palavras', 'Frequências'])

        # Plota as palavras mais frequentes

        """ ### As Palavras Mais Usadas """
        plot_freq = px.bar(freq_df, y='Palavras', x='Frequências',
                           orientation='h', text='Frequências')
        plot_freq['layout']['yaxis']['autorange'] = "reversed"

        st.plotly_chart(plot_freq)

        # Plota a nuvem de palavras
        """ ### Nuvem de Palavras 
        Quanto maior a frequência da palavra, maior ela se apresenta na nuvem """

        twitter_fig = np.array(Image.open("twitter_black.png"))

        words_str = ' '.join(words)  # word list into a string

        wordcloud = WordCloud(max_font_size=100, width=1520,
                              height=535, max_words=100,
                              mask=twitter_fig, background_color='white').generate(words_str)
        plt.figure(figsize=(8, 7))
        plt.imshow(wordcloud, interpolation="bilinear")
        plt.axis("off")
        st.pyplot()

    #######################################################################

    # ASSOCIAÇÃO DE HASHTAGS

    if check4:

        rules = most_hashtag(df_tweets)  # Chamada da função

        rules.antecedents = rules.antecedents.apply(lambda x: next(iter(x)))
        rules.consequents = rules.consequents.apply(lambda x: next(iter(x)))

        """ ### Associação entre #hashtags 
        Caso não apareça, é porque não há associação."""
        fig, ax = plt.subplots(figsize=(16, 9))
        GA = nx.from_pandas_edgelist(
            rules, source='antecedents', target='consequents')
        circPos=nx.circular_layout(GA)
        
        pos_attrs = {}
        
        for node, coords in circPos.items():
            pos_attrs[node] = (coords[0]+0.1*(-1)*np.sign(coords[0]),
                               coords[1]+0.1*(-1)*np.sign(coords[1]))
            
        nx.draw(GA, with_labels=True, pos=pos_attrs, alpha=0.3)
        nx.draw_networkx_labels(GA, pos_attrs, alpha=1)

        st.pyplot()

    #######################################################################

else:
    """ ### Por favor, insira uma palavra no campo de busca na barra ao lado """
