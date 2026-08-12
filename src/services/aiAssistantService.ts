import { NatalChart } from '../types/astrology';

export async function askAstrologyAI(question: string, chart: NatalChart): Promise<string> {
  // Simulate intelligent delay
  await new Promise((resolve) => setTimeout(resolve, 1400));

  const qLower = question.toLowerCase();

  if (qLower.includes('love') || qLower.includes('relationship') || qLower.includes('partner') || qLower.includes('romance')) {
    return `With your Sun in ${chart.sunSign} and Moon in ${chart.moonSign}, you seek both passionate connection and deep emotional security. Your Venus placement suggests that love comes to you when you stop performing perfection and allow vulnerability. Look out for transits affecting your 7th house.`;
  }

  if (qLower.includes('career') || qLower.includes('job') || qLower.includes('work') || qLower.includes('money')) {
    return `Your Midheaven (MC) placement combined with your ${chart.risingSign} Ascendant indicates that your true vocational superpower lies in bringing distinct authenticity and sharp focus to your projects. Stop doubting your timing—Saturn is building your endurance for long-term authority.`;
  }

  if (qLower.includes('why') || qLower.includes('struggle') || qLower.includes('anxiety') || qLower.includes('fear') || qLower.includes('hard')) {
    return `Your chart shows a tension between your ${chart.sunSign} Sun (how you express yourself) and your ${chart.moonSign} Moon (how you process feeling privately). This internal contrast is not a defect—it is the source of your depth. Practice giving both sides a seat at the table.`;
  }

  return `Astrologically, your blueprint is shaped by your ${chart.sunSign} Sun, ${chart.moonSign} Moon, and ${chart.risingSign} Rising. Regarding "${question}": the current planetary transits encourage you to ground your decisions in raw self-honesty rather than seeking external validation.`;
}
