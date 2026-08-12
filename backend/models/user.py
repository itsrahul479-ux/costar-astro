from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime


# --- Request Models ---

class UserSignupRequest(BaseModel):
    email: str
    password: str
    name: str


class UserLoginRequest(BaseModel):
    email: str
    password: str


class BirthProfileRequest(BaseModel):
    name: str
    birth_date: str          # "YYYY-MM-DD"
    birth_time: Optional[str] = None   # "HH:MM"
    birth_city: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    timezone: Optional[str] = None


# --- Response Models ---

class UserResponse(BaseModel):
    id: str
    email: str
    name: Optional[str] = None
    created_at: Optional[datetime] = None


class AuthResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserResponse


class BirthProfileResponse(BaseModel):
    id: str
    user_id: str
    name: str
    birth_date: str
    birth_time: Optional[str] = None
    birth_city: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    timezone: Optional[str] = None
