"""implementation of article summary service"""
from app.database.models.article_summary import ArticleSummary
from app.database.repositories.article_summary_repo import ArticleSummaryRepository
from app.schemas.news_articles import ProcessedArticle
from app.services.external.openai_service import AIClient


class ArticleSummaryService:
    """ArticleSummary service class

    Contains business logic and interacts with article summary repo
    """

    def __init__(self, repo: ArticleSummaryRepository):
        """see class doc"""
        self.repo = repo

    def create_article_summary(self, article: ProcessedArticle) -> tuple[ArticleSummary, bool]:
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
        self.repo.add_article_summary(article_summary)
        return article_summary, True

    def delete_summary(self, article_url: str):
        """deletes summary of an article"""
        self.repo.delete_summary_by_url(article_url)
