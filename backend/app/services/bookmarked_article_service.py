"""implementation of bookmarked article service"""
from typing import List

from app.database.models.bookmarked_article import BookmarkedArticle
from app.database.repositories.bookmarked_article_repo import BookmarkedArticleRepository
from app.schemas.news_articles import ProcessedArticle


class BookmarkedArticleService:
    """Bookmarked articles service class

    Contains business logic and interacts with bookmarked article repo
    """

    def __init__(self, repo: BookmarkedArticleRepository):
        """see class doc"""
        self.repo = repo

    def create_bookmarked_article(self, article: ProcessedArticle, uid: str):
        """bookmarks article to specific user"""
        bookmarked_article = BookmarkedArticle(user_id=uid, **article.model_dump())
        return self.repo.add_bookmarked_article(bookmarked_article)

    def fetch_bookmarks_for_user(self, uid: str) -> List[ProcessedArticle]:
        """gets bookmarked articles for uid"""
        return self.repo.get_bookmarks_for_user(uid)
