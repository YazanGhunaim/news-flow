"""Implementation for user service"""
from typing import List

from app.database.repositories.user_repo import UserRepository
from app.schemas.news_articles import NewsCategory
from app.services.news_category_service import NewsCategoryService


class UserService:
    """User service class

    Contains business logic and interacts with the user repository
    """

    def __init__(self, repo: UserRepository, news_category_service: NewsCategoryService):
        """Initialize UserService with dependencies"""
        self.repo = repo
        self.news_category_service = news_category_service

    def fetch_user(self, uid: str):
        """fetches user data from repo"""
        return self.repo.get_user(uid)

    def add_user_preferences(
            self,
            uid: str,
            preferences: List[NewsCategory]
    ):
        """adds user preference to junction table

        category id and user id
        """
        category_response = self.news_category_service.fetch_categories_by_value(preferences)
        for item in category_response.data:
            self.repo.add_user_preference(uid, item["id"])

    def fetch_user_preferences(self, uid: str) -> List[NewsCategory]:
        """return list of user preferences"""
        return self.repo.get_user_preferences(uid)

    def update_user_preferences(self, uid: str, preferences: List[NewsCategory]):
        """updates user preferences in junction table"""
        category_response = self.news_category_service.fetch_categories_by_value(preferences)
        category_ids = [item["id"] for item in category_response.data]
        self.repo.update_user_preferences(uid, category_ids)
