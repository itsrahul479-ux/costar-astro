import google.generativeai as genai
from core.config import settings
from models.domain import DailyInsightResponse, NatalChart
import json
import re

# Configure Gemini
genai.configure(api_key=settings.GEMINI_API_KEY)
model = genai.GenerativeModel('gemini-1.5-flash')

def get_daily_insight(chart: NatalChart) -> DailyInsightResponse:
    prompt = f"""
    You are an expert, modern astrologer. Based on the following natal chart:
    Sun: {chart.sun_sign}, Moon: {chart.moon_sign}, Rising: {chart.rising_sign}.
    
    Provide a daily astrological insight in the exact JSON format below. Do not include markdown code block syntax (like ```json), just return the raw JSON object.
    {{
        "date": "Today's Date",
        "theme": "A short, poetic theme (e.g. 'The weight of the unsaid')",
        "reading": "A stark, editorial 2-3 sentence astrological reading.",
        "power_areas": ["Career", "Self"],
        "challenge_areas": ["Routine", "Romance"]
    }}
    """
    
    response = model.generate_content(prompt)
    
    try:
        # Strip markdown if model included it
        text = response.text.strip()
        if text.startswith('```json'):
            text = text[7:]
        if text.endswith('```'):
            text = text[:-3]
            
        data = json.loads(text.strip())
        return DailyInsightResponse(**data)
    except Exception as e:
        # Fallback
        return DailyInsightResponse(
            date="Today",
            theme="Cosmic Static",
            reading="The stars are currently obscured. Trust your own intuition today.",
            power_areas=["Self"],
            challenge_areas=["Uncertainty"]
        )
