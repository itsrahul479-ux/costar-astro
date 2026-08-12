import { DailyInsight, NatalChart } from '../types/astrology';

const MAIN_QUOTES = [
  "You are being asked to slow down. Today is about reconsidering your usual patterns.",
  "Stop forcing the answer. Let the answer find you in the quiet.",
  "You don't need to prove yourself to people who aren't even watching.",
  "Notice what you avoid when you feel overwhelmed. That is your next step.",
  "Silence is not an absence of thought. It is the room where real clarity lives.",
  "Your urgency is an illusion created by comparing your timeline to strangers.",
  "The conflict you expect today is mostly taking place inside your head.",
  "Protect your energy before you give it away to non-essential noise."
];

const SUB_QUOTES = [
  "Today's transit places Mercury opposite your native placement. Expect subtle miscommunications unless you double-check your intentions.",
  "Venus entering your 7th house shifts your focus toward relational honesty and unmasking hidden desires.",
  "Saturn's hard aspect demands structural accountability. Cut the fluff from your schedule.",
  "The Moon in Scorpio exposes emotional subtexts. Pay attention to what remains unsaid in conversations."
];

export function generateDailyInsight(chart: NatalChart, dateStr?: string): DailyInsight {
  const today = dateStr || new Date().toISOString().split('T')[0];
  const dateObj = new Date(today);
  const seed = (dateObj.getDate() * 13 + dateObj.getMonth() * 31 + chart.sunSign.length * 7) % MAIN_QUOTES.length;

  const mainQuote = MAIN_QUOTES[seed];
  const subQuote = SUB_QUOTES[seed % SUB_QUOTES.length];

  const powerPool = ['Self', 'Relationships', 'Creativity', 'Intuition', 'Boundaries', 'Expression', 'Ambition'];
  const challengePool = ['Routine', 'Communication', 'Work', 'Patience', 'Overthinking', 'Expectations', 'Rest'];

  const powerIndex = (seed * 3) % powerPool.length;
  const challengeIndex = (seed * 2) % challengePool.length;

  return {
    date: today,
    mainQuote,
    subQuote,
    theme: `Stop forcing outcome in ${chart.sunSign} season. Let quiet awareness guide your decisions today.`,
    areasOfPower: [
      powerPool[powerIndex],
      powerPool[(powerIndex + 2) % powerPool.length],
      powerPool[(powerIndex + 4) % powerPool.length]
    ],
    areasOfChallenge: [
      challengePool[challengeIndex],
      challengePool[(challengeIndex + 2) % challengePool.length],
      challengePool[(challengeIndex + 3) % challengePool.length]
    ],
    energyLevels: {
      relationships: 60 + ((seed * 7) % 35),
      career: 45 + ((seed * 11) % 45),
      creativity: 70 + ((seed * 5) % 28),
      self: 55 + ((seed * 13) % 40)
    },
    details: {
      love: `Your ${chart.sunSign} Sun invites you to drop defensive posture in romance. Speak with total clarity without assuming your partner can read your mind.`,
      work: `Productivity comes from ruthless prioritization today. Tackle the single task you have been postponing rather than clearing superficial items.`,
      creativity: `Your ${chart.moonSign} Moon accesses deep intuitive inspiration. Capture raw ideas down before trying to polish or edit them.`,
      social: `Selectivity is your superpower today. Choose conversations that leave you energized rather than drained by superficial small talk.`,
      self: `Give yourself permission to pause. Honor your physical energy levels before stepping out into high-stimulus environments.`,
      advice: `Do not act out of impulse between 2:00 PM and 5:00 PM when transiting Mars squares your chart's Midheaven.`
    }
  };
}
