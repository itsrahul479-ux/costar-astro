from fastapi import APIRouter, HTTPException
from models.user import UserSignupRequest, UserLoginRequest
from models.responses import success_response, error_response
from services.auth_service import signup_user, login_user

router = APIRouter(prefix="/auth", tags=["Authentication"])


@router.post("/signup")
async def signup(request: UserSignupRequest):
    """Register a new user account."""
    result = await signup_user(request)
    if "error" in result:
        raise HTTPException(status_code=400, detail=result["error"])
    return success_response(data=result, message="Account created successfully")


@router.post("/login")
async def login(request: UserLoginRequest):
    """Login with email and password."""
    result = await login_user(request)
    if "error" in result:
        raise HTTPException(status_code=401, detail=result["error"])
    return success_response(data=result, message="Login successful")
