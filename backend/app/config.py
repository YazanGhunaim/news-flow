"""Project config interface"""
import os
from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict

DOTENV = os.path.join(os.path.dirname(__file__), ".env")


class Config(BaseSettings):
    """pydantic settings class providing interface to .env file"""
    news_api_key: str = ""

    supabase_is_prod: bool = True

    supabase_prod_url: str = ""
    supabase_prod_key: str = ""
    supabase_prod_service_key: str = ""

    supabase_local_url: str = ""
    supabase_local_key: str = ""
    supabase_local_service_key: str = ""

    model_config = SettingsConfigDict(env_file=DOTENV)


@lru_cache
def get_config():
    """getter for config"""
    return Config()

if __name__ == "__main__":
    config = get_config()
    print(config.supabase_prod_url)
