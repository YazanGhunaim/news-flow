"""General user related endpoints"""
from typing import List

from fastapi import APIRouter, Depends, HTTPException
from gotrue.errors import AuthApiError
from starlette import status
from supabase import Client

from app.database.repositories.bookmarked_article_repo import BookmarkedArticleRepository
from app.database.repositories.news_category_repo import NewsCategoryRepository
from app.database.repositories.user_repo import UserRepository
from app.dependencies.auth import get_auth_headers
from app.dependencies.supabase_client import get_supabase_client
from app.schemas.auth_tokens import AuthTokens
from app.schemas.news_articles import NewsCategory, ProcessedArticle
from app.services.bookmarked_article_service import BookmarkedArticleService
from app.services.news_category_service import NewsCategoryService
from app.services.user_service import UserService
from app.utils.auth import InvalidAuthHeaderError, set_supabase_session

router = APIRouter(prefix="/users", tags=["Users"])

# TODO: Remove bookmark
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

        user_service = UserService(
            UserRepository(supabase_client),
            news_category_service=NewsCategoryService(NewsCategoryRepository(supabase_client))
        )
        user_service.add_user_preferences(uid, preferences)
    except (AuthApiError, InvalidAuthHeaderError) as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.get("/preferences", status_code=status.HTTP_200_OK, response_model=List[NewsCategory])
def get_user_preferences(
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client)
):
    """gets user preferences"""
    try:
        # set user session
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        uid = auth_response.session.user.id

        user_service = UserService(
            UserRepository(supabase_client),
            news_category_service=NewsCategoryService(NewsCategoryRepository(supabase_client))
        )
        return user_service.fetch_user_preferences(uid)
    except (AuthApiError, InvalidAuthHeaderError) as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.put("/preferences", status_code=status.HTTP_204_NO_CONTENT)
def update_user_preferences(
        preferences: List[NewsCategory],
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client)
):
    """Updates user preferences"""
    try:
        # set user session
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        uid = auth_response.session.user.id

        user_service = UserService(
            UserRepository(supabase_client),
            news_category_service=NewsCategoryService(NewsCategoryRepository(supabase_client))
        )
        user_service.update_user_preferences(uid, preferences)
    except (AuthApiError, InvalidAuthHeaderError) as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.get("/bookmarks", status_code=status.HTTP_200_OK, response_model=List[ProcessedArticle])
def get_user_bookmarks(
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client),
):
    """Gets articles bookmarked by the user"""
    try:
        # set user session
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        uid = auth_response.session.user.id

        article_service = BookmarkedArticleService(BookmarkedArticleRepository(supabase_client))
        return article_service.fetch_bookmarks_for_user(uid)
    except (AuthApiError, InvalidAuthHeaderError) as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")
