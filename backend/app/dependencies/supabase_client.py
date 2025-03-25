"""supabase client dependency"""
from supabase import Client, create_client

from app.config import get_config

# env config
config = get_config()

supabase_prod: Client = create_client(
    supabase_url=config.supabase_prod_url,
    supabase_key=config.supabase_prod_service_key,
)

supabase_local: Client = create_client(
    supabase_url=config.supabase_local_url,
    supabase_key=config.supabase_local_service_key,
)


def get_supabase_client() -> Client:
    """gets an initialized supabase client based on supabase env"""
    if config.supabase_is_prod:
        return supabase_prod
    return supabase_local
