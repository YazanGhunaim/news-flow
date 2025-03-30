"""utility class to perform actions on news articles"""
from pprint import pprint

from newspaper import Article

from app.services.external.news_service import NewsService


class ArticleHTMLParser:
    """Parser class that helps get the full content of articles from sources who don't provide it"""

    @staticmethod
    def parse_article(url: str) -> str:
        """Parses the article page

        :param url: article url
        :return: article page full text content
        """
        article = Article(url)
        article.download()
        article.parse()
        return article.text

    @staticmethod
    def get_summary(url: str) -> str:
        """Uses NLP to generate a summary of the article

        needed for summary
        import nltk
        nltk.download('punkt')
        nltk.download('punkt_tab')

        :param url: article url
        :return: article summary
        """
        article = Article(url)
        article.download()
        article.parse()
        article.nlp()
        return article.summary


if __name__ == "__main__":
    news_service = NewsService()

    top_headlines = news_service.fetch_top_headlines(page_size=10)
    urls = [article.url for article in top_headlines.articles]

    for url in urls:
        pprint(f"Article url: {url}")
        pprint(f"Summary: {ArticleHTMLParser.get_summary(url)}")
        try:
            pprint(ArticleHTMLParser.parse_article(url))
        except Exception:
            pass

    # cnn_paper = newspaper.build('http://cnn.com')
    # for article in cnn_paper.articles:
    #     print(article.url)
