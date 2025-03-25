"""Article summary ORM model"""
from pydantic import BaseModel


class ArticleSummary(BaseModel):
    """model of table article summary"""
    article_url: str
    summary: str
