import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/co_star_theme.dart';
import '../../../core/services/api_client.dart';

class DailyRitualScreen extends ConsumerStatefulWidget {
  const DailyRitualScreen({super.key});

  @override
  ConsumerState<DailyRitualScreen> createState() => _DailyRitualScreenState();
}

class _DailyRitualScreenState extends ConsumerState<DailyRitualScreen> {
  bool _isCompleted = false;

  final Map<String, String> _todayRitual = {
    'title': 'THE GROUNDING STILLNESS',
    'duration': '5 MINS',
    'element': 'EARTH & AIR',
    'affirmation': 'I release what I cannot control and step boldly into presence.',
    'action': 'Light a single candle or sit by a window. Take 5 deep breaths, exhaling every expectation of perfection.',
  };

  @override
  Widget build(BuildContext context) {
    final colors = CoStarColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        title: Text(
          'DAILY RITUAL',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(16),
                color: colors.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _todayRitual['element']!,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.border),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _todayRitual['duration']!,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _todayRitual['title']!,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const Divider(height: 32),
                  Text(
                    'AFFIRMATION',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"${_todayRitual['affirmation']!}"',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'PRACTICE',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _todayRitual['action']!,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isCompleted = !_isCompleted;
                });
              },
              icon: Icon(
                _isCompleted ? LucideIcons.checkCircle : LucideIcons.flame,
                color: _isCompleted ? colors.background : colors.background,
              ),
              label: Text(
                _isCompleted ? 'RITUAL COMPLETED' : 'MARK COMPLETE',
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.textPrimary,
                foregroundColor: colors.background,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
