"""Main entry point to the NewsFlow API"""
import logging

from fastapi import FastAPI
from starlette import status
from starlette.responses import RedirectResponse

from app.api import articles, preferences, users, users_auth

# configuring logger
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="date: [%d-%m-%y] | time: [%H:%M:%S]"
)

log = logging.getLogger(__name__)
log.info("Starting NewsFlow!")

app = FastAPI(title="NewsFlow RestAPI")

app.include_router(articles.router)
app.include_router(users_auth.router)
app.include_router(users.router)
app.include_router(preferences.router)


@app.get("/")
def root():
    """root endpoint"""
    return RedirectResponse(url="/docs", status_code=status.HTTP_302_FOUND)


@app.get("/health", status_code=status.HTTP_200_OK)
def health():
    """healthcheck endpoint"""
    return "NewsFlow is up and running"
