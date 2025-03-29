"""Implementation for user repository"""
from typing import List

from supabase import Client

from app.database.repositories.abstract_repo import ABCRepository
from app.schemas.news_articles import NewsCategory


class UserRepository(ABCRepository):
    """User repository class

    for interactions with the user db
    """

    def __init__(self, supabase_client: Client):
        """see class doc"""
        super().__init__(supabase_client)

    def add_user_preference(self, uid: str, category_id):
        """adds user preference data to db"""
        response = (
            self.db
            .table("user_preferences")
            .insert({"user_id": uid, "category_id": category_id})
            .execute()
        )
        return response

    def get_user_preferences(self, uid: str) -> List[NewsCategory]:
        """gets list of user preferences"""
        response = (
            self.db
            .table("user_preferences")
            .select("news_categories(category)")
            .eq("user_id", uid)
            .execute()
        )

        return [item["news_categories"]["category"] for item in response.data]
