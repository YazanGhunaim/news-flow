"""Implementation for preference service"""
from app.database.repositories.preference_repository import PreferenceRepository


class PreferenceService:
    """Preference service class

    Contains business logic and interacts with the preference repository
    """

    def __init__(self, repo: PreferenceRepository):
        """Initialize UserService with dependencies"""
        self.repo = repo

    def get_article_categories(self):
        """gets a list of available article categories to follow"""
        return self.repo.get_article_categories()
