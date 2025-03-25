"""Auth dependencies"""
from fastapi import Header

from app.schemas.auth_tokens import AuthTokens


def get_auth_headers(access_token: str = Header(..., alias="Authorization"),
                     refresh_token: str = Header(..., alias="refresh-token")) -> AuthTokens:
    """expects to receive auth token from request headers
    and passes the tokens to endpoints that need them

    :returns AuthHeaders object
    """
    return AuthTokens(access_token=access_token, refresh_token=refresh_token)
