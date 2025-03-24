"""tests for article parser"""
import pytest

from app.utils.article_parser import ArticleHTMLParser


@pytest.mark.unit
def test_parse_valid_article(base_article_fixture):
    """Tests successfully article parsing"""
    try:
        ArticleHTMLParser.parse_article(base_article_fixture.url)
        assert True
    except Exception as e:
        pytest.fail(f"Parsing article failed: {e}")


@pytest.mark.unit
def test_parse_invalid_article(base_article_fixture):
    """Tests unsuccessful article parsing"""
    with pytest.raises(Exception):
        ArticleHTMLParser.parse_article(base_article_fixture.author)  # not a valid url
