"""User preferences integration test"""
import pytest

from tests.integration.conftest import generate_auth_header


@pytest.mark.integration
@pytest.mark.user
class TestUserBookmarks:
    """User preferences e2e tests"""

    def test_user_bookmarks_flow(
            self, test_api_client,
            registered_user_json,
            processed_article_json
    ):
        """signs in the already registered user, sets preferences then gets them confirming the setup"""
        # Sign in
        response_sign_in = test_api_client.post("/users/sign_in", json=registered_user_json)
        assert response_sign_in.status_code == 200  # successful login

        # Create authorization header
        authorization_header = generate_auth_header(response_sign_in)

        # Confirm originally no bookmarks
        response_get_preferences = test_api_client.get("/users/bookmarks", headers=authorization_header)
        assert response_get_preferences.status_code == 200
        assert response_get_preferences.json() == []

        # Bookmark article
        response_bookmark_article = test_api_client.post(
            "/articles/bookmark",
            json=processed_article_json,
            headers=authorization_header
        )
        assert response_bookmark_article.status_code == 204  # No content

        # Confirm bookmarked correctly
        response_get_preferences = test_api_client.get("/users/bookmarks", headers=authorization_header)
        assert response_get_preferences.status_code == 200
        assert response_get_preferences.json() == [processed_article_json]
