"""fixtures related to user bookmark tests"""
import pytest


@pytest.fixture
def processed_article_json():
    """returns a processed article json"""
    return {
        "source": {
            "id": "techcrunch",
            "name": "TechCrunch"
        },
        "author": "John Doe",
        "title": "AI Revolutionizes News Processing",
        "description": "A deep dive into how AI is changing the landscape of journalism.",
        "url": "https://example.com/article123",
        "image_url": "https://example.com/article123/image.jpg",
        "date": "2025-03-23",
        "content": "Artificial Intelligence is playing a major role in transforming how news articles are processed and delivered..."
    }
