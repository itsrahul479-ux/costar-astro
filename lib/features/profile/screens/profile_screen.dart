import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/co_star_theme.dart';
import '../../../core/router/app_router.dart';
import '../../subscription/screens/paywall_dialog.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userBirthProfileProvider);
    final chart = ref.watch(userNatalChartProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final colors = CoStarColors.of(context);

    if (profile == null || chart == null) {
      return Center(child: CircularProgressIndicator(color: colors.textPrimary));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.cardBg,
              border: Border.all(color: colors.border),
            ),
            child: Center(
              child: Text(
                profile.name.substring(0, 1).toUpperCase(),
                style: GoogleFonts.cormorantGaramond(fontSize: 36, color: colors.textPrimary),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // User Name
          Text(profile.name.toUpperCase(), style: GoogleFonts.cormorantGaramond(fontSize: 26, color: colors.textPrimary)),
          Text('Born ${profile.birthDate} in ${profile.birthCity}', style: TextStyle(color: colors.textMuted, fontSize: 11, fontFamily: 'monospace')),
          const SizedBox(height: 16),

          // Big 3 Badges
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _badge(context, '☉ ${chart.sunSign.displayName}'),
              const SizedBox(width: 8),
              _badge(context, '☽ ${chart.moonSign.displayName}'),
              const SizedBox(width: 8),
              _badge(context, 'ASC ${chart.risingSign.displayName}'),
            ],
          ),
          const SizedBox(height: 24),

          // THEME SELECTOR SETTING CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.cardBg,
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.sun, size: 14, color: colors.textPrimary),
                    const SizedBox(width: 6),
                    Text('APP THEME PREFERENCE', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _themeOption(
                        context,
                        label: 'LIGHT (DEFAULT)',
                        isSelected: currentThemeMode == ThemeMode.light,
                        onTap: () {
                          ref.read(themeModeProvider.notifier).state = ThemeMode.light;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _themeOption(
                        context,
                        label: 'DARK MODE',
                        isSelected: currentThemeMode == ThemeMode.dark,
                        onTap: () {
                          ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Subscription Banner
          InkWell(
            onTap: () => showDialog(context: context, builder: (_) => const PaywallDialog()),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.cardBg,
                border: Border.all(color: colors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.lock, color: Colors.amber, size: 14),
                          const SizedBox(width: 6),
                          Text('UNLOCKED BASIC ACCESS', style: TextStyle(color: colors.textPrimary, fontSize: 10, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Upgrade for full Synastry, Eros, & AI Astrology', style: TextStyle(color: colors.textSecondary, fontSize: 10)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => showDialog(context: context, builder: (_) => const PaywallDialog()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.btnBg,
                      foregroundColor: colors.btnText,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text('UPGRADE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Birth Data Registry
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.cardBg,
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('BIRTH DATA REGISTRY', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
                const SizedBox(height: 12),
                _dataRow(context, 'DATE OF BIRTH', profile.birthDate),
                Divider(color: colors.border),
                _dataRow(context, 'TIME OF BIRTH', profile.isTimeUnknown ? 'Unknown' : profile.birthTime),
                Divider(color: colors.border),
                _dataRow(context, 'CITY & COUNTRY', '${profile.birthCity}, ${profile.birthCountry}'),
                Divider(color: colors.border),
                _dataRow(context, 'COORDINATES', '${profile.latitude}°, ${profile.longitude}°'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Reset Account Button
          OutlinedButton.icon(
            onPressed: () {
              ref.read(userBirthProfileProvider.notifier).state = null;
            },
            icon: const Icon(LucideIcons.logOut, size: 14, color: Colors.redAccent),
            label: const Text('RESET BIRTH PROFILE & START OVER', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontFamily: 'monospace')),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFFCCCC)),
              minimumSize: const Size.fromHeight(48),
              shape: const RoundedRectangleBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeOption(BuildContext context, {required String label, required bool isSelected, required VoidCallback onTap}) {
    final colors = CoStarColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.btnBg : colors.bg,
          border: Border.all(color: isSelected ? colors.btnBg : colors.border),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? colors.btnText : colors.textPrimary,
              fontSize: 10,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _badge(BuildContext context, String text) {
    final colors = CoStarColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.cardBg,
        border: Border.all(color: colors.border),
      ),
      child: Text(text, style: TextStyle(color: colors.textPrimary, fontSize: 10, fontFamily: 'monospace')),
    );
  }

  Widget _dataRow(BuildContext context, String label, String value) {
    final colors = CoStarColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
          Text(value, style: TextStyle(color: colors.textPrimary, fontSize: 12, fontFamily: 'monospace')),
        ],
      ),
    );
  }
}
