"""Project config interface"""
import os
from functools import lru_cache

from pydantic_settings import BaseSettings

DOTENV = os.path.join(os.path.dirname(__file__), ".env")


class Config(BaseSettings):
    """pydantic settings class providing interface to .env file"""
    news_api_key: str = ""

    class Config:
        env_file = DOTENV


@lru_cache
def get_config():
    """getter for config"""
    return Config()
