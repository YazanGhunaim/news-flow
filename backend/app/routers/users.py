"""General user related endpoints"""
import uuid
from typing import List

from fastapi import APIRouter, Depends, HTTPException
from gotrue.errors import AuthApiError
from starlette import status
from supabase import Client

from app.dependencies.auth import get_auth_headers
from app.dependencies.supabase_client import get_supabase_client
from app.schemas.auth_tokens import AuthTokens
from app.schemas.news_articles import NewsCategory, ProcessedArticle
from app.utils.auth import set_supabase_session

router = APIRouter(prefix="/users", tags=["Users"])


@router.post("/preferences", status_code=status.HTTP_204_NO_CONTENT)
def set_user_preferences(
        preferences: List[NewsCategory],
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client)
):
    """Sets user preferences"""
    try:
        # set user session
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        uid = auth_response.session.user.id

        user_category_preferences = [pref.value for pref in preferences]

        # get category table id's
        category_response = (
            supabase_client
            .table("news_categories")
            .select("id, category")
            .in_("category", user_category_preferences)
            .execute()
        )

        category_ids = [item["id"] for item in category_response.data]

        for category_id in category_ids:
            (
                supabase_client
                .table("user_preferences")
                .insert({"user_id": uid, "category_id": category_id})
                .execute()
            )
    except AuthApiError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.get("/preferences", status_code=status.HTTP_200_OK, response_model=List[NewsCategory])
def get_user_preferences(
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client)
):
    try:
        # set user session
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        uid = auth_response.session.user.id

        response = (
            supabase_client
            .table("user_preferences")
            .select("news_categories(category)")
            .eq("user_id", uid)
            .execute()
        )

        return [item["news_categories"]["category"] for item in response.data]
    except AuthApiError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.get("/bookmarks", status_code=status.HTTP_200_OK, response_model=List[ProcessedArticle])
def get_user_bookmarks(
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client)
):
    """Gets articles bookmarked by the user"""
    try:
        # set user session
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        uid = auth_response.session.user.id

        # fetch bookmarked articles
        response = (
            supabase_client
            .table("bookmarked_articles")
            .select("*")
            .eq("user_id", uuid.UUID(uid))
            .execute()
        )

        return response.data
    except AuthApiError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")
