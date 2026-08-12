import uuid
from typing import Optional
from core.security import hash_password, verify_password, create_access_token
from core.database import get_supabase_client
from models.user import UserSignupRequest, UserLoginRequest, UserResponse, AuthResponse


async def signup_user(request: UserSignupRequest) -> dict:
    """Create a new user account."""
    try:
        supabase = get_supabase_client()

        # Check if email already exists (mock-safe)
        if supabase:
            existing = supabase.table("users").select("id").eq("email", request.email).execute()
            if existing.data:
                return {"error": "Email already registered"}

            # Create user
            user_id = str(uuid.uuid4())
            user_data = {
                "id": user_id,
                "email": request.email,
                "password_hash": hash_password(request.password),
                "name": request.name,
                "provider": "email"
            }
            result = supabase.table("users").insert(user_data).execute()
            user = result.data[0] if result.data else user_data
        else:
            # Mock mode (no Supabase configured)
            user_id = str(uuid.uuid4())
            user = {"id": user_id, "email": request.email, "name": request.name}

        token = create_access_token({"sub": user["id"], "email": user["email"]})
        return {
            "access_token": token,
            "token_type": "bearer",
            "user": {"id": user["id"], "email": user["email"], "name": request.name}
        }
    except Exception as e:
        return {"error": str(e)}


async def login_user(request: UserLoginRequest) -> dict:
    """Authenticate user and return token."""
    try:
        supabase = get_supabase_client()

        if supabase:
            result = supabase.table("users").select("*").eq("email", request.email).execute()
            if not result.data:
                return {"error": "Invalid email or password"}

            user = result.data[0]
            if not verify_password(request.password, user.get("password_hash", "")):
                return {"error": "Invalid email or password"}
        else:
            # Mock mode
            user = {"id": str(uuid.uuid4()), "email": request.email, "name": "User"}

        token = create_access_token({"sub": user["id"], "email": user["email"]})
        return {
            "access_token": token,
            "token_type": "bearer",
            "user": {"id": user["id"], "email": user["email"], "name": user.get("name", "")}
        }
    except Exception as e:
        return {"error": str(e)}


async def get_user_by_id(user_id: str) -> Optional[dict]:
    """Fetch user profile by ID."""
    try:
        supabase = get_supabase_client()
        if supabase:
            result = supabase.table("users").select("id, email, name, created_at").eq("id", user_id).execute()
            return result.data[0] if result.data else None
        return {"id": user_id, "email": "user@example.com", "name": "User"}
    except Exception:
        return None
