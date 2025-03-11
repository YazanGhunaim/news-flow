"""fixtures related to router tests"""
from unittest.mock import MagicMock

import pytest
from fastapi.testclient import TestClient

from app.main import app
from app.services.news_service import NewsService


@pytest.fixture
def mock_news_service():
    """Mocking NewsService"""
    mock_service = MagicMock(NewsService)
    return mock_service


@pytest.fixture
def client_fixture():
    """Test client of our fastapi app"""
    return TestClient(app)
