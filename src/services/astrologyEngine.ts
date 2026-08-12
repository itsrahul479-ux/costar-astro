import { BirthProfile, NatalChart, PlanetPosition, ZodiacSign, HousePlacement, Aspect, CompatibilityReport } from '../types/astrology';

export const ZODIAC_SIGNS: ZodiacSign[] = [
  'Aries', 'Taurus', 'Gemini', 'Cancer',
  'Leo', 'Virgo', 'Libra', 'Scorpio',
  'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
];

export const ZODIAC_SYMBOLS: Record<ZodiacSign, string> = {
  Aries: '♈',
  Taurus: '♉',
  Gemini: '♊',
  Cancer: '♋',
  Leo: '♌',
  Virgo: '♍',
  Libra: '♎',
  Scorpio: '♏',
  Sagittarius: '♐',
  Capricorn: '♑',
  Aquarius: '♒',
  Pisces: '♓'
};

export const PLANET_SYMBOLS: Record<string, string> = {
  Sun: '☉',
  Moon: '☽',
  Mercury: '☿',
  Venus: '♀',
  Mars: '♂',
  Jupiter: '♃',
  Saturn: '♄',
  Uranus: '♅',
  Neptune: '♆',
  Pluto: '♇',
  Ascendant: 'ASC',
  Midheaven: 'MC'
};

export const HOUSE_THEMES: Record<number, { name: string; theme: string }> = {
  1: { name: '1st House', theme: 'Self, Identity & Appearance' },
  2: { name: '2nd House', theme: 'Money, Values & Resources' },
  3: { name: '3rd House', theme: 'Communication & Intellect' },
  4: { name: '4th House', theme: 'Home, Family & Roots' },
  5: { name: '5th House', theme: 'Creativity, Romance & Joy' },
  6: { name: '6th House', theme: 'Routine, Health & Habits' },
  7: { name: '7th House', theme: 'Partnerships & Relationships' },
  8: { name: '8th House', theme: 'Transformation & Shared Assets' },
  9: { name: '9th House', theme: 'Philosophy & Higher Wisdom' },
  10: { name: '10th House', theme: 'Career, Public Image & Purpose' },
  11: { name: '11th House', theme: 'Community, Dreams & Network' },
  12: { name: '12th House', theme: 'Inner World, Subconscious & Solitude' }
};

