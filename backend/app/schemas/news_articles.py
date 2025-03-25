"""Article related schemas"""
from enum import Enum
from typing import List, Optional

from pydantic import BaseModel, Field


class NewsCategory(str, Enum):
    """Enum class to represent News Categories"""

    BUSINESS = "business"
    ENTERTAINMENT = "entertainment"
    GENERAL = "general"
    HEALTH = "health"
    SCIENCE = "science"
    SPORTS = "sports"
    TECHNOLOGY = "technology"


class Source(BaseModel):
    """Source Model"""

    id: Optional[str]
    name: str


class BaseArticle(BaseModel):
    """Base Article model

    Modelling how the article looks initially from the API
    """

    source: Source
    author: Optional[str]
    title: str
    description: Optional[str]
    url: str
    image_url: Optional[str] = Field(alias="urlToImage")
    date: str = Field(alias="publishedAt")
    content: Optional[str]


class ProcessedArticle(BaseModel):
    """Model of article after processing

    Appending full content etc...
    """
    source: Source
    author: Optional[str] = None
    title: str
    description: str
    url: str

    # No need to specify field name as we take in the BaseArticle to process an article
    image_url: Optional[str] = None
    date: str

    summary: Optional[str] = None
    content: str


class BaseNewsResponse(BaseModel):
    """Model of the API news response"""

    total_results: int = Field(alias="totalResults")
    articles: List[BaseArticle]


class ProcessedNewsResponse(BaseModel):
    """Model of news response after article processing"""

    total_results: int
    articles: List[ProcessedArticle]
