import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/co_star_theme.dart';

class TransitsScreen extends ConsumerWidget {
  const TransitsScreen({super.key});

  final List<Map<String, String>> _currentTransits = const [
    {
      'planet': 'Sun',
      'sign': 'Aquarius',
      'aspect': 'Conjunction Saturn',
      'impact': 'High focus on long-term discipline and emotional boundaries.'
    },
    {
      'planet': 'Moon',
      'sign': 'Scorpio',
      'aspect': 'Trine Neptune',
      'impact': 'Heightened intuitive sensitivity and vivid dreams tonight.'
    },
    {
      'planet': 'Venus',
      'sign': 'Pisces',
      'aspect': 'Exaltation',
      'impact': 'Unconditional love, artistic inspiration, and empathetic connections.'
    },
    {
      'planet': 'Mars',
      'sign': 'Gemini',
      'aspect': 'Square Neptune',
      'impact': 'Channel physical energy into creative outlets rather than conflicts.'
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = CoStarColors.of(context);

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
        itemCount: _currentTransits.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = _currentTransits[index];
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
