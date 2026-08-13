import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/co_star_theme.dart';

class RelationshipTimelineScreen extends ConsumerWidget {
  const RelationshipTimelineScreen({super.key});

  final List<Map<String, String>> _events = const [
    {
      'date': 'OCTOBER 2026',
      'transit': 'Venus Trine Jupiter',
      'title': 'Harmony & Mutual Growth',
      'description': 'A period of effortless understanding and shared vision for the future.'
    },
    {
      'date': 'DECEMBER 2026',
      'transit': 'Mars Sextile Pluto',
      'title': 'Deepening Vulnerability',
      'description': 'Intense conversations lead to a powerful breakdown of emotional walls.'
    },
    {
      'date': 'FEBRUARY 2027',
      'transit': 'Full Moon in 7th House',
      'title': 'Relational Milestone',
      'description': 'A key decision point that consolidates your shared commitment.'
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
          'RELATIONSHIP TIMELINE',
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
        itemCount: _events.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final event = _events[index];
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
                      event['date']!,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Icon(LucideIcons.calendar, size: 16, color: colors.textSecondary),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  event['title']!,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event['transit']!,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Divider(height: 24),
                Text(
                  event['description']!,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 14,
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
