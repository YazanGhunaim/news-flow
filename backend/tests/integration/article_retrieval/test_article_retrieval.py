"""Article retrieval integration test"""
import pytest


@pytest.mark.integration
@pytest.mark.costly
class TestArticleRetrieval:
    """Article retrieval flow e2e tests"""

    def test_successful_article_get_headlines_flow(self, test_api_client):
        """signs in the already registered user, retrieves top headlines"""
        # Get top headlines
        response_top_headlines = test_api_client.get(
            "/articles/top-headlines",
            params={"category": "general", "page_size": 5},
        )
        assert response_top_headlines.status_code == 200
        assert response_top_headlines.json()["articles"]  # Articles exist

    def test_successful_get_everything_flow(self, test_api_client):
        """signs in the already registered user, retrieves everything"""
        # Get everything
        response_get_everything = test_api_client.get(
            "/articles/everything",
            params={"keyword": "bitcoin", "page_size": 5},
        )
        assert response_get_everything.status_code == 200
        assert response_get_everything.json()["articles"]  # Articles exist
