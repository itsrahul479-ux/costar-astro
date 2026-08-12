from fastapi import APIRouter, HTTPException, Header
from pydantic import BaseModel
from typing import Optional
from models.responses import success_response
from services.chart_service import get_natal_chart, get_compatibility
from core.security import decode_access_token

router = APIRouter(prefix="/compatibility", tags=["Compatibility"])


class CompatibilityRequest(BaseModel):
    person_a_birth_date: str
    person_a_birth_time: Optional[str] = "12:00"
    person_a_latitude: Optional[float] = 28.6
    person_a_longitude: Optional[float] = 77.2
    person_b_birth_date: str
    person_b_birth_time: Optional[str] = "12:00"
    person_b_latitude: Optional[float] = 28.6
    person_b_longitude: Optional[float] = 77.2


@router.post("/check")
async def check_compatibility(
    request: CompatibilityRequest,
    authorization: Optional[str] = Header(None)
):
    """
    Calculate compatibility between two birth charts.
    Results are cached by pair_hash for 7 days.
    """
    import hashlib, uuid

    user_id_a = str(uuid.uuid5(uuid.NAMESPACE_DNS, request.person_a_birth_date))
    user_id_b = str(uuid.uuid5(uuid.NAMESPACE_DNS, request.person_b_birth_date))

    chart_a = await get_natal_chart(user_id_a, {
        "birth_date": request.person_a_birth_date,
        "birth_time": request.person_a_birth_time,
        "latitude": request.person_a_latitude,
        "longitude": request.person_a_longitude,
        "timezone": "Asia/Kolkata"
    })

    chart_b = await get_natal_chart(user_id_b, {
        "birth_date": request.person_b_birth_date,
        "birth_time": request.person_b_birth_time,
        "latitude": request.person_b_latitude,
        "longitude": request.person_b_longitude,
        "timezone": "Asia/Kolkata"
    })

    result = await get_compatibility(user_id_a, chart_a, user_id_b, chart_b)
    return success_response(data=result)
