"""news service dependency"""
from functools import lru_cache

from app.services.external.news_service import NewsService


@lru_cache
def get_news_service() -> NewsService:
    """News service dependency"""
    news_service = NewsService()
    return news_service
