from typing import Optional
from core.config import settings

_supabase_client = None


def get_supabase_client() -> Optional[object]:
    """
    Returns Supabase client if credentials are configured, else None (mock mode).
    This allows the app to run without real Supabase credentials during development.
    """
    global _supabase_client

    if _supabase_client is not None:
        return _supabase_client

    url = getattr(settings, "SUPABASE_URL", "")
    key = getattr(settings, "SUPABASE_ANON_KEY", "")

    # Return None if credentials are placeholders or missing
    if not url or not key or "your_" in url.lower() or "your_" in key.lower() or key == "your-anon-key":
        return None

    try:
        from supabase import create_client
        _supabase_client = create_client(url, key)
        return _supabase_client
    except Exception as e:
        print(f"[DB] Supabase unavailable, running in mock mode: {e}")
        return None
