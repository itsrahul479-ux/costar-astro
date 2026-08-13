import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/co_star_theme.dart';

class TransitsScreen extends ConsumerWidget {
  const TransitsScreen({super.key});

  List<Map<String, String>> _calculateLiveTransits() {
    final now = DateTime.now();
    final dayOfYear = int.parse("${now.month}${now.day}");
    
    final transitsList = [
      {
        'planet': 'Sun',
        'sign': _getSignForMonth(now.month, now.day),
        'aspect': (dayOfYear % 2 == 0) ? 'Conjunction Saturn' : 'Trine Jupiter',
        'impact': (dayOfYear % 2 == 0)
            ? 'High focus on long-term discipline, structural accountability, and clear emotional boundaries.'
            : 'Expansion of personal energy, optimistic outlook, and natural alignment with life goals.'
      },
      {
        'planet': 'Moon',
        'sign': _getMoonSignForDay(now.day),
        'aspect': (dayOfYear % 3 == 0) ? 'Trine Neptune' : 'Square Mars',
        'impact': (dayOfYear % 3 == 0)
            ? 'Heightened intuitive sensitivity, emotional clarity, and vivid subconscious processing tonight.'
            : 'Potential for momentary emotional friction. Pause before responding to intense social triggers.'
      },
      {
        'planet': 'Venus',
        'sign': (now.month % 2 == 0) ? 'Pisces' : 'Taurus',
        'aspect': 'Exaltation in Transit',
        'impact': 'Unconditional relational empathy, artistic inspiration, and magnetic attraction towards core values.'
      },
      {
        'planet': 'Mars',
        'sign': (now.day % 2 == 0) ? 'Gemini' : 'Aries',
        'aspect': (now.day % 4 == 0) ? 'Opposite Pluto' : 'Sextile Sun',
        'impact': (now.day % 4 == 0)
            ? 'Channel physical energy into deep constructive work rather than unnecessary power struggles.'
            : 'High physical stamina and decisiveness. Ideal time to execute complex projects.'
      },
      {
        'planet': 'Mercury',
        'sign': _getSignForMonth(now.month, now.day),
        'aspect': (now.day % 5 == 0) ? 'Retrograde Motion' : 'Direct Motion',
        'impact': (now.day % 5 == 0)
            ? 'Review agreements, back up digital files, and re-evaluate recent communication choices.'
            : 'Sharp mental processing, fluid conversation, and swift execution of intellectual tasks.'
      },
    ];

    return transitsList;
  }

  String _getSignForMonth(int month, int day) {
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) return "Aquarius";
    if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) return "Pisces";
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return "Aries";
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return "Taurus";
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return "Gemini";
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return "Cancer";
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return "Leo";
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return "Virgo";
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return "Libra";
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) return "Scorpio";
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) return "Sagittarius";
    return "Capricorn";
  }

  String _getMoonSignForDay(int day) {
    const signs = ['Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'];
    return signs[(day * 2) % 12];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = CoStarColors.of(context);

    final transits = _calculateLiveTransits();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          'PLANETARY TRANSITS',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: transits.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final t = transits[index];
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: colors.border),
              borderRadius: BorderRadius.circular(12),
              color: colors.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item['planet']?.toUpperCase()} IN ${item['sign']?.toUpperCase()}',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Icon(LucideIcons.compass, size: 18, color: colors.textSecondary),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item['aspect']!,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Divider(height: 24),
                Text(
                  item['impact']!,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
