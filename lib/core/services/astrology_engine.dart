import 'dart:math';
import '../../shared/models/astrology_models.dart';

class AstrologyEngine {
  static const List<ZodiacSign> allSigns = ZodiacSign.values;

  static const Map<String, String> planetSymbols = {
    'Sun': '☉',
    'Moon': '☽',
    'Mercury': '☿',
    'Venus': '♀',
    'Mars': '♂',
    'Jupiter': '♃',
    'Saturn': '♄',
    'Uranus': '♅',
    'Neptune': '♆',
    'Pluto': '♇',
    'Ascendant': 'ASC',
    'Midheaven': 'MC',
  };

  static NatalChart calculateNatalChart(BirthProfile profile) {
    final parts = profile.birthDate.split('-');
    final year = int.tryParse(parts[0]) ?? 1998;
    final month = int.tryParse(parts[1]) ?? 8;
    final day = int.tryParse(parts[2]) ?? 15;

    final sunSign = _calculateSunSign(month, day);
    final dayOfYear = _getDayOfYear(year, month, day);

    final seed = (year * 365 + dayOfYear + (profile.latitude * 10).toInt() + (profile.longitude).toInt()).abs() % 360;

    final moonSign = allSigns[(seed * 1.3).toInt() % 12];

    int risingIndex = ((dayOfYear ~/ 30) + (12 ~/ 2)) % 12;
    if (profile.isTimeUnknown) {
      risingIndex = (sunSign.index + 2) % 12;
    }
    final risingSign = allSigns[risingIndex];

    final planets = [
      PlanetPosition(
        name: 'Sun',
        sign: sunSign,
        degree: ((seed * 0.98) % 30).toInt() + 1,
        house: (seed % 12) + 1,
        symbol: planetSymbols['Sun']!,
        meaning: 'Identity, ego, core vitality and self-expression',
      ),
      PlanetPosition(
        name: 'Moon',
        sign: moonSign,
        degree: ((seed * 2.4) % 30).toInt() + 1,
        house: ((seed + 3) % 12) + 1,
        symbol: planetSymbols['Moon']!,
        meaning: 'Emotions, instincts, inner child and security needs',
      ),
      PlanetPosition(
        name: 'Mercury',
        sign: allSigns[(sunSign.index + ((seed % 3) - 1 + 12)) % 12],
        degree: ((seed * 1.1) % 30).toInt() + 1,
        house: ((seed + 1) % 12) + 1,
        isRetrograde: (seed % 5) == 0,
        symbol: planetSymbols['Mercury']!,
        meaning: 'Mind, speech, learning style and logical processing',
      ),
      PlanetPosition(
        name: 'Venus',
        sign: allSigns[(sunSign.index + ((seed % 5) - 2 + 12)) % 12],
        degree: ((seed * 1.7) % 30).toInt() + 1,
        house: ((seed + 4) % 12) + 1,
        symbol: planetSymbols['Venus']!,
        meaning: 'Love language, aesthetics, values and attraction',
      ),
      PlanetPosition(
        name: 'Mars',
        sign: allSigns[(sunSign.index + (seed % 7)) % 12],
        degree: ((seed * 0.7) % 30).toInt() + 1,
        house: ((seed + 6) % 12) + 1,
        isRetrograde: (seed % 7) == 0,
        symbol: planetSymbols['Mars']!,
        meaning: 'Drive, passion, ambition, conflict and sexual energy',
      ),
      PlanetPosition(
        name: 'Jupiter',
        sign: allSigns[(year + 4) % 12],
        degree: ((seed * 1.5) % 30).toInt() + 1,
        house: ((seed + 8) % 12) + 1,
        symbol: planetSymbols['Jupiter']!,
        meaning: 'Growth, luck, belief systems, expansion and philosophy',
      ),
      PlanetPosition(
        name: 'Saturn',
        sign: allSigns[(year + 7) % 12],
        degree: ((seed * 0.4) % 30).toInt() + 1,
        house: ((seed + 9) % 12) + 1,
        symbol: planetSymbols['Saturn']!,
        meaning: 'Discipline, life lessons, boundaries and structure',
      ),
      PlanetPosition(
        name: 'Ascendant',
        sign: risingSign,
        degree: ((seed * 1.2) % 30).toInt() + 1,
        house: 1,
        symbol: planetSymbols['Ascendant']!,
        meaning: 'First impression, physical body, mask and life filter',
      ),
      PlanetPosition(
        name: 'Midheaven',
        sign: allSigns[(risingIndex + 9) % 12],
        degree: ((seed * 0.5) % 30).toInt() + 1,
        house: 10,
        symbol: planetSymbols['Midheaven']!,
        meaning: 'Vocation, public standing, legacy and highest calling',
      ),
    ];

    final houses = List<HousePlacement>.generate(12, (i) {
      final hSign = allSigns[(risingIndex + i) % 12];
      return HousePlacement(
        houseNumber: i + 1,
        sign: hSign,
        degree: ((seed + i * 2.5) % 30).toInt() + 1,
        name: '${i + 1}${_getOrdinalSuffix(i + 1)} House',
        theme: _getHouseTheme(i + 1),
      );
    });

    const aspects = [
      Aspect(
        planet1: 'Sun',
        planet2: 'Moon',
        type: 'Trine',
        orb: 2.1,
        interpretation: 'Harmonious integration between your conscious identity and emotional desires.',
      ),
      Aspect(
        planet1: 'Venus',
        planet2: 'Mars',
        type: 'Conjunction',
        orb: 1.4,
        interpretation: 'Intense magnetic charisma and seamless blend of affection with action.',
      ),
      Aspect(
        planet1: 'Mercury',
        planet2: 'Saturn',
        type: 'Square',
        orb: 3.5,
        interpretation: 'Cautious speech and disciplined analytical mind, prone to occasional self-doubt.',
      ),
    ];

    return NatalChart(
      sunSign: sunSign,
      moonSign: moonSign,
      risingSign: risingSign,
      planets: planets,
      houses: houses,
      aspects: aspects,
    );
  }

