import redis
from core.config import settings
import json
from typing import Any, Optional

class CacheClient:
    def __init__(self):
        self.client = redis.Redis.from_url(settings.REDIS_URL, decode_responses=True)

    def get(self, key: str) -> Optional[Any]:
        value = self.client.get(key)
        if value:
            return json.loads(value)
        return None

    def set(self, key: str, value: Any, expiration_seconds: int = 86400) -> bool:
        """Default expiration is 24 hours"""
        return self.client.setex(key, expiration_seconds, json.dumps(value))
        
    def delete(self, key: str) -> int:
        return self.client.delete(key)

cache_client = CacheClient()
