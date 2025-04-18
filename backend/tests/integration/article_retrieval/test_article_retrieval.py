"""Article retrieval integration test"""
import pytest

from tests.integration.conftest import generate_auth_header


@pytest.mark.integration
@pytest.mark.costly
class TestArticleRetrieval:
    """Article retrieval flow e2e tests"""

    def test_successful_article_get_headlines_flow(self, test_api_client, registered_user_json):
        """signs in the already registered user, retrieves top headlines"""
        # Sign in
        response_sign_in = test_api_client.post("/users/sign_in", json=registered_user_json)

        # Create authorization header
        authorization_header = generate_auth_header(response_sign_in)

        # Get top headlines
        response_top_headlines = test_api_client.get(
            "/articles/top-headlines",
            params={"category": "general", "page_size": 5},
            headers=authorization_header,
        )
        assert response_top_headlines.status_code == 200
        assert response_top_headlines.json()["articles"]  # Articles exist

    def test_successful_get_everything_flow(self, test_api_client, registered_user_json):
        """signs in the already registered user, retrieves everything"""
        # Sign in
        response_sign_in = test_api_client.post("/users/sign_in", json=registered_user_json)

        # Create authorization header
        authorization_header = generate_auth_header(response_sign_in)

        # Get everything
        response_get_everything = test_api_client.get(
            "/articles/everything",
            params={"keyword": "bitcoin", "page_size": 5},
            headers=authorization_header,
        )
        assert response_get_everything.status_code == 200
        assert response_get_everything.json()["articles"]  # Articles exist
