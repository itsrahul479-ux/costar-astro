from typing import Optional, Any
from pydantic import BaseModel


class APIResponse(BaseModel):
    success: bool = True
    data: Optional[Any] = None
    message: Optional[str] = None
    error: Optional[str] = None


def success_response(data: Any = None, message: str = "Success") -> dict:
    return {"success": True, "data": data, "message": message, "error": None}


def error_response(error: str, message: str = "An error occurred") -> dict:
    return {"success": False, "data": None, "message": message, "error": error}
