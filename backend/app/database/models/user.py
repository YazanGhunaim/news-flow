"""User model in db"""
from pydantic import BaseModel, EmailStr


class User(BaseModel):
    """user along side his id"""

    id: str
    name: str
    username: str
    email: EmailStr
