"""Article summarization integration test"""
import pytest

from tests.integration.conftest import generate_auth_header


@pytest.mark.integration
@pytest.mark.llm
class TestArticleSummarization:
    """Article summarization flow e2e tests"""

    def test_successful_article_summarization_flow(
            self, test_api_client,
            registered_user_json,
            processed_article_json
    ):
        """signs in the already registered user, summarizes the article then confirms it has a summary"""
        # Sign in
        response_sign_in = test_api_client.post("/users/sign_in", json=registered_user_json)
        assert response_sign_in.status_code == 200  # successful login

        # Create authorization header
        authorization_header = generate_auth_header(response_sign_in)

        # Summarize article
        response_summarize_article = test_api_client.post(
            "/articles/summary",
            json=processed_article_json,
            headers=authorization_header
        )
        assert response_summarize_article.status_code == 201  # Newly created

        # Confirm summarized correctly
        response_get_summary = test_api_client.post(
            "/articles/summary",
            json=processed_article_json,
            headers=authorization_header
        )
        assert response_get_summary.status_code == 200  # Successfully retrieved ( was created prior )

        # Delete summary
        response_delete_summary = test_api_client.delete(
            "/articles/summary",
            params={"article_url": processed_article_json["url"]},
            headers=authorization_header
        )
        assert response_delete_summary.status_code == 204  # No content
