"""article related endpoints"""
from fastapi import APIRouter
from fastapi.params import Depends
from starlette import status
from starlette.exceptions import HTTPException

from dependencies.news_service import get_news_service
from schemas.news_articles import NewsCategory, ProcessedNewsResponse
from services.news_service import NewsService
from utils.article_utils import ArticleUtils

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
