import google.generativeai as genai
from core.config import settings
from models.domain import DailyInsightResponse, NatalChart
import json

# Configure Gemini (graceful if key missing)
try:
    genai.configure(api_key=settings.GEMINI_API_KEY)
    model = genai.GenerativeModel('gemini-1.5-flash')
    _gemini_available = True
except Exception:
    model = None
    _gemini_available = False


def get_daily_insight(chart: NatalChart) -> DailyInsightResponse:
    prompt = f"""
    You are an expert, modern astrologer. Based on the following natal chart:
    Sun: {chart.sun_sign}, Moon: {chart.moon_sign}, Rising: {chart.rising_sign}.
    Provide a daily astrological insight in the exact JSON format below. No markdown.
    {{
        "date": "Today's Date",
        "theme": "A short, poetic theme",
        "reading": "A stark, editorial 2-3 sentence astrological reading.",
        "power_areas": ["Career", "Self"],
        "challenge_areas": ["Routine", "Romance"]
    }}
    """

    if not _gemini_available or model is None:
        return DailyInsightResponse(
            date="Today", theme="Awaiting the Stars",
            reading="Configure your Gemini API key to unlock AI-powered readings.",
            power_areas=["Self"], challenge_areas=["Uncertainty"]
        )

    response = model.generate_content(prompt)
    try:
        text = response.text.strip()
        if text.startswith('```json'):
            text = text[7:]
        if text.endswith('```'):
            text = text[:-3]
        data = json.loads(text.strip())
        return DailyInsightResponse(**data)
    except Exception:
        return DailyInsightResponse(
            date="Today", theme="Cosmic Static",
            reading="The stars are currently obscured. Trust your own intuition today.",
            power_areas=["Self"], challenge_areas=["Uncertainty"]
        )


async def generate_daily_reading(user_id: str, sun_sign: str, chart_data: dict) -> str:
    """
    Async personalized daily reading string.
    Used by chart_service. Falls back to template if Gemini unavailable.
    """
    if not _gemini_available or model is None:
        return (
            f"The {sun_sign} energy is strong today. Navigate your path with intention. "
            "The cosmos align to support your growth and clarity."
        )

    try:
        moon_sign = chart_data.get("planets", {}).get("Moon", {}).get("sign", "Aries")
        prompt = (
            f"You are a poetic, modern astrologer. Write a 2-sentence daily horoscope "
            f"for someone with Sun in {sun_sign} and Moon in {moon_sign}. "
            f"Be literary and specific. No emojis."
        )
        response = model.generate_content(prompt)
        return response.text.strip()
    except Exception:
        return (
            f"As {sun_sign}, today calls for deep reflection. "
            "The celestial patterns support those who act with purpose."
        )
