"""ABC defining contract for repositories"""
from abc import ABC, abstractmethod

from supabase import Client


class ABCRepository(ABC):
    """see class doc"""

    @abstractmethod
    def __init__(self, supabase_client: Client):
        """abstract initializer for all repositories

        :param supabase_client: Client interface for supabase
        """
        self.db = supabase_client
