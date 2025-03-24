"""Article endpoint related tests"""
from unittest.mock import patch

import pytest

from app.dependencies.news_service import get_news_service
from app.main import app
from app.schemas.news_articles import BaseNewsResponse
from tests.unit.conftest import processed_article_fixture
from tests.unit.routers.conftest import client_fixture


@pytest.mark.unit
def test_get_top_headlines(client_fixture, mock_news_service, base_article_fixture, processed_article_fixture):
    """Test for the /articles/top-headlines endpoint"""
    # Define mock return data for the NewsService
    mock_news_service.fetch_top_headlines.return_value = BaseNewsResponse(
        totalResults=2,
        articles=[base_article_fixture, base_article_fixture]
    )

    # Patch ArticleUtils.process_articles method to return our mocked data
    with patch('app.utils.article_utils.ArticleUtils.process_articles') as mock_process_articles:
        mock_process_articles.return_value = [processed_article_fixture, processed_article_fixture]

        # Override dependency injection
        app.dependency_overrides[get_news_service] = lambda: mock_news_service

        # Call the API
        response = client_fixture.get("/articles/top-headlines")

        expected_response = {
            "total_results": 2,
            "articles": [processed_article_fixture.model_dump(), processed_article_fixture.model_dump()]
        }
        assert response.status_code == 200
        assert response.json() == expected_response

        app.dependency_overrides.clear()


@pytest.mark.unit
def test_get_top_headlines_error(client_fixture, mock_news_service):
    """Simulate an error when fetching top headlines"""
    mock_news_service.fetch_top_headlines.side_effect = Exception("Something went wrong")
    app.dependency_overrides[get_news_service] = lambda: mock_news_service

    response = client_fixture.get("/articles/top-headlines")

    # Check for 400 error
    assert response.status_code == 400
    assert response.json() == {"detail": "Something went wrong"}

    app.dependency_overrides.clear()


@pytest.mark.unit
def test_get_everything(client_fixture, mock_news_service, base_article_fixture, processed_article_fixture):
    """Test for the /articles/everything endpoint"""
    # Define mock return data for the NewsService
    mock_news_service.fetch_everything.return_value = BaseNewsResponse(
        articles=[base_article_fixture, base_article_fixture, base_article_fixture],
        totalResults=3
    )

    # Patch ArticleUtils.process_articles method to return our mocked data
    with patch('app.utils.article_utils.ArticleUtils.process_articles') as mock_process_articles:
        mock_process_articles.return_value = [
            processed_article_fixture,
            processed_article_fixture,
            processed_article_fixture
        ]

        app.dependency_overrides[get_news_service] = lambda: mock_news_service

        # Call the endpoint
        response = client_fixture.get("/articles/everything", params={"keyword": "technology"})

        # Check the response status and content
        assert response.status_code == 200
        assert response.json() == {
            "total_results": 3,
            "articles": [
                processed_article_fixture.model_dump(),
                processed_article_fixture.model_dump(),
                processed_article_fixture.model_dump()
            ]
        }

        app.dependency_overrides.clear()


@pytest.mark.unit
def test_get_everything_error(client_fixture, mock_news_service):
    """Simulate an error when fetching articles"""
    mock_news_service.fetch_everything.side_effect = Exception("Something went wrong")
    app.dependency_overrides[get_news_service] = lambda: mock_news_service

    # Call the endpoint
    response = client_fixture.get("/articles/everything", params={"keyword": "science"})

    # Check for 400 error
    assert response.status_code == 400
    assert response.json() == {"detail": "Something went wrong"}

    app.dependency_overrides.clear()
