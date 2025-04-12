"""Global fixtures / constants / functions for integration tests"""
import pytest
from fastapi.testclient import TestClient
from supabase import create_client

from app.config import get_config
from app.dependencies.supabase_client import get_supabase_client
from app.main import app

config = get_config()


@pytest.fixture(scope="session")
def test_supabase_project_client():
    """Supabase client for news flow test project"""
    return create_client(supabase_url=config.supabase_local_url,
                         supabase_key=config.supabase_local_service_key)  # cant create new supabase project as it requires subscription


@pytest.fixture(scope="session")
def test_api_client():
    """Test client for fast api"""
    return TestClient(app)


@pytest.fixture(scope="session", autouse=True)
def override_supabase_client(test_supabase_project_client):
    """override Supabase client for all tests in session

    Then clear the override
    """
    app.dependency_overrides[get_supabase_client] = lambda: test_supabase_project_client
    yield
    app.dependency_overrides.clear()


@pytest.fixture(scope="session")
def registered_user_json():
    """Json of already registered user

    see setup_user_table
    """
    return {
        "email": "yazan_test@example.com",
        "password": "password",
        "options":
            {
                "data": {
                    "username": "yazanlouaighunaim",
                    "name": "Yazan Ghunaim"
                }
            }
    }


@pytest.fixture(scope="session", autouse=True)
def setup_user_table(test_api_client, test_supabase_project_client, registered_user_json):
    """Registers users as seeded data

    deletes it after the test session
    """
    # Override dependency to test clients
    app.dependency_overrides[get_supabase_client] = lambda: test_supabase_project_client

    # Register user
    response_sign_up = test_api_client.post("/users/sign_up", json=registered_user_json)

    # Create authorization header
    authorization_header = generate_auth_header(response_sign_up)

    yield

    # Delete user
    test_api_client.delete("/users/delete", headers=authorization_header)


@pytest.fixture(scope="function")
def user_model_json():
    """User sign up json fixture

    Can be used for user login and update
    """
    return {
        "email": "test@example.com",
        "password": "password123",
        "options":
            {
                "data": {
                    "username": "yazan",
                    "name": "Yazan Ghunaim"
                }
            }
    }


@pytest.fixture
def processed_article_json():
    """returns a processed article json"""
    return {
        "source": {
            "name": "TechCrunch"
        },
        "author": "John Doe",
        "title": "AI Revolutionizes News Processing",
        "description": "A deep dive into how AI is changing the landscape of journalism.",
        "url": "https://example.com/article123",
        "image_url": "https://example.com/article123/image.jpg",
        "date": "2025-03-23",
        "content": "Artificial Intelligence is playing a major role in transforming how news articles are processed and delivered..."
    }


def generate_auth_header(response):
    """helper method to generate auth header from response"""
    access_token = response.json()["session"]["access_token"]
    refresh_token = response.json()["session"]["refresh_token"]

    return {
        "Authorization": f"Bearer {access_token}",
        "refresh-token": refresh_token
    }
