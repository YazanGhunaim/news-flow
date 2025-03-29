"""Implementation for news category"""
from typing import List

from app.database.repositories.news_category_repo import NewsCategoryRepository
from app.schemas.news_articles import NewsCategory


class NewsCategoryService:
    """NewsCategory service class

    Contains business logic and interacts with the NewsCategory repository
    """

    def __init__(self, repo: NewsCategoryRepository):
        """see class doc"""
        self.repo = repo

    def fetch_categories_by_value(self, categories: List[NewsCategory]):
        """return categories and their associated db table id's using the value"""
        categories = [category.value for category in categories]
        response = self.repo.find_categories_by_value(categories)
        return response
