"""Utils to help work with articles"""
from logging import getLogger
from typing import List, Optional

from app.schemas.news_articles import BaseArticle, ProcessedArticle
from app.utils.article_parser import ArticleHTMLParser

log = getLogger(__name__)


class ArticleUtils:
    """Class to encapsulate utility methods"""

    @staticmethod
    def process_article(article: BaseArticle) -> Optional[ProcessedArticle]:
        """Fetches and appends full content retrieved by parsing the HTML.

        generates summary using nlp provided by newspaper module

        :param article: BaseArticle model
        :return: ProcessedArticle if successful, else None
        """
        try:
            full_content = ArticleHTMLParser.parse_article(article.url)
            # summary = ArticleHTMLParser.get_summary(article.url)

            return ProcessedArticle(**article.model_dump(exclude={"content"}), content=full_content)
        except Exception as e:
            log.error(f"Failed parsing of article with error: {e}")
            return None

    @staticmethod
    def process_articles(articles: List[BaseArticle]) -> List[ProcessedArticle]:
        """Processes a list of articles

        by appending full content etc...

        :param articles: List of BaseArticle instances.
        :return: List of ProcessedArticle instances with full content.
        """
        return [
            processed_article for article in articles
            if (processed_article := ArticleUtils.process_article(article)) is not None
        ]
