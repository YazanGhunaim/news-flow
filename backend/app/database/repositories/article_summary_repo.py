"""implementation for article summary repository"""
from supabase import Client

from app.database.models.article_summary import ArticleSummary
from app.database.repositories.abstract_repo import ABCRepository


class ArticleSummaryRepository(ABCRepository):
    """Bookmarked articles repository implementation"""

    def __init__(self, supabase_client: Client):
        """see class doc"""
        super().__init__(supabase_client)

    def add_article_summary(self, article_summary: ArticleSummary) -> ArticleSummary:
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

        if response.data:
            return ArticleSummary(article_url=response.data[0]["article_url"], summary=response.data[0]["summary"])

    def delete_summary_by_url(self, article_url: str):
        """deletes article_summary by url"""
        (
            self.db
            .table("article_summaries")
            .delete()
            .eq("article_url", article_url)
            .execute()
        )
