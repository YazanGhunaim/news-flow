"""implementation for articles repository"""
import uuid
from typing import List

from supabase import Client

from app.database.models.article_summary import ArticleSummary
from app.database.models.bookmarked_article import BookmarkedArticle
from app.database.repositories.abstract_repo import ABCRepository
from app.schemas.news_articles import ProcessedArticle


class ArticleRepository(ABCRepository):
    """Articles repository implementation"""

    def __init__(self, supabase_client: Client):
        """see class doc"""
        super().__init__(supabase_client)

    def create_bookmarked_article(self, article: BookmarkedArticle):
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

    def create_article_summary(self, article_summary: ArticleSummary) -> ArticleSummary:
        """creates an article summary in db"""
        response = self.db.table("article_summaries").insert(article_summary.model_dump()).execute()
        return response.data

    def get_summary_by_url(self, article_url: str) -> ArticleSummary:
        """gets article_summary by url"""
        response = (
            self.db
            .table("article_summaries")
            .select("*")
            .eq("article_url", article_url)
            .execute()
        )

        return response.data

    def delete_summary_by_url(self, article_url: str):
        """deletes article_summary by url"""
        (
            self.db
            .table("article_summaries")
            .delete()
            .eq("article_url", article_url)
            .execute()
        )
