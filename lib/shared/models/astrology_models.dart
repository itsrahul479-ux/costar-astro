enum ZodiacSign {
  aries,
  taurus,
  gemini,
  cancer,
  leo,
  virgo,
  libra,
  scorpio,
  sagittarius,
  capricorn,
  aquarius,
  pisces;

  String get displayName {
    return name[0].toUpperCase() + name.substring(1);
  }

  String get symbol {
    switch (this) {
      case ZodiacSign.aries: return '♈';
      case ZodiacSign.taurus: return '♉';
      case ZodiacSign.gemini: return '♊';
      case ZodiacSign.cancer: return '♋';
      case ZodiacSign.leo: return '♌';
      case ZodiacSign.virgo: return '♍';
      case ZodiacSign.libra: return '♎';
      case ZodiacSign.scorpio: return '♏';
      case ZodiacSign.sagittarius: return '♐';
      case ZodiacSign.capricorn: return '♑';
      case ZodiacSign.aquarius: return '♒';
      case ZodiacSign.pisces: return '♓';
    }
  }

  String get element {
    switch (this) {
      case ZodiacSign.aries:
      case ZodiacSign.leo:
      case ZodiacSign.sagittarius:
        return 'Fire';
      case ZodiacSign.taurus:
      case ZodiacSign.virgo:
      case ZodiacSign.capricorn:
        return 'Earth';
      case ZodiacSign.gemini:
      case ZodiacSign.libra:
      case ZodiacSign.aquarius:
        return 'Air';
      case ZodiacSign.cancer:
      case ZodiacSign.scorpio:
      case ZodiacSign.pisces:
        return 'Water';
    }
  }
}

class PlanetPosition {
  final String name;
  final ZodiacSign sign;
  final int degree;
  final int house;
  final bool isRetrograde;
  final String symbol;
  final String meaning;

  const PlanetPosition({
    required this.name,
    required this.sign,
    required this.degree,
    required this.house,
    this.isRetrograde = false,
    required this.symbol,
    required this.meaning,
  });
}

class HousePlacement {
  final int houseNumber;
  final ZodiacSign sign;
  final int degree;
  final String name;
  final String theme;

  const HousePlacement({
    required this.houseNumber,
    required this.sign,
    required this.degree,
    required this.name,
    required this.theme,
  });
}

class Aspect {
  final String planet1;
  final String planet2;
  final String type; // Trine, Square, Conjunction, Sextile, Opposition
  final double orb;
  final String interpretation;

  const Aspect({
    required this.planet1,
    required this.planet2,
    required this.type,
    required this.orb,
    required this.interpretation,
  });
}

class NatalChart {
  final ZodiacSign sunSign;
  final ZodiacSign moonSign;
  final ZodiacSign risingSign;
  final List<PlanetPosition> planets;
  final List<HousePlacement> houses;
  final List<Aspect> aspects;

  const NatalChart({
    required this.sunSign,
    required this.moonSign,
    required this.risingSign,
    required this.planets,
    required this.houses,
    required this.aspects,
  });
}

class BirthProfile {
  final String name;
  final String? gender;
  final String birthDate; // YYYY-MM-DD
  final String birthTime; // HH:mm
  final bool isTimeUnknown;
  final String birthCity;
  final String birthCountry;
  final double latitude;
  final double longitude;
  final String timezone;

  const BirthProfile({
    required this.name,
    this.gender,
    required this.birthDate,
    required this.birthTime,
    required this.isTimeUnknown,
    required this.birthCity,
    required this.birthCountry,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });
}

class DailyInsight {
  final String date;
  final String mainQuote;
  final String subQuote;
  final String theme;
  final List<String> areasOfPower;
  final List<String> areasOfChallenge;
  final Map<String, int> energyLevels;
  final Map<String, String> details;

  const DailyInsight({
    required this.date,
    required this.mainQuote,
    required this.subQuote,
    required this.theme,
    required this.areasOfPower,
    required this.areasOfChallenge,
    required this.energyLevels,
    required this.details,
  });
}

class Friend {
  final String id;
  final String name;
  final String username;
  final ZodiacSign sunSign;
  final ZodiacSign moonSign;
  final ZodiacSign risingSign;
  final BirthProfile birthProfile;
  final NatalChart chart;

  const Friend({
    required this.id,
    required this.name,
    required this.username,
    required this.sunSign,
    required this.moonSign,
    required this.risingSign,
    required this.birthProfile,
    required this.chart,
  });
}

class CompatibilityReport {
  final int overallScore;
  final int communicationScore;
  final int romanceScore;
  final int friendshipScore;
  final int emotionalScore;
  final int creativityScore;
  final String connectionSummary;
  final String attraction;
  final String communication;
  final String emotionalConnection;
  final String conflict;
  final String longTermDynamic;
  final String growth;
  final String erosInsight;

  const CompatibilityReport({
    required this.overallScore,
    required this.communicationScore,
    required this.romanceScore,
    required this.friendshipScore,
    required this.emotionalScore,
    required this.creativityScore,
    required this.connectionSummary,
    required this.attraction,
    required this.communication,
    required this.emotionalConnection,
    required this.conflict,
    required this.longTermDynamic,
    required this.growth,
    required this.erosInsight,
  });
}
