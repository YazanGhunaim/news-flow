"""AI client to interact with LLMs"""

from logging import getLogger

import openai
from openai import LengthFinishReasonError

from app.config import get_config
from app.dependencies.news_service import get_news_service
from app.schemas.news_articles import ProcessedArticle
from app.utils.article_utils import ArticleUtils
from app.utils.llm_prompts import SUMMARIZE_NEWS_ARTICLE

log = getLogger(__name__)


class AIClient:
    """provides an interface to interact with LLMs"""

    MODEL = "gpt-4o-mini"

    def __init__(self):
        """see class doc"""
        self.config = get_config()
        self._client = openai.OpenAI(api_key=self.config.openai_key)

    def summarize_article_content(self, article: ProcessedArticle):
        """
        Takes in a ProcessedArticle model and summarizes its contents

        :param article: ProcessedArticle
        """
        log.info(f"Requesting summary generation for article with url: {article.url}.")
        try:
            completion = self._client.chat.completions.create(
                model=AIClient.MODEL,
                messages=[
                    {
                        "role": "system",
                        "content": SUMMARIZE_NEWS_ARTICLE},
                    {
                        "role": "user",
                        "content": f"full content: {article.content}"
                    }
                ],
                # response_format=,
                # max_tokens=50
            )
            response = completion.choices[0].message
            if response.refusal:
                log.error("LLM Refused to process query.")
                raise ValueError(f"LLM Refused to process query: {response.refusal}")

            log.info(f"Successful summary generation for article with url: {article.url}.")
            return response.content
        except LengthFinishReasonError as e:
            log.error(f"Token limit exceeded: {e}")
            raise RuntimeError(f"Token limit exceeded: {e}") from e
        except Exception as e:
            log.error(f"An unexpected error occurred: {e}")
            raise RuntimeError(f"An unexpected error occurred: {e}") from e


if __name__ == "__main__":
    client = AIClient()
    news_service = get_news_service()
    headlines = news_service.fetch_everything("prague", page_size=2)

    processed_articles = ArticleUtils.process_articles(articles=headlines.articles)
    print(client.summarize_article_content(article=processed_articles[0]))