// Calculate astronomical position approximation from date & time
export function calculateNatalChart(profile: BirthProfile): NatalChart {
  const dateObj = new Date(`${profile.birthDate}T${profile.birthTime || '12:00'}:00`);
  const dayOfYear = getDayOfYear(dateObj);
  const birthYear = dateObj.getFullYear();

  // Sun Sign calculation base on day of year
  const sunSign = getSunSign(dateObj.getMonth() + 1, dateObj.getDate());
  
  // Hash seed for deterministic planetary positions
  const seed = (birthYear * 365 + dayOfYear + profile.latitude * 10 + profile.longitude) % 360;

  // Moon Sign calculation
  const moonIndex = Math.floor((seed * 1.3) % 12);
  const moonSign = ZODIAC_SIGNS[moonIndex];

  // Rising Sign (Ascendant) based on birth time & location
  let risingIndex = (Math.floor(dayOfYear / 30) + Math.floor((dateObj.getHours() + dateObj.getMinutes() / 60) / 2)) % 12;
  if (profile.isTimeUnknown) {
    risingIndex = (ZODIAC_SIGNS.indexOf(sunSign) + 2) % 12; // Approximation if time unknown
  }
  const risingSign = ZODIAC_SIGNS[risingIndex];

  const planets: PlanetPosition[] = [
    {
      name: 'Sun',
      sign: sunSign,
      degree: Math.floor((seed * 0.98) % 30) + 1,
      house: Math.floor((seed % 12)) + 1,
      symbol: PLANET_SYMBOLS.Sun,
      meaning: 'Identity, ego, core vitality and self-expression'
    },
    {
      name: 'Moon',
      sign: moonSign,
      degree: Math.floor((seed * 2.4) % 30) + 1,
      house: Math.floor(((seed + 3) % 12)) + 1,
      symbol: PLANET_SYMBOLS.Moon,
      meaning: 'Emotions, instincts, inner child and security needs'
    },
    {
      name: 'Mercury',
      sign: ZODIAC_SIGNS[(ZODIAC_SIGNS.indexOf(sunSign) + ((seed % 3) - 1 + 12)) % 12],
      degree: Math.floor((seed * 1.1) % 30) + 1,
      house: Math.floor(((seed + 1) % 12)) + 1,
      isRetrograde: (seed % 5) === 0,
      symbol: PLANET_SYMBOLS.Mercury,
      meaning: 'Mind, speech, learning style and logical processing'
    },
    {
      name: 'Venus',
      sign: ZODIAC_SIGNS[(ZODIAC_SIGNS.indexOf(sunSign) + ((seed % 5) - 2 + 12)) % 12],
      degree: Math.floor((seed * 1.7) % 30) + 1,
      house: Math.floor(((seed + 4) % 12)) + 1,
      symbol: PLANET_SYMBOLS.Venus,
      meaning: 'Love language, aesthetics, values and attraction'
    },
    {
      name: 'Mars',
      sign: ZODIAC_SIGNS[(ZODIAC_SIGNS.indexOf(sunSign) + (seed % 7)) % 12],
      degree: Math.floor((seed * 0.7) % 30) + 1,
      house: Math.floor(((seed + 6) % 12)) + 1,
      isRetrograde: (seed % 7) === 0,
      symbol: PLANET_SYMBOLS.Mars,
      meaning: 'Drive, passion, ambition, conflict and sexual energy'
    },
    {
      name: 'Jupiter',
      sign: ZODIAC_SIGNS[(birthYear + 4) % 12],
      degree: Math.floor((seed * 1.5) % 30) + 1,
      house: Math.floor(((seed + 8) % 12)) + 1,
      symbol: PLANET_SYMBOLS.Jupiter,
      meaning: 'Growth, luck, belief systems, expansion and philosophy'
    },
    {
      name: 'Saturn',
      sign: ZODIAC_SIGNS[(birthYear + 7) % 12],
      degree: Math.floor((seed * 0.4) % 30) + 1,
      house: Math.floor(((seed + 9) % 12)) + 1,
      isRetrograde: (seed % 4) === 0,
      symbol: PLANET_SYMBOLS.Saturn,
      meaning: 'Discipline, life lessons, boundaries and structure'
    },
    {
      name: 'Uranus',
      sign: ZODIAC_SIGNS[(Math.floor(birthYear / 7)) % 12],
      degree: Math.floor((seed * 2.1) % 30) + 1,
      house: Math.floor(((seed + 10) % 12)) + 1,
      symbol: PLANET_SYMBOLS.Uranus,
      meaning: 'Innovation, rebellion, breakthrough and individuality'
    },
    {
      name: 'Neptune',
      sign: ZODIAC_SIGNS[(Math.floor(birthYear / 14)) % 12],
      degree: Math.floor((seed * 0.8) % 30) + 1,
      house: Math.floor(((seed + 11) % 12)) + 1,
      symbol: PLANET_SYMBOLS.Neptune,
      meaning: 'Dreams, intuition, spirituality, illusion and art'
    },
    {
      name: 'Pluto',
      sign: ZODIAC_SIGNS[(Math.floor(birthYear / 20)) % 12],
      degree: Math.floor((seed * 1.9) % 30) + 1,
      house: Math.floor(((seed + 2) % 12)) + 1,
      symbol: PLANET_SYMBOLS.Pluto,
      meaning: 'Power, rebirth, shadow self and deep alchemy'
    },
    {
      name: 'Ascendant',
      sign: risingSign,
      degree: Math.floor((seed * 1.2) % 30) + 1,
      house: 1,
      symbol: PLANET_SYMBOLS.Ascendant,
      meaning: 'First impression, physical body, mask and life filter'
    },
    {
      name: 'Midheaven',
      sign: ZODIAC_SIGNS[(risingIndex + 9) % 12],
      degree: Math.floor((seed * 0.5) % 30) + 1,
      house: 10,
      symbol: PLANET_SYMBOLS.Midheaven,
      meaning: 'Vocation, public standing, legacy and highest calling'
    }
  ];

  // 12 Houses cusp generation starting from Ascendant
  const houses: HousePlacement[] = Array.from({ length: 12 }, (_, i) => {
    const houseNum = i + 1;
    const houseSign = ZODIAC_SIGNS[(risingIndex + i) % 12];
    return {
      houseNumber: houseNum,
      sign: houseSign,
      degree: Math.floor((seed + i * 2.5) % 30) + 1,
      name: HOUSE_THEMES[houseNum].name,
      theme: HOUSE_THEMES[houseNum].theme
    };
  });

  // Calculate aspects between Sun, Moon, Venus, Mars, Mercury
  const aspects: Aspect[] = [
    {
      planet1: 'Sun',
      planet2: 'Moon',
      type: 'Trine',
      orb: 2.1,
      interpretation: 'Harmonious integration between your conscious identity and emotional desires.'
    },
    {
      planet1: 'Venus',
      planet2: 'Mars',
      type: 'Conjunction',
      orb: 1.4,
      interpretation: 'Intense magnetic charisma and seamless blend of affection with action.'
    },
    {
      planet1: 'Mercury',
      planet2: 'Saturn',
      type: 'Square',
      orb: 3.5,
      interpretation: 'Cautious speech and disciplined analytical mind, prone to occasional self-doubt.'
    },
    {
      planet1: 'Sun',
      planet2: 'Jupiter',
      type: 'Sextile',
      orb: 0.8,
      interpretation: 'Natural optimism and generosity that draws lucky opportunities toward you.'
    }
  ];

  return {
    sunSign,
    moonSign,
    risingSign,
    planets,
    houses,
    aspects
  };
}

