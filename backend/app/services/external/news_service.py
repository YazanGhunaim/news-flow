"""Service class for handling news data retrieval"""
from pprint import pprint

from newsapi import NewsApiClient

from app.config import get_config
from app.schemas.news_articles import BaseNewsResponse, NewsAPICategory


class NewsService:
    """News Service class

    provides common interface to retrieve news data from multiple sources
    """

    def __init__(self):
        """see class doc"""
        self.config = get_config()
        self.news_api_client = NewsApiClient(api_key=self.config.news_api_key)

    def fetch_top_headlines(
            self, keyword: str = None, sources: str = None, category: NewsAPICategory = None,
            page: int = None,
            page_size: int = None, language: str = "en"
    ) -> BaseNewsResponse:
        """Fetch live top and breaking headlines.

        :param keyword: keyword to search for
        :param sources: comma separated string for news sources desired
        :param category: category for desired headlines
        :param page: number of the page for pagination
        :param page_size: number of results per page
        :param language: language of headlines
        :return: BaseNewsResponse
        """
        top_headlines = self.news_api_client.get_top_headlines(
            q=keyword, sources=sources, category=category,
            language=language, page=page, page_size=page_size,
        )
        return BaseNewsResponse(**top_headlines)

    def fetch_everything(
            self, keyword: str, page: int = None, page_size: int = None, sources: str = None,
            language: str = "en"
    ):
        """Fetch every article available based on given parameters

        :param keyword: Keywords or phrases to search for in the article title and body.
        :param page: page number for pagination
        :param page_size: number of results per page
        :param sources: comma separated string for news sources desired
        :param language: language of articles
        :return: BaseNewsResponse
        """
        all_articles = self.news_api_client.get_everything(
            q=keyword, language=language, sources=sources, page=page,
            page_size=page_size
        )
        return BaseNewsResponse(**all_articles)

    def fetch_sources(self, category: str = None, language: str = "en"):
        """Available news sources

        :param category: Find sources that display news of this category.
        :param language: Find sources that display news in a specific language
        :return: Array of Sources
        """
        sources = self.news_api_client.get_sources(category=category, language=language)
        return sources


if __name__ == "__main__":
    news_service = NewsService()
    pprint(news_service.fetch_top_headlines(category="business", page_size=1))
    # pprint(news_service.fetch_everything(keyword="Technology", page_size=5))
    # pprint(news_service.fetch_sources())
