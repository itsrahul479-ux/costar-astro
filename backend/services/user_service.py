from typing import Optional
from core.database import get_supabase_client
from models.user import BirthProfileRequest
from services.cache_service import cache_get, cache_set, cache_delete, profile_key, PROFILE_TTL


async def get_user_profile(user_id: str) -> Optional[dict]:
    """Get user + birth profile. Redis-cached."""
    cached = await cache_get(profile_key(user_id))
    if cached:
        return cached

    try:
        supabase = get_supabase_client()
        if supabase:
            user_res = supabase.table("users").select("id, email, name, created_at").eq("id", user_id).execute()
            profile_res = supabase.table("birth_profiles").select("*").eq("user_id", user_id).execute()

            if not user_res.data:
                return None

            profile = {
                "user": user_res.data[0],
                "birth_profile": profile_res.data[0] if profile_res.data else None
            }
            await cache_set(profile_key(user_id), profile, PROFILE_TTL)
            return profile

        # Mock mode
        return {
            "user": {"id": user_id, "email": "user@example.com", "name": "Rahul"},
            "birth_profile": None
        }
    except Exception as e:
        return {"error": str(e)}


async def save_birth_profile(user_id: str, request: BirthProfileRequest) -> dict:
    """Save or update user birth profile."""
    try:
        supabase = get_supabase_client()
        data = {
            "user_id": user_id,
            "name": request.name,
            "birth_date": request.birth_date,
            "birth_time": request.birth_time,
            "birth_city": request.birth_city,
            "latitude": request.latitude,
            "longitude": request.longitude,
            "timezone": request.timezone,
        }

        if supabase:
            # Upsert by user_id
            existing = supabase.table("birth_profiles").select("id").eq("user_id", user_id).execute()
            if existing.data:
                result = supabase.table("birth_profiles").update(data).eq("user_id", user_id).execute()
            else:
                result = supabase.table("birth_profiles").insert(data).execute()

            # Invalidate cache
            await cache_delete(profile_key(user_id))
            return result.data[0] if result.data else data

        return data
    except Exception as e:
        return {"error": str(e)}
