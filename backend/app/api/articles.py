"""article related endpoints

Unregistered users are still able to access endpoints:
/top-headlines
/everything
"""
from fastapi import APIRouter
from fastapi.params import Depends
from gotrue.errors import AuthApiError
from starlette import status
from starlette.exceptions import HTTPException
from starlette.responses import JSONResponse
from supabase import Client

from app.database.models.article_summary import ArticleSummary
from app.database.repositories.article_summary_repo import ArticleSummaryRepository
from app.database.repositories.bookmarked_article_repo import BookmarkedArticleRepository
from app.dependencies.auth import get_auth_headers
from app.dependencies.news_service import get_news_service
from app.dependencies.supabase_client import get_supabase_client
from app.schemas.auth_tokens import AuthTokens
from app.schemas.news_articles import NewsCategory, ProcessedArticle, ProcessedNewsResponse
from app.services.article_summary_service import ArticleSummaryService
from app.services.bookmarked_article_service import BookmarkedArticleService
from app.services.news_service import NewsService
from app.utils.article_utils import ArticleUtils
from app.utils.auth import InvalidAuthHeaderError, set_supabase_session

router = APIRouter(prefix="/articles", tags=["News Articles"])


@router.get("/top-headlines", status_code=status.HTTP_200_OK, responses={
    status.HTTP_200_OK: {"description": "Successfully retrieved top headlines."},
    status.HTTP_400_BAD_REQUEST: {"description": "An error occurred while retrieving top headlines."},
}, response_model=ProcessedNewsResponse)
def get_top_headlines(
        keyword: str = None, sources: str = None, category: NewsCategory = None, page: int = None,
        page_size: int = None, language: str = "en",
        news_service: NewsService = Depends(get_news_service),
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
        news_service: NewsService = Depends(get_news_service),
):
    """retrieves every available article"""
    try:
        headlines = news_service.fetch_everything(keyword, page, page_size, sources, language)

        processed_articles = ArticleUtils.process_articles(articles=headlines.articles)

        return ProcessedNewsResponse(total_results=headlines.total_results, articles=processed_articles)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}") from e


@router.post("/bookmark", status_code=status.HTTP_204_NO_CONTENT, responses={
    status.HTTP_204_NO_CONTENT: {"description": "Successfully bookmarked article."},
    status.HTTP_401_UNAUTHORIZED: {"description": "User tokens are invalid."},
    status.HTTP_400_BAD_REQUEST: {"description": "An error occurred while bookmarking article."},
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

        article_service = BookmarkedArticleService(BookmarkedArticleRepository(supabase_client))
        article_service.create_bookmarked_article(article, uid)
    except (AuthApiError, InvalidAuthHeaderError) as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.post(
    "/summary",
    status_code=status.HTTP_200_OK,
    response_model=ArticleSummary,
    responses={
        status.HTTP_200_OK: {"description": "Successfully retrieved summary."},
        status.HTTP_201_CREATED: {"description": "Successfully summarized article."},
        status.HTTP_401_UNAUTHORIZED: {"description": "User tokens are invalid."},
        status.HTTP_400_BAD_REQUEST: {"description": "An error occurred while summarizing article."},
    })
def summarize_article(
        article: ProcessedArticle,
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client),
):
    """Summarizes an article

    if an article already has an existing summary it retrieves it
    """
    try:
        # Set user session
        set_supabase_session(auth=auth, supabase_client=supabase_client)

        article_service = ArticleSummaryService(ArticleSummaryRepository(supabase_client))
        article_summary, is_new = article_service.create_article_summary(article)

        return JSONResponse(
            article_summary,
            status_code=status.HTTP_201_CREATED if is_new else status.HTTP_200_OK
        )
    except (AuthApiError, InvalidAuthHeaderError) as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.delete(
    "/summary",
    status_code=status.HTTP_204_NO_CONTENT,
    responses={
        status.HTTP_204_NO_CONTENT: {"description": "Successfully deleted summary."},
        status.HTTP_401_UNAUTHORIZED: {"description": "User tokens are invalid."},
        status.HTTP_400_BAD_REQUEST: {"description": "An error occurred while summarizing article."},
    })
def delete_summary(
        article_url: str,
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client),
):
    """deletes a summary of an article"""
    try:
        # Set user session
        set_supabase_session(auth=auth, supabase_client=supabase_client)

        article_service = ArticleSummaryService(ArticleSummaryRepository(supabase_client))
        article_service.delete_summary(article_url)
    except (AuthApiError, InvalidAuthHeaderError) as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")
