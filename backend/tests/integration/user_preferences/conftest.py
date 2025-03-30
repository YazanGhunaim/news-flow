"""fixtures for user_pref tests"""
import pytest


@pytest.fixture
def valid_user_preferences():
    """selected user preferences"""
    return ["business", "technology"]


@pytest.fixture
def invalid_user_preferences():
    """selected user preferences outside provided preferences"""
    return ["yazan", "ghunaim"]
