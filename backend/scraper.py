from newsapi import NewsApiClient
from newspaper import Article
from pprint import pprint

# import requests
# from bs4 import BeautifulSoup
#
# response = requests.get("https://www.bbc.com/news")
#
# soup = BeautifulSoup(response.content, "html.parser")
# headlines = soup.find_all("h2")
# for headline in headlines:
#     print(headline.text)

# Init
newsapi = NewsApiClient(api_key='8a29050da53e407ba8e8a5497bfa4032')

# /v2/top-headlines
top_headlines = newsapi.get_everything(language="en", q="AI")
pprint(len(top_headlines["articles"]))

urls = [article["url"] for article in top_headlines["articles"]]

# url = top_headlines["articles"][0]["url"]
# pprint(top_headlines["articles"][0]["url"])

# articles = [Article(url) for url in urls]
#
# success_count = 0
# for article in articles:
#     try:
#         article.download()
#         article.parse()
#         print(article.text)
#         success_count += 1
#     except:
#         print("error")
