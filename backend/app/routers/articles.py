"""article related endpoints"""
from fastapi import APIRouter
from fastapi.params import Depends
from gotrue.errors import AuthApiError
from starlette import status
from starlette.exceptions import HTTPException
from supabase import Client

from app.dependencies.auth import get_auth_headers
from app.dependencies.news_service import get_news_service
from app.dependencies.supabase_client import get_supabase_client
from app.models.bookmarked_article import BookmarkedArticle
from app.schemas.auth_tokens import AuthTokens
from app.schemas.news_articles import NewsCategory, ProcessedArticle, ProcessedNewsResponse
from app.services.news_service import NewsService
from app.utils.article_utils import ArticleUtils
from app.utils.auth import set_supabase_session

router = APIRouter(prefix="/articles", tags=["News Articles"])


@router.get("/top-headlines", status_code=status.HTTP_200_OK, responses={
    status.HTTP_200_OK: {"description": "Successfully retrieved top headlines."},
    status.HTTP_400_BAD_REQUEST: {"description": "An error occurred while retrieving top headlines."},
}, response_model=ProcessedNewsResponse)
def get_top_headlines(
        keyword: str = None, sources: str = None, category: NewsCategory = None, page: int = None,
        page_size: int = None, language: str = "en",
        news_service: NewsService = Depends(get_news_service)
):
    """retrieves headlining articles"""
    try:
        headlines = news_service.fetch_top_headlines(keyword, sources, category, page, page_size, language)

        processed_articles = ArticleUtils.process_articles(articles=headlines.articles)

        return ProcessedNewsResponse(total_results=headlines.total_results, articles=processed_articles)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.get("/everything", status_code=status.HTTP_200_OK, responses={
    status.HTTP_200_OK: {"description": "Successfully retrieved articles."},
    status.HTTP_400_BAD_REQUEST: {"description": "An error occurred while retrieving articles."},
}, response_model=ProcessedNewsResponse)
def get_everything(
        keyword: str, page: int = None, page_size: int = None, sources: str = None, language: str = "en",
        news_service: NewsService = Depends(get_news_service)
):
    """retrieves every available article"""
    try:
        headlines = news_service.fetch_everything(keyword, page, page_size, sources, language)

        processed_articles = ArticleUtils.process_articles(articles=headlines.articles)

        return ProcessedNewsResponse(total_results=headlines.total_results, articles=processed_articles)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.post("/bookmark", status_code=status.HTTP_204_NO_CONTENT, responses={
    status.HTTP_200_OK: {"description": "Successfully retrieved articles."},
    status.HTTP_401_UNAUTHORIZED: {"description": "User tokens are invalid."},
    status.HTTP_400_BAD_REQUEST: {"description": "An error occurred while retrieving articles."},
})
def bookmark_article(
        article: ProcessedArticle,
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client),
):
    """Bookmarks an article for specific user"""
    try:
        # Set user session and get uid
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)
        uid = auth_response.session.user.id

        # Write Data to bookmarked_articles db
        data = BookmarkedArticle(user_id=uid, **article.model_dump())

        (
            supabase_client.table("bookmarked_articles").insert(data.model_dump()).execute()
        )
    except AuthApiError as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")
