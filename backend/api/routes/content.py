from fastapi import APIRouter, HTTPException, Header
from typing import Optional
from models.responses import success_response
from services.chart_service import get_natal_chart, get_daily_reading
from core.security import decode_access_token

router = APIRouter(prefix="/content", tags=["Content"])


def _get_user_id(authorization: Optional[str]) -> str:
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Authorization token required")
    token = authorization.replace("Bearer ", "")
    payload = decode_access_token(token)
    if not payload:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
    return payload["sub"]


@router.get("/daily")
async def get_daily(authorization: Optional[str] = Header(None)):
    """
    Get today's personalized daily reading for the user.
    Uses Redis cache → DB → Gemini AI flow.
    """
    user_id = _get_user_id(authorization)

    # Get user's chart data first (needed for AI context)
    from services.user_service import get_user_profile
    profile = await get_user_profile(user_id)
    birth = profile.get("birth_profile") if profile else None

    if not birth:
        # Return generic reading if no birth data
        return success_response(data={
            "reading_text": "The cosmos await your birth details. Add your birthday to unlock your personalized daily reading.",
            "date": str(__import__("datetime").date.today()),
            "personalized": False
        })

    chart = await get_natal_chart(user_id, birth)
    reading = await get_daily_reading(user_id, chart)
    return success_response(data=reading)
