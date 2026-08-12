from fastapi import APIRouter, HTTPException, Header
from typing import Optional
from models.user import BirthProfileRequest
from models.responses import success_response, error_response
from services.user_service import get_user_profile, save_birth_profile
from core.security import decode_access_token

router = APIRouter(prefix="/users", tags=["Users"])


def get_current_user_id(authorization: Optional[str] = None) -> str:
    """Extract user_id from Bearer token."""
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Authorization token required")
    token = authorization.replace("Bearer ", "")
    payload = decode_access_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    return payload["sub"]


@router.get("/me")
async def get_my_profile(authorization: Optional[str] = Header(None)):
    """Get current user's profile and birth details."""
    user_id = get_current_user_id(authorization)
    profile = await get_user_profile(user_id)
    if not profile or "error" in profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    return success_response(data=profile)


@router.post("/birth-profile")
async def update_birth_profile(
    request: BirthProfileRequest,
    authorization: Optional[str] = Header(None)
):
    """Save or update the user's birth details."""
    user_id = get_current_user_id(authorization)
    result = await save_birth_profile(user_id, request)
    if "error" in result:
        raise HTTPException(status_code=400, detail=result["error"])
    return success_response(data=result, message="Birth profile saved")
