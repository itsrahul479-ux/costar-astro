from services.ephemeris import calculate_natal_chart
from services.gemini import generate_daily_reading
from services.cache_service import (
    cache_get, cache_set, chart_key, daily_key, compat_key,
    CHART_TTL, DAILY_TTL, COMPAT_TTL
)
from core.database import get_supabase_client
from datetime import date, datetime
import hashlib


async def get_natal_chart(user_id: str, birth_data: dict) -> dict:
    """
    Get natal chart. Flow:
    Redis → Ephemeris calculation → Cache → Return
    """
    key = chart_key(user_id)
    cached = await cache_get(key)
    if cached:
        cached["from_cache"] = True
        return cached

    # Parse birth data
    try:
        bd = birth_data.get("birth_date", "1990-01-01")
        bt = birth_data.get("birth_time", "12:00") or "12:00"
        dt = datetime.strptime(f"{bd} {bt}", "%Y-%m-%d %H:%M")
        lat = float(birth_data.get("latitude") or 28.6)
        lon = float(birth_data.get("longitude") or 77.2)
    except Exception:
        dt = datetime(1990, 1, 1, 12, 0)
        lat, lon = 28.6, 77.2

    # Calculate via Swiss Ephemeris using correct positional args
    natal = calculate_natal_chart(
        year=dt.year, month=dt.month, day=dt.day,
        hour=dt.hour + dt.minute / 60.0,
        lat=lat, lon=lon
    )

    # Convert Pydantic model → plain dict for JSON serialization
    chart = {
        "sun_sign": natal.sun_sign,
        "moon_sign": natal.moon_sign,
        "rising_sign": natal.rising_sign,
        "planets": {
            p.name: {
                "sign": p.sign,
                "degree": p.degree,
                "house": p.house,
                "retrograde": p.is_retrograde
            } for p in natal.planets
        },
        "houses": [
            {"house": h.house, "sign": h.sign, "degree": h.degree}
            for h in natal.houses
        ],
    }

    await cache_set(key, chart, CHART_TTL)
    chart["from_cache"] = False
    return chart


async def get_daily_reading(user_id: str, chart_data: dict) -> dict:
    """
    Get daily reading. Flow:
    Redis → DB → Gemini AI → Cache → Return
    """
    today = str(date.today())
    key = daily_key(user_id, today)
    cached = await cache_get(key)
    if cached:
        cached["from_cache"] = True
        return cached

    sun_sign = chart_data.get("planets", {}).get("Sun", {}).get("sign", "Aries")
    reading_text = await generate_daily_reading(user_id=user_id, sun_sign=sun_sign, chart_data=chart_data)

    reading = {
        "user_id": user_id,
        "date": today,
        "reading_text": reading_text,
        "sun_sign": sun_sign,
        "from_cache": False
    }

    await cache_set(key, reading, DAILY_TTL)
    return reading


async def get_compatibility(user_id_a: str, chart_a: dict, user_id_b: str, chart_b: dict) -> dict:
    """
    Compatibility with pair-hash caching.
    """
    pair_hash = hashlib.md5("".join(sorted([user_id_a, user_id_b])).encode()).hexdigest()
    key = compat_key(pair_hash)

    cached = await cache_get(key)
    if cached:
        cached["from_cache"] = True
        return cached

    signs_a = chart_a.get("planets", {}).get("Sun", {}).get("sign", "Aries")
    signs_b = chart_b.get("planets", {}).get("Sun", {}).get("sign", "Aries")

    fire = ["Aries", "Leo", "Sagittarius"]
    earth = ["Taurus", "Virgo", "Capricorn"]
    air = ["Gemini", "Libra", "Aquarius"]
    water = ["Cancer", "Scorpio", "Pisces"]

    def get_element(sign):
        if sign in fire: return "fire"
        if sign in earth: return "earth"
        if sign in air: return "air"
        return "water"

    elem_a = get_element(signs_a)
    elem_b = get_element(signs_b)
    compatible_pairs = {("fire", "air"), ("air", "fire"), ("earth", "water"), ("water", "earth")}
    is_compatible = (elem_a, elem_b) in compatible_pairs or elem_a == elem_b
    score = 85 if is_compatible else 62

    result = {
        "pair_hash": pair_hash,
        "score": score,
        "sun_sign_a": signs_a,
        "sun_sign_b": signs_b,
        "element_a": elem_a,
        "element_b": elem_b,
        "compatible": is_compatible,
        "from_cache": False
    }

    await cache_set(key, result, COMPAT_TTL)
    return result
