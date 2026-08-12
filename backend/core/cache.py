from typing import Any, Optional
import json

_redis_client = None


async def get_redis_client() -> Optional[Any]:
    """
    Returns an async Redis client if available, else None (graceful mock mode).
    """
    global _redis_client
    if _redis_client is not None:
        return _redis_client

    try:
        from core.config import settings
        redis_url = getattr(settings, "REDIS_URL", "")
        if not redis_url or "localhost" in redis_url:
            # Try local Redis
            import redis.asyncio as aioredis
            client = aioredis.from_url("redis://localhost:6379", decode_responses=True)
            await client.ping()
            _redis_client = client
            print("[Cache] Redis connected at localhost:6379")
            return _redis_client
    except Exception as e:
        print(f"[Cache] Redis unavailable, running without cache: {e}")
        return None


# Synchronous fallback client for simple use
class SyncCacheClient:
    """Simple sync cache client — wraps Redis or falls back to in-memory dict."""

    def __init__(self):
        self._memory: dict = {}
        self._client = None
        self._init_redis()

    def _init_redis(self):
        try:
            import redis
            from core.config import settings
            url = getattr(settings, "REDIS_URL", "redis://localhost:6379")
            self._client = redis.from_url(url, decode_responses=True)
            self._client.ping()
            print("[Cache] Sync Redis connected")
        except Exception as e:
            print(f"[Cache] Sync Redis unavailable, using in-memory cache: {e}")
            self._client = None

    def get(self, key: str) -> Optional[Any]:
        try:
            if self._client:
                val = self._client.get(key)
                return json.loads(val) if val else None
            return self._memory.get(key)
        except Exception:
            return self._memory.get(key)

    def set(self, key: str, value: Any, expiration_seconds: int = 86400) -> bool:
        try:
            if self._client:
                return bool(self._client.setex(key, expiration_seconds, json.dumps(value, default=str)))
            self._memory[key] = value
            return True
        except Exception:
            self._memory[key] = value
            return True

    def delete(self, key: str) -> int:
        try:
            if self._client:
                return self._client.delete(key)
            self._memory.pop(key, None)
            return 1
        except Exception:
            self._memory.pop(key, None)
            return 1


# Singleton sync client
cache_client = SyncCacheClient()
