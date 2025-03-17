"""Auth token related models"""
from pydantic import BaseModel


class AuthTokens(BaseModel):
    """Authorization tokens

    access_token and refresh_token used to set supabase state
    """
    access_token: str
    refresh_token: str
