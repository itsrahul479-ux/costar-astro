import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../shared/models/astrology_models.dart';
import '../../../core/theme/co_star_theme.dart';
import '../../../core/services/astrology_engine.dart';
import '../../../core/router/app_router.dart';
import '../../subscription/screens/paywall_dialog.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  Friend? _selectedFriend;

  @override
  Widget build(BuildContext context) {
    final userChart = ref.watch(userNatalChartProvider);
    final friends = ref.watch(friendsProvider);
    final colors = CoStarColors.of(context);

    if (userChart == null) {
      return Center(child: CircularProgressIndicator(color: colors.textPrimary));
    }

    _selectedFriend ??= friends.first;
    final compat = _selectedFriend != null
        ? AstrologyEngine.calculateCompatibility(userChart, _selectedFriend!.chart)
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SOCIAL SYNASTRY', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
                  Text('FRIENDS & MATCH', style: GoogleFonts.cormorantGaramond(fontSize: 26, color: colors.textPrimary)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddFriendDialog(context),
                icon: Icon(LucideIcons.userPlus, size: 14, color: colors.btnText),
                label: Text('ADD', style: TextStyle(fontSize: 10, letterSpacing: 1.0, color: colors.btnText)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.btnBg,
                  foregroundColor: colors.btnText,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: const RoundedRectangleBorder(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Friends Selector Carousel
          Text('SELECT FRIEND TO COMPARE', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: friends.map((f) {
                final isSel = _selectedFriend?.id == f.id;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFriend = f),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSel ? colors.btnBg : colors.cardBg,
                      border: Border.all(color: isSel ? colors.btnBg : colors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(f.name, style: TextStyle(color: isSel ? colors.btnText : colors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('${f.sunSign.symbol} ${f.sunSign.displayName}', style: TextStyle(color: isSel ? colors.btnText.withAlpha(200) : colors.textSecondary, fontSize: 10, fontFamily: 'monospace')),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Compatibility Match Card
          if (_selectedFriend != null && compat != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.cardBg,
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  Text('COSMIC SYNASTRY MATCH', style: TextStyle(color: colors.textMuted, fontSize: 9, fontFamily: 'monospace')),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('YOU', style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(userChart.sunSign.displayName, style: TextStyle(color: colors.textSecondary, fontSize: 11)),
                        ],
                      ),
                      Text('×', style: TextStyle(color: colors.textMuted, fontSize: 24)),
                      Column(
                        children: [
                          Text(_selectedFriend!.name.toUpperCase(), style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(_selectedFriend!.sunSign.displayName, style: TextStyle(color: colors.textSecondary, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: colors.border),
                  const SizedBox(height: 8),
                  Text('${compat.overallScore}%', style: GoogleFonts.cormorantGaramond(fontSize: 48, color: colors.textPrimary)),
                  Text('COMPATIBILITY INDEX', style: TextStyle(color: colors.textMuted, fontSize: 9, fontFamily: 'monospace')),
                  const SizedBox(height: 12),
                  Text(
                    '"${compat.connectionSummary}"',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.textSecondary, fontSize: 11, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Category Breakdown Bars
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.cardBg,
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CATEGORY BREAKDOWN', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
                  const SizedBox(height: 16),
                  _bar(context, 'COMMUNICATION', compat.communicationScore),
                  const SizedBox(height: 10),
                  _bar(context, 'ROMANCE & PASSION', compat.romanceScore),
                  const SizedBox(height: 10),
                  _bar(context, 'FRIENDSHIP & TRUST', compat.friendshipScore),
                  const SizedBox(height: 10),
                  _bar(context, 'EMOTIONAL SAFETY', compat.emotionalScore),
                  const SizedBox(height: 10),
                  _bar(context, 'CREATIVE SYNERGY', compat.creativityScore),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Eros Couple Dynamic
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.btnBg,
                border: Border.all(color: colors.btnBg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.flame, color: colors.btnText, size: 16),
                          const SizedBox(width: 6),
                          Text('EROS RELATIONSHIP DYNAMICS', style: TextStyle(color: colors.btnText, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text('FEATURED', style: TextStyle(color: colors.btnText.withAlpha(200), fontSize: 9, fontFamily: 'monospace')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('TODAY\'S PARTNER DYNAMIC', style: TextStyle(color: colors.btnText.withAlpha(180), fontSize: 9, fontFamily: 'monospace')),
                  const SizedBox(height: 4),
                  Text(
                    '"${compat.erosInsight}"',
                    style: TextStyle(color: colors.btnText, fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(context: context, builder: (_) => const PaywallDialog());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.btnText,
                      foregroundColor: colors.btnBg,
                      minimumSize: const Size.fromHeight(40),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: const Text('UNLOCK FULL DEEP SYNASTRY REPORT', style: TextStyle(fontSize: 10, letterSpacing: 1.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _bar(BuildContext context, String label, int val) {
    final colors = CoStarColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: colors.textSecondary, fontSize: 9, fontFamily: 'monospace')),
            Text('$val%', style: TextStyle(color: colors.textPrimary, fontSize: 9, fontFamily: 'monospace')),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: val / 100,
          backgroundColor: colors.border,
          valueColor: AlwaysStoppedAnimation<Color>(colors.textPrimary),
          minHeight: 3,
        ),
      ],
    );
  }

  void _showAddFriendDialog(BuildContext context) {
    final colors = CoStarColors.of(context);
    final nameCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.bg,
        shape: const RoundedRectangleBorder(),
        title: Text('ADD A FRIEND', style: GoogleFonts.cormorantGaramond(color: colors.textPrimary, fontSize: 22)),
        content: TextField(
          controller: nameCtrl,
          style: TextStyle(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Enter name (e.g. Sarah)',
            hintStyle: TextStyle(color: colors.textMuted),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colors.border)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colors.textPrimary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('CANCEL', style: TextStyle(color: colors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                final friendProfile = const BirthProfile(
                  name: 'Friend',
                  birthDate: '1999-04-20',
                  birthTime: '14:30',
                  isTimeUnknown: false,
                  birthCity: 'Mumbai',
                  birthCountry: 'India',
                  latitude: 19.076,
                  longitude: 72.877,
                  timezone: 'Asia/Kolkata',
                );
                final friendChart = AstrologyEngine.calculateNatalChart(friendProfile);

                final newF = Friend(
                  id: 'friend_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  username: '@${nameCtrl.text.trim().toLowerCase()}',
                  sunSign: ZodiacSign.taurus,
                  moonSign: ZodiacSign.virgo,
                  risingSign: ZodiacSign.scorpio,
                  birthProfile: friendProfile,
                  chart: friendChart,
                );

                ref.read(friendsProvider.notifier).addFriend(newF);
                setState(() => _selectedFriend = newF);
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: colors.btnBg, foregroundColor: colors.btnText),
            child: const Text('ADD FRIEND'),
          ),
        ],
      ),
    );
  }
}
