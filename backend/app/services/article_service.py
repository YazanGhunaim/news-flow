"""implementation of article service"""
from typing import List

from app.database.models.article_summary import ArticleSummary
from app.database.models.bookmarked_article import BookmarkedArticle
from app.database.repositories.article_repo import ArticleRepository
from app.schemas.news_articles import ProcessedArticle
from app.services.openai_service import AIClient


class ArticleService:
    """Articles service class

    Contains business logic and interacts with article repo
    """

    def __init__(self, repo: ArticleRepository):
        """see class doc"""
        self.repo = repo

    def bookmark_article(self, article: ProcessedArticle, uid: str):
        """bookmarks article to specific user"""
        bookmarked_article = BookmarkedArticle(user_id=uid, **article.model_dump())
        return self.repo.create_bookmarked_article(bookmarked_article)

    def fetch_bookmarks_for_user(self, uid: str) -> List[ProcessedArticle]:
        """gets bookmarked articles for uid"""
        return self.repo.get_bookmarks_for_user(uid)

    def summarize_article(self, article: ProcessedArticle) -> tuple[ArticleSummary, bool]:
        """summarizes article for a user

        :returns: tuple [ Article Summary : boolean ( newly created: true, false otherwise )
        """
        # Check if summary already exists for the given article URL
        existing_summary = self.repo.get_summary_by_url(article.url)

        if existing_summary:
            return existing_summary, False

        ai_client = AIClient()
        summary = ai_client.summarize_article_content(article)

        article_summary = ArticleSummary(article_url=article.url, summary=summary)
        return self.repo.create_article_summary(article_summary), True

    def delete_summary(self, article_url: str):
        """deletes summary of an article"""
        self.repo.delete_summary_by_url(article_url)
