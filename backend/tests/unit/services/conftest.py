"""fixtures related to service tests"""
from unittest.mock import patch

import pytest

from app.services.news_service import NewsService


@pytest.fixture
def mock_news_api_client():
    """Fixture to mock NewsApiClient."""
    with patch("app.services.news_service.NewsApiClient") as MockClient:
        mock_instance = MockClient.return_value
        yield mock_instance


@pytest.fixture
def news_service_fixture(mock_news_api_client):
    """Fixture to create a NewsService instance with mocked NewsApiClient."""
    return NewsService()