  static CompatibilityReport calculateCompatibility(NatalChart uChart, NatalChart fChart) {
    final sunDiff = (uChart.sunSign.index - fChart.sunSign.index).abs();
    final moonDiff = (uChart.moonSign.index - fChart.moonSign.index).abs();

    final baseScore = 70 + ((12 - (sunDiff % 6)) * 4) + ((12 - (moonDiff % 6)) * 2);
    final overall = min(98, max(54, baseScore));

    return CompatibilityReport(
      overallScore: overall,
      communicationScore: min(99, max(60, overall + (uChart.sunSign == fChart.sunSign ? 10 : -4))),
      romanceScore: min(98, max(55, overall + (uChart.risingSign == fChart.moonSign ? 12 : 3))),
      friendshipScore: min(97, max(65, overall + 5)),
      emotionalScore: min(95, max(50, overall - (moonDiff % 2 == 0 ? -6 : 8))),
      creativityScore: min(99, max(62, overall + 4)),
      connectionSummary: 'Your ${uChart.sunSign.displayName} Sun forms an intriguing dialogue with their ${fChart.sunSign.displayName} Sun. You provoke each other into clearer self-definition.',
      attraction: 'Your Venus and their Mars alignment generates electric curiosity. You stimulate each other\'s latent desires without forcing conformity.',
      communication: 'Communication flows with unvarnished honesty. You rarely need to soften your phrasing.',
      emotionalConnection: 'Emotionally, you balance each other\'s extremes.',
      conflict: 'Friction occurs when neither of you wants to admit uncertainty.',
      longTermDynamic: 'This bond strengthens over time as trust deepens.',
      growth: 'This dynamic challenges you to surrender control and embrace vulnerable shared transformation.',
      erosInsight: 'Today\'s partner dynamic: You are both asking for clarity, but speaking in subtle signals.',
    );
  }

  static ZodiacSign _calculateSunSign(int month, int day) {
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return ZodiacSign.aries;
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return ZodiacSign.taurus;
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return ZodiacSign.gemini;
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return ZodiacSign.cancer;
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return ZodiacSign.leo;
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return ZodiacSign.virgo;
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return ZodiacSign.libra;
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return ZodiacSign.scorpio;
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return ZodiacSign.sagittarius;
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) return ZodiacSign.capricorn;
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return ZodiacSign.aquarius;
    return ZodiacSign.pisces;
  }

  static int _getDayOfYear(int y, int m, int d) {
    final date = DateTime(y, m, d);
    return date.difference(DateTime(y, 1, 1)).inDays + 1;
  }

  static String _getOrdinalSuffix(int n) {
    if (n >= 11 && n <= 13) return 'th';
    switch (n % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }

  static String _getHouseTheme(int house) {
    const themes = {
      1: 'Self, Identity & Appearance',
      2: 'Money, Values & Resources',
      3: 'Communication & Intellect',
      4: 'Home, Family & Roots',
      5: 'Creativity, Romance & Joy',
      6: 'Routine, Health & Habits',
      7: 'Partnerships & Relationships',
      8: 'Transformation & Shared Assets',
      9: 'Philosophy & Higher Wisdom',
      10: 'Career, Public Image & Purpose',
      11: 'Community, Dreams & Network',
      12: 'Inner World, Subconscious & Solitude',
    };
    return themes[house] ?? '';
  }
}
