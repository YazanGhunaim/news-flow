"""Main entry point to the NewsFlow API"""
from fastapi import FastAPI
from starlette import status

from routers import articles

app = FastAPI()

app.include_router(articles.router)


@app.get("/", status_code=status.HTTP_200_OK)
def root():
    """root endpoint"""
    return "NewsFlow is up and running"
