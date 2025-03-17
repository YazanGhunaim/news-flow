"""Main entry point to the NewsFlow API"""
import logging

from fastapi import FastAPI
from starlette import status

from app.routers import articles, users, users_auth

# configuring logger
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
    datefmt="date: [%d-%m-%y] | time: [%H:%M:%S]"
)

log = logging.getLogger(__name__)
log.info("Starting NewsFlow!")

app = FastAPI()

app.include_router(articles.router)
app.include_router(users_auth.router)
app.include_router(users.router)


@app.get("/", status_code=status.HTTP_200_OK)
def root():
    """root endpoint"""
    return "NewsFlow is up and running"
