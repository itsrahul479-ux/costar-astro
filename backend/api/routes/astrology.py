from fastapi import APIRouter, HTTPException
from models.domain import UserProfile, NatalChart, DailyInsightResponse, CompatibilityRequest, CompatibilityResponse
from services.ephemeris import calculate_natal_chart
from services.gemini import get_daily_insight
from core.cache import cache_client

router = APIRouter()

@router.post("/chart", response_model=NatalChart)
async def generate_chart(profile: UserProfile):
    # Parse date and time
    try:
        year, month, day = map(int, profile.date_of_birth.split('-'))
        hour_str, min_str = profile.time_of_birth.split(':')
        # Convert to decimal hour
        hour_decimal = int(hour_str) + (int(min_str) / 60.0)
    except Exception as e:
        raise HTTPException(status_code=400, detail="Invalid date or time format")

    # Generate Chart
    chart = calculate_natal_chart(
        year=year,
        month=month,
        day=day,
        hour=hour_decimal,
        lat=profile.latitude,
        lon=profile.longitude
    )
    
    return chart

@router.get("/insights/daily", response_model=DailyInsightResponse)
async def get_daily(user_id: str):
    # Try cache first
    cache_key = f"daily_insight_{user_id}"
    cached_data = cache_client.get(cache_key)
    
    if cached_data:
        return DailyInsightResponse(**cached_data)

    # In a real app, fetch UserProfile from Supabase using user_id
    # For now, we'll create a dummy profile to generate the chart
    dummy_profile = UserProfile(
        user_id=user_id,
        name="User",
        date_of_birth="1990-01-01",
        time_of_birth="12:00",
        city="New York",
        latitude=40.7128,
        longitude=-74.0060
    )
    
    # Calculate chart
    chart = calculate_natal_chart(
        year=1990, month=1, day=1, hour=12.0, lat=40.7128, lon=-74.0060
    )
    
    # Get AI reading
    insight = get_daily_insight(chart)
    
    # Cache for 24 hours
    cache_client.set(cache_key, insight.model_dump(), expiration_seconds=86400)
    
    return insight

@router.post("/compatibility", response_model=CompatibilityResponse)
async def get_compatibility(req: CompatibilityRequest):
    # Dummy implementation for compatibility
    return CompatibilityResponse(
        score=85,
        synastry_summary="Your Sun signs are highly compatible. There's a natural flow of energy.",
        dynamic_name="The Catalyst & The Dreamer"
    )
