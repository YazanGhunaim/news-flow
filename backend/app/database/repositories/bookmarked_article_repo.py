"""implementation for bookmarked articles repository"""
import uuid
from typing import List

from supabase import Client

from app.database.models.bookmarked_article import BookmarkedArticle
from app.database.repositories.abstract_repo import ABCRepository
from app.schemas.news_articles import ProcessedArticle


class BookmarkedArticleRepository(ABCRepository):
    """Bookmarked articles repository implementation"""

    def __init__(self, supabase_client: Client):
        """see class doc"""
        super().__init__(supabase_client)

    def add_bookmarked_article(self, article: BookmarkedArticle):
        """bookmarks article"""
        response = self.db.table("bookmarked_articles").insert(article.model_dump()).execute()
        return response

    def get_bookmarks_for_user(self, uid: str) -> List[ProcessedArticle]:
        """gets bookmarked articles per uid"""
        response = (
            self.db
            .table("bookmarked_articles")
            .select("*")
            .eq("user_id", uuid.UUID(uid))
            .execute()
        )

        return response.data
