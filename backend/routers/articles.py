"""article related endpoints"""
from fastapi import APIRouter
from fastapi.params import Depends
from starlette import status
from starlette.exceptions import HTTPException

from dependencies.news_service import get_news_service
from services.news_service import NewsService
from utils.news_article_parser import NewsArticleHTMLParser

router = APIRouter(prefix="/articles", tags=["News Articles"])


# TODO: if appending full content fails, dont fail the entire response, place None and move on

# TODO: Response model
@router.get("/top-headlines", status_code=status.HTTP_200_OK)
def get_top_headlines(
        keyword: str = None, sources: str = None, category: str = None, page: int = None,
        page_size: int = None, language: str = "en",
        news_service: NewsService = Depends(get_news_service)
):
    """retrieves headlining articles"""
    try:
        headlines = news_service.fetch_top_headlines(keyword, sources, category, page, page_size, language)
        for article in headlines["articles"]:
            article["fullContent"] = NewsArticleHTMLParser.parse_article(article["url"])

        return headlines
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.get("/everything", status_code=status.HTTP_200_OK)
def get_everything(
        keyword: str, page: int = None, page_size: int = None, sources: str = None, language: str = "en",
        news_service: NewsService = Depends(get_news_service)
):
    """retrieves every available article"""
    try:
        headlines = news_service.fetch_everything(keyword, page, page_size, sources, language)
        for article in headlines["articles"]:
            article["fullContent"] = NewsArticleHTMLParser.parse_article(article["url"])

        return headlines
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")
