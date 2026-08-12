import json
from typing import Any, Optional
from core.cache import cache_client


async def cache_get(key: str) -> Optional[Any]:
    """Get value from cache (Redis or in-memory fallback)."""
    return cache_client.get(key)


async def cache_set(key: str, value: Any, ttl_seconds: int = 3600) -> bool:
    """Set value in cache with TTL."""
    return cache_client.set(key, value, ttl_seconds)


async def cache_delete(key: str) -> bool:
    """Delete a key from cache."""
    cache_client.delete(key)
    return True


# Cache key builders
def chart_key(user_id: str) -> str:
    return f"chart:{user_id}"

def daily_key(user_id: str, date: str) -> str:
    return f"daily:{user_id}:{date}"

def profile_key(user_id: str) -> str:
    return f"profile:{user_id}"

def compat_key(pair_hash: str) -> str:
    return f"compat:{pair_hash}"

# TTL constants (seconds)
CHART_TTL = 86400        # 24h — chart doesn't change
DAILY_TTL = 86400        # 24h — one per day
PROFILE_TTL = 3600       # 1h
COMPAT_TTL = 604800      # 7 days
