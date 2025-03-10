"""Service class for handling news data retrieval"""
from newsapi import NewsApiClient


class NewsService:
    """News Service class

    provides common interface to retrieve news data from multiple sources
    """

    def __init__(self):
        """see class doc"""
        self.news_api_client = NewsApiClient(api_key="8a29050da53e407ba8e8a5497bfa4032")  # TODO: config var

    # TODO: category becomes an Enum.. find common ground of what categories i want to support
    def fetch_top_headlines(self, keyword: str = None, sources: str = None, category: str = None, page: int = None,
                            page_size: int = None, language: str = "en"):
        """Fetch live top and breaking headlines.

        :param keyword: keyword to search for
        :param sources: comma separated string for news sources desired
        :param category: category for desired headlines
        :param page: page number
        :param page_size: number of results per page
        :param language: language of headlines
        :return: # TODO: Pydantic model specification?
        """
        top_headlines = self.news_api_client.get_top_headlines(
            q=keyword, sources=sources, category=category,
            language=language, page=page, page_size=page_size,
        )
        return top_headlines

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
        :return: # TODO: Pydantic model specification?
        """
        all_articles = self.news_api_client.get_everything(
            q=keyword, language=language, sources=sources, page=page,
            page_size=page_size
        )
        return all_articles

    def fetch_sources(self, category: str = None, language: str = "en"):
        """Available news sources

        :param category: Find sources that display news of this category.
        :param language: Find sources that display news in a specific language
        :return: Array of Sources
        """
        sources = self.news_api_client.get_sources(category=category, language=language)
        return sources
