"""article utils related tests"""
from unittest.mock import patch

from app.schemas.news_articles import ProcessedArticle
from app.utils.article_utils import ArticleUtils


@patch("app.utils.article_parser.ArticleHTMLParser.parse_article")
def test_process_article_success(mock_parse_article, base_article_fixture):
    """Test process_article when parsing succeeds."""
    mock_parse_article.return_value = "Full content of the article."

    result = ArticleUtils.process_article(base_article_fixture)

    assert isinstance(result, ProcessedArticle)
    assert result.title == base_article_fixture.title
    assert result.url == base_article_fixture.url
    assert result.content == "Full content of the article."


@patch("app.utils.article_parser.ArticleHTMLParser.parse_article")
def test_process_article_failure(mock_parse_article, base_article_fixture):
    """Test process_article when parsing fails."""
    mock_parse_article.side_effect = Exception("Parsing error")

    result = ArticleUtils.process_article(base_article_fixture)

    assert result is None


@patch("app.utils.article_parser.ArticleHTMLParser.parse_article")
def test_process_articles_mixed(mock_parse_article, base_article_fixture):
    """Test process_articles with a mix of successful and failed parsing."""
    mock_parse_article.side_effect = [
        "Full content 1",
        Exception("Parsing error"),
        "Full content 2"
    ]

    articles = [base_article_fixture, base_article_fixture, base_article_fixture]
    result = ArticleUtils.process_articles(articles)

    assert len(result) == 2  # One failed, so only two should be processed
    assert isinstance(result[0], ProcessedArticle)
    assert result[0].content == "Full content 1"
    assert result[1].content == "Full content 2"