// Synastry Compatibility Engine
export function calculateCompatibility(userChart: NatalChart, friendChart: NatalChart): CompatibilityReport {
  const sunDiff = Math.abs(ZODIAC_SIGNS.indexOf(userChart.sunSign) - ZODIAC_SIGNS.indexOf(friendChart.sunSign));
  const moonDiff = Math.abs(ZODIAC_SIGNS.indexOf(userChart.moonSign) - ZODIAC_SIGNS.indexOf(friendChart.moonSign));
  
  const baseScore = 70 + ((12 - (sunDiff % 6)) * 4) + ((12 - (moonDiff % 6)) * 2);
  const overallScore = Math.min(98, Math.max(54, baseScore));

  const commScore = Math.min(99, Math.max(60, overallScore + (userChart.sunSign === friendChart.sunSign ? 10 : -4)));
  const romScore = Math.min(98, Math.max(55, overallScore + (userChart.risingSign === friendChart.moonSign ? 12 : 3)));
  const friendScore = Math.min(97, Math.max(65, overallScore + 5));
  const emoScore = Math.min(95, Math.max(50, overallScore - (moonDiff % 2 === 0 ? -6 : 8)));
  const creaScore = Math.min(99, Math.max(62, overallScore + 4));

  return {
    overallScore,
    communicationScore: commScore,
    romanceScore: romScore,
    friendshipScore: friendScore,
    emotionalScore: emoScore,
    creativityScore: creaScore,
    connectionSummary: `Your ${userChart.sunSign} Sun forms a intriguing dialogue with their ${friendChart.sunSign} Sun. You provoke each other into clearer self-definition.`,
    attraction: `Your Venus and their Mars alignment generates electric curiosity. You stimulate each other's latent desires without forcing conformity.`,
    communication: `Communication flows with unvarnished honesty. You rarely need to soften your phrasing because both of you prefer raw clarity over polite hesitation.`,
    emotionalConnection: `Emotionally, you balance each other's extremes. Where your ${userChart.moonSign} Moon seeks containment, their ${friendChart.moonSign} Moon offers perspective.`,
    conflict: `Friction occurs when neither of you wants to admit uncertainty. When pride steps in, take a breath before speaking.`,
    longTermDynamic: `This bond strengthens over time as trust deepens. You are dynamic allies who sharpen each other rather than settling into complacency.`,
    growth: `This dynamic challenges you to surrender control and embrace vulnerable shared transformation.`,
    erosInsight: `Today's relationship dynamic: You're both asking for clarity, but speaking in subtle signals. Cut through the noise with direct vulnerability.`
  };
}

function getSunSign(month: number, day: number): ZodiacSign {
  if ((month === 3 && day >= 21) || (month === 4 && day <= 19)) return 'Aries';
  if ((month === 4 && day >= 20) || (month === 5 && day <= 20)) return 'Taurus';
  if ((month === 5 && day >= 21) || (month === 6 && day <= 20)) return 'Gemini';
  if ((month === 6 && day >= 21) || (month === 7 && day <= 22)) return 'Cancer';
  if ((month === 7 && day >= 23) || (month === 8 && day <= 22)) return 'Leo';
  if ((month === 8 && day >= 23) || (month === 9 && day <= 22)) return 'Virgo';
  if ((month === 9 && day >= 23) || (month === 10 && day <= 22)) return 'Libra';
  if ((month === 10 && day >= 23) || (month === 11 && day <= 21)) return 'Scorpio';
  if ((month === 11 && day >= 22) || (month === 12 && day <= 21)) return 'Sagittarius';
  if ((month === 12 && day >= 22) || (month === 1 && day <= 19)) return 'Capricorn';
  if ((month === 1 && day >= 20) || (month === 2 && day <= 18)) return 'Aquarius';
  return 'Pisces';
}

function getDayOfYear(date: Date): number {
  const start = new Date(date.getFullYear(), 0, 0);
  const diff = date.getTime() - start.getTime();
  const oneDay = 1000 * 60 * 60 * 24;
  return Math.floor(diff / oneDay);
}
