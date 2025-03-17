"""Bookmarked article orm model"""
import uuid
from typing import Optional

from pydantic import BaseModel, ConfigDict

from app.schemas.news_articles import Source


class BookmarkedArticle(BaseModel):
    """Article alongside user_id"""
    user_id: uuid
    source: Source
    author: Optional[str]
    title: str
    description: str
    url: str

    # No need to specify field name as we take in the BaseArticle to process an article
    image_url: Optional[str]
    date: str

    # summary: str  # using newspaper nlp
    content: str

    model_config = ConfigDict(arbitrary_types_allowed=True)
