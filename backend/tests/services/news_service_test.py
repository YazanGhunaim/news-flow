"""Tests related to services"""
from app.schemas.news_articles import BaseNewsResponse


def test_fetch_top_headlines(news_service_fixture, mock_news_api_client, base_article_fixture):
    """Test fetch_top_headlines method."""
    mock_response = {
        "totalResults": 1,
        "articles": [base_article_fixture],
    }

    mock_news_api_client.get_top_headlines.return_value = mock_response

    result = news_service_fixture.fetch_top_headlines(keyword="test")

    assert isinstance(result, BaseNewsResponse)
    assert len(result.articles) == 1
    assert result.articles[0].title == base_article_fixture.title


def test_fetch_everything(news_service_fixture, mock_news_api_client, base_article_fixture):
    """Test fetch_everything method."""
    mock_response = {
        "totalResults": 2,
        "articles": [
            base_article_fixture,
            base_article_fixture,
        ],
    }

    mock_news_api_client.get_everything.return_value = mock_response

    result = news_service_fixture.fetch_everything(keyword="test")

    assert isinstance(result, BaseNewsResponse)
    assert len(result.articles) == 2
    assert result.articles[0].title == base_article_fixture.title


def test_fetch_sources(news_service_fixture, mock_news_api_client):
    """Test fetch_sources method."""
    mock_response = {
        "sources": [{"id": "bbc-news", "name": "BBC News"}, {"id": "cnn", "name": "CNN"}],
    }

    mock_news_api_client.get_sources.return_value = mock_response

    result = news_service_fixture.fetch_sources(category="general")

    assert len(result["sources"]) == 2
    assert result["sources"][0]["id"] == "bbc-news"
