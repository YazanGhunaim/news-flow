"""Implementation of news categories repository"""
from typing import List

from supabase import Client

from app.database.repositories.abstract_repo import ABCRepository
from app.schemas.news_articles import NewsCategory


class NewsCategoryRepository(ABCRepository):
    """News Category Repo class

    interacts with news_categories table in db
    """

    def __init__(self, supabase_client: Client):
        """see class doc"""
        super().__init__(supabase_client)

    def find_categories_by_value(self, categories: List[NewsCategory]):
        """get category id from its enum value"""
        category_response = (
            self.db
            .table("news_categories")
            .select("id, category")
            .in_("category", categories)
            .execute()
        )

        return category_response
