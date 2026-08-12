import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/co_star_theme.dart';
import '../../../core/router/app_router.dart';
import '../../ai_astrologer/screens/ai_astrologer_dialog.dart';
import '../../tarot/screens/tarot_screen.dart';
import '../../horoscope/screens/horoscope_screen.dart';
import '../../rituals/screens/daily_ritual_screen.dart';
import '../../transits/screens/transits_screen.dart';
import '../../journal/screens/journal_screen.dart';
import '../../love/screens/love_report_screen.dart';

class YouScreen extends ConsumerWidget {
  const YouScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userBirthProfileProvider);
    final chart = ref.watch(userNatalChartProvider);
    final insight = ref.watch(dailyInsightProvider);
    final colors = CoStarColors.of(context);

    if (profile == null || chart == null || insight == null) {
      return Center(child: CircularProgressIndicator(color: colors.textPrimary));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TODAY', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
                  Text(
                    'AUGUST 11, 2026',
                    style: GoogleFonts.cormorantGaramond(fontSize: 22, color: colors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.border),
                  color: colors.cardBg,
                ),
                child: Text(
                  '${chart.sunSign.symbol} ${chart.sunSign.displayName.toUpperCase()} SUN',
                  style: TextStyle(color: colors.textPrimary, fontSize: 10, fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Main Quote Hero Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.cardBg,
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('YOUR DAY', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
                    Text('● TODAY', style: TextStyle(color: colors.textPrimary, fontSize: 10, fontFamily: 'monospace')),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '"${insight.mainQuote}"',
                  style: GoogleFonts.cormorantGaramond(fontSize: 26, color: colors.textPrimary, height: 1.3),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: colors.textPrimary, width: 2)),
                  ),
                  child: Text(
                    insight.subQuote,
                    style: TextStyle(color: colors.textSecondary, fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Power & Challenge Cards
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('POWER', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
                      const SizedBox(height: 12),
                      ...insight.areasOfPower.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('● $p', style: TextStyle(color: colors.textPrimary, fontSize: 12, fontFamily: 'monospace')),
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CHALLENGE', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
                      const SizedBox(height: 12),
                      ...insight.areasOfChallenge.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('● $c', style: TextStyle(color: colors.textSecondary, fontSize: 12, fontFamily: 'monospace')),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Energy Levels
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.cardBg,
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CURRENT ENERGY', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
                const SizedBox(height: 16),
                _energyBar(context, 'RELATIONSHIPS', insight.energyLevels['relationships'] ?? 70),
                const SizedBox(height: 12),
                _energyBar(context, 'CAREER & PURPOSE', insight.energyLevels['career'] ?? 60),
                const SizedBox(height: 12),
                _energyBar(context, 'CREATIVITY', insight.energyLevels['creativity'] ?? 80),
                const SizedBox(height: 12),
                _energyBar(context, 'SELF & VITALITY', insight.energyLevels['self'] ?? 65),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Quick Feature Shortcuts Grid
          Text(
            'COSMIC TOOLS',
            style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace'),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.1,
            children: [
              _featureShortcut(
                context,
                title: '3-CARD TAROT',
                icon: LucideIcons.sparkles,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TarotScreen()),
                ),
              ),
              _featureShortcut(
                context,
                title: 'FORECAST',
                icon: LucideIcons.calendar,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HoroscopeScreen()),
                ),
              ),
              _featureShortcut(
                context,
                title: 'RITUAL',
                icon: LucideIcons.flame,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DailyRitualScreen()),
                ),
              ),
              _featureShortcut(
                context,
                title: 'TRANSITS',
                icon: LucideIcons.compass,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TransitsScreen()),
                ),
              ),
              _featureShortcut(
                context,
                title: 'JOURNAL',
                icon: LucideIcons.bookOpen,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JournalScreen()),
                ),
              ),
              _featureShortcut(
                context,
                title: 'LOVE REPORT',
                icon: LucideIcons.heart,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoveReportScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Ask the Stars AI Banner
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AiAstrologerDialog(chart: chart, userName: profile.name),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.btnBg,
                border: Border.all(color: colors.btnBg),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.sparkles, color: colors.btnText, size: 14),
                          const SizedBox(width: 6),
                          Text('ASK THE STARS', style: TextStyle(color: colors.btnText, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Have a question about your chart or transits?', style: TextStyle(color: colors.btnText.withAlpha(200), fontSize: 11)),
                    ],
                  ),
                  Icon(LucideIcons.arrowRight, color: colors.btnText, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _energyBar(BuildContext context, String label, int val) {
    final colors = CoStarColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: colors.textSecondary, fontSize: 10, fontFamily: 'monospace')),
            Text('$val%', style: TextStyle(color: colors.textPrimary, fontSize: 10, fontFamily: 'monospace')),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: val / 100,
          backgroundColor: colors.border,
          valueColor: AlwaysStoppedAnimation<Color>(colors.textPrimary),
          minHeight: 4,
        ),
      ],
    );
  }

  Widget _featureShortcut(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final colors = CoStarColors.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.cardBg,
          border: Border.all(color: colors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: colors.textPrimary),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 9,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
