export type ZodiacSign = 
  | 'Aries' | 'Taurus' | 'Gemini' | 'Cancer' 
  | 'Leo' | 'Virgo' | 'Libra' | 'Scorpio' 
  | 'Sagittarius' | 'Capricorn' | 'Aquarius' | 'Pisces';

export interface ZodiacInfo {
  sign: ZodiacSign;
  symbol: string;
  element: 'Fire' | 'Earth' | 'Air' | 'Water';
  modality: 'Cardinal' | 'Fixed' | 'Mutable';
  rulingPlanet: string;
  degree: number;
}

export type PlanetName = 
  | 'Sun' | 'Moon' | 'Mercury' | 'Venus' | 'Mars' 
  | 'Jupiter' | 'Saturn' | 'Uranus' | 'Neptune' | 'Pluto' 
  | 'Ascendant' | 'Midheaven';

export interface PlanetPosition {
  name: PlanetName;
  sign: ZodiacSign;
  degree: number;
  house: number;
  isRetrograde?: boolean;
  symbol: string;
  meaning: string;
}

export interface HousePlacement {
  houseNumber: number;
  sign: ZodiacSign;
  degree: number;
  name: string;
  theme: string;
}

export interface Aspect {
  planet1: PlanetName;
  planet2: PlanetName;
  type: 'Conjunction' | 'Opposition' | 'Trine' | 'Square' | 'Sextile';
  orb: number;
  interpretation: string;
}

export interface NatalChart {
  sunSign: ZodiacSign;
  moonSign: ZodiacSign;
  risingSign: ZodiacSign;
  planets: PlanetPosition[];
  houses: HousePlacement[];
  aspects: Aspect[];
}

export interface BirthProfile {
  name: string;
  gender?: string;
  birthDate: string; // YYYY-MM-DD
  birthTime: string; // HH:mm
  isTimeUnknown: boolean;
  birthCity: string;
  birthCountry: string;
  latitude: number;
  longitude: number;
  timezone: string;
}

export interface DailyInsight {
  date: string;
  mainQuote: string;
  subQuote: string;
  theme: string;
  areasOfPower: string[];
  areasOfChallenge: string[];
  energyLevels: {
    relationships: number;
    career: number;
    creativity: number;
    self: number;
  };
  details: {
    love: string;
    work: string;
    creativity: string;
    social: string;
    self: string;
    advice: string;
  };
}

export interface Friend {
  id: string;
  name: string;
  username: string;
  avatarUrl?: string;
  sunSign: ZodiacSign;
  moonSign: ZodiacSign;
  risingSign: ZodiacSign;
  birthProfile: BirthProfile;
  chart: NatalChart;
}

export interface CompatibilityReport {
  overallScore: number;
  communicationScore: number;
  romanceScore: number;
  friendshipScore: number;
  emotionalScore: number;
  creativityScore: number;
  connectionSummary: string;
  attraction: string;
  communication: string;
  emotionalConnection: string;
  conflict: string;
  longTermDynamic: string;
  growth: string;
  erosInsight?: string;
}

export interface ChatMessage {
  id: string;
  sender: 'user' | 'astrologer';
  text: string;
  timestamp: string;
}
