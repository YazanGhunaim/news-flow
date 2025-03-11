"""global test fixtures"""
import pytest

from app.schemas.news_articles import BaseArticle, ProcessedArticle, Source


@pytest.fixture(scope="session")
def base_article_fixture() -> BaseArticle:
    """fixture to an article"""
    return BaseArticle(
        source=Source(id=None, name="blitz"),
        author="Yazan",
        title="lorem ipsum",
        description="lorem ipsum",
        url="https://www.cnbc.com/2025/03/09/stock-market-news-today-live-updates.html",
        urlToImage="https://image.cnbcfm.com/api/v1/image/108112754-1741363586692-gettyimages-2203810302-tariffs597253_6feyhmpx.jpeg?v=1741363628&w=1920&h=1080",
        publishedAt="2025-03-10T09:53:00Z",
        content="lorem ipsum"
    )


@pytest.fixture(scope="session")
def processed_article_fixture() -> ProcessedArticle:
    """fixture to an article"""
    return ProcessedArticle(
        source=Source(id=None, name="blitz"),
        author="Yazan",
        title="lorem ipsum",
        description="lorem ipsum",
        url="https://www.cnbc.com/2025/03/09/stock-market-news-today-live-updates.html",
        image_url="https://image.cnbcfm.com/api/v1/image/108112754-1741363586692-gettyimages-2203810302-tariffs597253_6feyhmpx.jpeg?v=1741363628&w=1920&h=1080",
        date="2025-03-10T09:53:00Z",
        content="lorem ipsum"
    )
