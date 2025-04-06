"""Implementation for preference repository"""
from supabase import Client

from app.database.repositories.abstract_repo import ABCRepository


class PreferenceRepository(ABCRepository):
    """preference repository class

    interacts with preference db
    """

    def __init__(self, supabase_client: Client):
        """see class doc"""
        self.db = supabase_client

    def get_article_categories(self):
        """:returns list of available article categories"""
        response = self.db.table("news_categories").select("*").execute()
        return [data["category"] for data in response.data]
