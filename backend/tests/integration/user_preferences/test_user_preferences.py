"""User preferences integration test"""
import pytest

from tests.integration.conftest import generate_auth_header, test_api_client


@pytest.mark.integration
@pytest.mark.user
class TestUserPreferences:
    """User preferences e2e tests"""

    def test_invalid_set_user_preferences_flow(
            self, test_api_client,
            registered_user_json,
            invalid_user_preferences
    ):
        """signs in the already registered user, try set preferences with invalid categories"""
        # Sign in
        response_sign_in = test_api_client.post("/users/sign_in", json=registered_user_json)
        assert response_sign_in.status_code == 200  # successful login

        # Create authorization header
        authorization_header = generate_auth_header(response_sign_in)

        # Confirm originally no preferences
        response_get_preferences = test_api_client.get("/users/preferences", headers=authorization_header)
        assert response_get_preferences.status_code == 200
        assert response_get_preferences.json() == []

        # Set preferences
        response_set_preferences = test_api_client.post(
            "/users/preferences",
            json=invalid_user_preferences,
            headers=authorization_header
        )
        assert response_set_preferences.status_code == 422  # Unprocessable entity

        # Confirm
        response_get_preferences = test_api_client.get("/users/preferences", headers=authorization_header)
        assert response_get_preferences.status_code == 200
        assert response_get_preferences.json() == []

    def test_valid_set_user_preferences_flow(
            self, test_api_client,
            registered_user_json,
            valid_user_preferences
    ):
        """signs in the already registered user, sets preferences then gets them confirming the setup"""
        # Sign in
        response_sign_in = test_api_client.post("/users/sign_in", json=registered_user_json)
        assert response_sign_in.status_code == 200  # successful login

        # Create authorization header
        authorization_header = generate_auth_header(response_sign_in)

        # Confirm originally no preferences
        response_get_preferences = test_api_client.get("/users/preferences", headers=authorization_header)
        assert response_get_preferences.status_code == 200
        assert response_get_preferences.json() == []

        # Set preferences
        response_set_preferences = test_api_client.post(
            "/users/preferences",
            json=valid_user_preferences,
            headers=authorization_header
        )
        assert response_set_preferences.status_code == 204  # No content

        # Confirm set correctly
        response_get_preferences = test_api_client.get("/users/preferences", headers=authorization_header)
        assert response_get_preferences.status_code == 200
        assert response_get_preferences.json() == valid_user_preferences

    def test_update_user_preferences_flow(
            self, test_api_client,
            registered_user_json,
            valid_user_preferences
    ):
        """signs in the already registered user, sets preferences then gets them confirming the setup"""
        # Sign in
        response_sign_in = test_api_client.post("/users/sign_in", json=registered_user_json)
        assert response_sign_in.status_code == 200  # successful login

        # Create authorization header
        authorization_header = generate_auth_header(response_sign_in)

        # Confirm original preferences
        response_get_preferences = test_api_client.get("/users/preferences", headers=authorization_header)
        assert response_get_preferences.status_code == 200
        assert response_get_preferences.json() == valid_user_preferences  # from prev test

        updated_preferences = ["general"]

        # Update preferences
        response_set_preferences = test_api_client.put(
            "/users/preferences",
            json=updated_preferences,
            headers=authorization_header
        )
        assert response_set_preferences.status_code == 204  # No content

        # Confirm set correctly
        response_get_preferences = test_api_client.get("/users/preferences", headers=authorization_header)
        assert response_get_preferences.status_code == 200
        assert response_get_preferences.json() == updated_preferences
