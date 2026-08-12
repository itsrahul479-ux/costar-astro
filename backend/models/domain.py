from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

class UserProfile(BaseModel):
    user_id: str
    name: str
    date_of_birth: str  # YYYY-MM-DD
    time_of_birth: str  # HH:MM
    city: str
    latitude: float
    longitude: float

class PlanetPosition(BaseModel):
    name: str
    sign: str
    degree: float
    house: int
    is_retrograde: bool

class HousePlacement(BaseModel):
    house: int
    sign: str
    degree: float

class NatalChart(BaseModel):
    sun_sign: str
    moon_sign: str
    rising_sign: str
    planets: List[PlanetPosition]
    houses: List[HousePlacement]

class DailyInsightRequest(BaseModel):
    user_id: str
    
class DailyInsightResponse(BaseModel):
    date: str
    theme: str
    reading: str
    power_areas: List[str]
    challenge_areas: List[str]

class CompatibilityRequest(BaseModel):
    user_id_1: str
    user_id_2: str

class CompatibilityResponse(BaseModel):
    score: int
    synastry_summary: str
    dynamic_name: str
