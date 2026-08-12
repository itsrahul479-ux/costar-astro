import '../../shared/models/astrology_models.dart';

class DailyInsightsService {
  static const List<String> mainQuotes = [
    "You are being asked to slow down. Today is about reconsidering your usual patterns.",
    "Stop forcing the answer. Let the answer find you in the quiet.",
    "You don't need to prove yourself to people who aren't even watching.",
    "Notice what you avoid when you feel overwhelmed. That is your next step.",
    "Silence is not an absence of thought. It is the room where real clarity lives.",
    "Your urgency is an illusion created by comparing your timeline to strangers.",
    "The conflict you expect today is mostly taking place inside your head.",
    "Protect your energy before you give it away to non-essential noise.",
  ];

  static const List<String> subQuotes = [
    "Today's transit places Mercury opposite your native placement. Expect subtle miscommunications unless you double-check your intentions.",
    "Venus entering your 7th house shifts your focus toward relational honesty and unmasking hidden desires.",
    "Saturn's hard aspect demands structural accountability. Cut the fluff from your schedule.",
    "The Moon in Scorpio exposes emotional subtexts. Pay attention to what remains unsaid.",
  ];

  static DailyInsight generateDailyInsight(NatalChart chart, [DateTime? date]) {
    final now = date ?? DateTime.now();
    final dateStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final seed = (now.day * 13 + now.month * 31 + chart.sunSign.name.length * 7) % mainQuotes.length;

    final mainQuote = mainQuotes[seed];
    final subQuote = subQuotes[seed % subQuotes.length];

    return DailyInsight(
      date: dateStr,
      mainQuote: mainQuote,
      subQuote: subQuote,
      theme: "Stop forcing outcome in ${chart.sunSign.displayName} season. Let quiet awareness guide your decisions today.",
      areasOfPower: const ['Self', 'Relationships', 'Creativity'],
      areasOfChallenge: const ['Routine', 'Communication', 'Work'],
      energyLevels: {
        'relationships': 60 + ((seed * 7) % 35),
        'career': 45 + ((seed * 11) % 45),
        'creativity': 70 + ((seed * 5) % 28),
        'self': 55 + ((seed * 13) % 40),
      },
      details: {
        'love': 'Your ${chart.sunSign.displayName} Sun invites you to drop defensive posture in romance. Speak with total clarity without assuming your partner can read your mind.',
        'work': 'Productivity comes from ruthless prioritization today. Tackle the single task you have been postponing.',
        'creativity': 'Your ${chart.moonSign.displayName} Moon accesses deep intuitive inspiration. Capture raw ideas down before editing.',
        'social': 'Selectivity is your superpower today. Choose conversations that leave you energized.',
        'self': 'Give yourself permission to pause. Honor your physical energy levels before stepping out.',
        'advice': 'Do not act out of impulse between 2:00 PM and 5:00 PM when transiting Mars squares your Midheaven.',
      },
    );
  }
}
