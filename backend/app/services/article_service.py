"""implementation of article service"""
from typing import List

from app.database.models.bookmarked_article import BookmarkedArticle
from app.database.repositories.article_repo import ArticleRepository
from app.schemas.news_articles import ProcessedArticle


class ArticleService:
    """Articles service class

    Contains business logic and interacts with article repo
    """

    def __init__(self, repo: ArticleRepository):
        """see class doc"""
        self.article_repo = repo

    def bookmark_article(self, article: ProcessedArticle, uid: str):
        """bookmarks article to specific user"""
        bookmarked_article = BookmarkedArticle(user_id=uid, **article.model_dump())
        return self.article_repo.create_bookmarked_article(bookmarked_article)

    def fetch_bookmarks_for_user(self, uid: str) -> List[ProcessedArticle]:
        """gets bookmarked articles for uid"""
        return self.article_repo.get_bookmarks_for_user(uid)
