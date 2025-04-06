"""General preferences related endpoints"""
from fastapi import APIRouter, Depends, HTTPException
from starlette import status
from supabase import Client

from app.database.repositories.preference_repository import PreferenceRepository
from app.dependencies.supabase_client import get_supabase_client
from app.services.preference_service import PreferenceService

router = APIRouter(prefix="/preferences", tags=["Preferences"])


@router.get("/categories", status_code=status.HTTP_200_OK)
def get_article_categories(
        supabase_client: Client = Depends(get_supabase_client)
):
    """Gets list of category preferences"""
    try:
        preference_service = PreferenceService(PreferenceRepository(supabase_client))
        return preference_service.get_article_categories()
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")
