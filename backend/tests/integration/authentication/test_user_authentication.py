"""User authentication integration test"""
import pytest

from app.dependencies.supabase_client import get_supabase_client
from app.main import app
from tests.integration.conftest import generate_auth_header


@pytest.mark.integration
@pytest.mark.auth
class TestUserAuth:
    """User auth flow e2e tests"""

    def test_successful_user_flow(self, test_api_client, user_model_json, test_supabase_project_client):
        """Golden path of user authentication"""
        # Override dependency to test clients
        app.dependency_overrides[get_supabase_client] = lambda: test_supabase_project_client

        # Sign Up
        response_sign_up = test_api_client.post("/users/sign_up", json=user_model_json)
        assert response_sign_up.status_code == 200

        # Create authorization header
        authorization_header = generate_auth_header(response_sign_up)

        try:
            # Sign in
            response_sign_in = test_api_client.post("/users/sign_in", json=user_model_json)
            assert response_sign_in.status_code == 200
            assert response_sign_in.json()["user"]["user_metadata"]["email"] == "test@example.com"

            # Assert auth tokens retrieved
            assert response_sign_in.json()["session"]["access_token"]
            assert response_sign_in.json()["session"]["refresh_token"]

            # Update
            user_email_update_body = {"email": "test2@example.com"}
            response_update = test_api_client.put("/users/update", json=user_email_update_body,
                                                  headers=authorization_header)
            assert response_update.status_code == 200
            assert response_update.json()["user"]["new_email"] == "test2@example.com"
        finally:
            # Delete
            response_delete = test_api_client.delete("/users/delete", headers=authorization_header)
            assert response_delete.status_code == 204  # No content

    def test_unauthorized_user_update_flow(self, test_api_client, user_model_json, test_supabase_project_client):
        """Tries to update user metadata using invalid authorization header        """
        # Override dependency to test clients
        app.dependency_overrides[get_supabase_client] = lambda: test_supabase_project_client

        # Sign Up
        response_sign_up = test_api_client.post("/users/sign_up", json=user_model_json)
        assert response_sign_up.status_code == 200

        # Create authorization header
        authorization_header = generate_auth_header(response_sign_up)

        try:
            # Sign in
            response_sign_in = test_api_client.post("/users/sign_in", json=user_model_json)
            assert response_sign_in.status_code == 200
            assert response_sign_in.json()["user"]["user_metadata"]["email"] == "test@example.com"

            # Assert auth tokens retrieved
            assert response_sign_in.json()["session"]["access_token"]
            assert response_sign_in.json()["session"]["refresh_token"]

            # Update
            # Invalid auth header
            invalid_auth_header = {
                "Authorization": f"Bearer abc",
                "refresh-token": "abc"
            }

            user_email_update_body = {"email": "test2@example.com"}
            response_update = test_api_client.put("/users/update", json=user_email_update_body,
                                                  headers=invalid_auth_header)  # invalid auth header
            assert response_update.status_code == 401  # unauthorized
        finally:
            # Delete
            response_delete = test_api_client.delete("/users/delete", headers=authorization_header)
            assert response_delete.status_code == 204  # No content

    def test_invalid_user_email_sign_up(self, test_api_client, user_model_json, test_supabase_project_client):
        """Tries to sign up user with invalid email format"""
        # Override dependency to test clients
        app.dependency_overrides[get_supabase_client] = lambda: test_supabase_project_client

        user_model_json["email"] = "x"
        response_sign_up = test_api_client.post("/users/sign_up", json=user_model_json)
        assert response_sign_up.status_code == 422  # unprocessable entity

    def test_user_does_not_exist_sign_in(self, test_api_client, user_model_json, test_supabase_project_client):
        """Tries to sign in that does not exist"""
        # Override dependency to test clients
        app.dependency_overrides[get_supabase_client] = lambda: test_supabase_project_client

        response_sign_in = test_api_client.post("/users/sign_in", json=user_model_json)
        assert response_sign_in.status_code == 401  # Unauthorized

    def test_user_already_registered_sign_up(self, test_api_client, registered_user_json, test_supabase_project_client):
        """Tries to sign up user twice"""
        # Override dependency to test clients
        app.dependency_overrides[get_supabase_client] = lambda: test_supabase_project_client

        response_sign_up = test_api_client.post("/users/sign_up", json=registered_user_json)
        assert response_sign_up.status_code == 409  # Conflict
