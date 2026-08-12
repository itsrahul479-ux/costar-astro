import swisseph as swe
from datetime import datetime
from models.domain import PlanetPosition, HousePlacement, NatalChart

# Map of Swiss Ephemeris planet IDs
PLANET_MAP = {
    swe.SUN: "Sun",
    swe.MOON: "Moon",
    swe.MERCURY: "Mercury",
    swe.VENUS: "Venus",
    swe.MARS: "Mars",
    swe.JUPITER: "Jupiter",
    swe.SATURN: "Saturn",
    swe.URANUS: "Uranus",
    swe.NEPTUNE: "Neptune",
    swe.PLUTO: "Pluto",
}

ZODIAC_SIGNS = [
    "Aries", "Taurus", "Gemini", "Cancer", "Leo", "Virgo",
    "Libra", "Scorpio", "Sagittarius", "Capricorn", "Aquarius", "Pisces"
]

def calculate_natal_chart(year: int, month: int, day: int, hour: float, lat: float, lon: float) -> NatalChart:
    # Set ephemeris path to default internal analytical ephemeris
    swe.set_ephe_path(None)
    
    # Calculate Julian Day
    jd = swe.julday(year, month, day, hour)
    
    planets = []
    
    for pl_id, pl_name in PLANET_MAP.items():
        # Calculate planet position
        # flag = swe.FLG_SWIEPH for precision if ephemeris files are present, else swe.FLG_MOSEPH
        res = swe.calc_ut(jd, pl_id, swe.FLG_MOSEPH)
        lon_deg = res[0][0]
        speed = res[0][3]
        
        sign_idx = int(lon_deg / 30)
        sign = ZODIAC_SIGNS[sign_idx]
        degree_in_sign = lon_deg % 30
        
        planets.append(PlanetPosition(
            name=pl_name,
            sign=sign,
            degree=round(degree_in_sign, 2),
            house=0, # Will be filled later
            is_retrograde=speed < 0
        ))
        
    # Calculate Houses
    # 'P' stands for Placidus house system
    houses_data, ascmc = swe.houses(jd, lat, lon, b'P')
    
    houses = []
    for i in range(12):
        cusp = houses_data[i]
        sign_idx = int(cusp / 30)
        sign = ZODIAC_SIGNS[sign_idx]
        degree_in_sign = cusp % 30
        houses.append(HousePlacement(
            house=i+1,
            sign=sign,
            degree=round(degree_in_sign, 2)
        ))
        
    # Simple logic to assign planets to houses
    for planet in planets:
        planet.house = get_house_for_planet(planet.degree + (ZODIAC_SIGNS.index(planet.sign) * 30), houses_data)

    asc_deg = ascmc[0]
    sun_sign = next(p.sign for p in planets if p.name == "Sun")
    moon_sign = next(p.sign for p in planets if p.name == "Moon")
    rising_sign = ZODIAC_SIGNS[int(asc_deg / 30)]

    return NatalChart(
        sun_sign=sun_sign,
        moon_sign=moon_sign,
        rising_sign=rising_sign,
        planets=planets,
        houses=houses
    )

def get_house_for_planet(planet_lon: float, houses_data: tuple) -> int:
    """Helper to determine which house a planet falls into based on longitudes."""
    for i in range(12):
        start = houses_data[i]
        end = houses_data[(i + 1) % 12]
        if start < end:
            if start <= planet_lon < end:
                return i + 1
        else: # crosses 0 Aries
            if planet_lon >= start or planet_lon < end:
                return i + 1
    return 1 # Fallback
