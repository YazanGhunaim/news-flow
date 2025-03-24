"""user auth related endpoints"""
from fastapi import APIRouter, Depends, HTTPException
from gotrue import AuthResponse, UserResponse
from gotrue.errors import AuthApiError, AuthInvalidCredentialsError
from starlette import status
from supabase import Client

from app.dependencies.auth import get_auth_headers
from app.dependencies.supabase_client import get_supabase_client
from app.schemas.auth_tokens import AuthTokens
from app.schemas.users import UserSignIn, UserSignUp, UserUpdate
from app.utils.auth import set_supabase_session

router = APIRouter(prefix="/users", tags=["User Auth"])


@router.post("/sign_up", status_code=status.HTTP_200_OK, responses={
    status.HTTP_200_OK: {"description": "User signed up successfully."},
    status.HTTP_409_CONFLICT: {"description": "User already exists."},
    status.HTTP_400_BAD_REQUEST: {"description": "User sign up failed."},
})
def sign_up(user: UserSignUp, supabase_client: Client = Depends(get_supabase_client)) -> AuthResponse:
    """signs up user via email and password using supabase

    :param user: UserSignUp pydantic model
    :param supabase_client: supabase client dep injection
    :return: AuthResponse object
    """
    try:
        response = supabase_client.auth.sign_up(user.model_dump(exclude_unset=True))
        return response
    except AuthApiError as e:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=f"{e}")
    except (AuthInvalidCredentialsError, Exception) as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=f"{e}")


@router.post("/sign_in", status_code=status.HTTP_200_OK, responses={
    status.HTTP_200_OK: {"description": "User signed in successfully."},
    status.HTTP_401_UNAUTHORIZED: {"description": "User sign in failed."},
})
def sign_in(user: UserSignIn, supabase_client: Client = Depends(get_supabase_client)) -> AuthResponse:
    """Signs in user

    :param user: UserLogin pydantic model
    :param supabase_client: supabase client
    :return: Auth response object
    """
    try:
        response = supabase_client.auth.sign_in_with_password(user.model_dump())
        return response
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")


@router.post(
    "/sign_out",
    status_code=status.HTTP_204_NO_CONTENT,
    responses={
        status.HTTP_204_NO_CONTENT: {"description": "User signed out successfully."},
        status.HTTP_401_UNAUTHORIZED: {"description": "User sign out failed."},
    }
)
def sign_out(
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client)
) -> None:
    """Signs out user

    :param auth: AuthHeaders object
    :param supabase_client: supabase client
    """
    try:
        set_supabase_session(auth=auth, supabase_client=supabase_client)
        supabase_client.auth.sign_out()
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")


@router.put("/update", responses={
    status.HTTP_200_OK: {"description": "User updated successfully."},
    status.HTTP_401_UNAUTHORIZED: {"description": "User update failed."},
})
def update_user(
        user: UserUpdate,
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client)) -> UserResponse:
    """Updates user data

    :return: UserResponse
    """
    try:
        set_supabase_session(auth=auth, supabase_client=supabase_client)
        response = supabase_client.auth.update_user(user.model_dump(exclude_unset=True))
        return response
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")


@router.delete(
    "/delete",
    status_code=status.HTTP_204_NO_CONTENT,
    responses={
        status.HTTP_204_NO_CONTENT: {"description": "User deleted successfully."},
        status.HTTP_401_UNAUTHORIZED: {"description": "User deletion failed."},
    }
)
def delete_user(
        auth: AuthTokens = Depends(get_auth_headers),
        supabase_client: Client = Depends(get_supabase_client)
) -> None:
    """Deletes user account associated with uid

    :param auth: AuthHeaders object
    :param supabase_client: supabase client
    """
    try:
        auth_response = set_supabase_session(auth=auth, supabase_client=supabase_client)

        # get user id
        uid = auth_response.session.user.id
        # sign out due to service role being overridden https://github.com/supabase/auth/issues/965
        supabase_client.auth.sign_out()

        # delete user
        supabase_client.auth.admin.delete_user(uid)
    except Exception as e:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"{e}")
