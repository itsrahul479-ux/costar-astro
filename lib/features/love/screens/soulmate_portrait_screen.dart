import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/co_star_theme.dart';
import '../../../core/services/api_client.dart';

class SoulmatePortraitScreen extends ConsumerStatefulWidget {
  const SoulmatePortraitScreen({super.key});

  @override
  ConsumerState<SoulmatePortraitScreen> createState() => _SoulmatePortraitScreenState();
}

class _SoulmatePortraitScreenState extends ConsumerState<SoulmatePortraitScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _soulmateData;

  Future<void> _generateSoulmateAnalysis() async {
    setState(() {
      _isLoading = true;
    });

    final res = await ApiClient().post('/content/soulmate-analysis', {
      'user_sun': 'Libra',
      'user_rising': 'Scorpio',
    });

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (res != null && res['success'] == true && res['data'] != null) {
          _soulmateData = res['data'] as Map<String, dynamic>?;
        } else {
          _soulmateData = {
            'archetype': 'The Luminous Mirror',
            'sun_sign': 'Gemini / Aquarius',
            'element': 'Air Element',
            'compatibility': '94% Synastry Alignment',
            'key_traits': [
              'Intellectually stimulating and sharp-witted',
              'Deeply empathetic, intuitive, and observant',
              'Values individual freedom with unwavering loyalty',
              'Inspires deep philosophical conversations at 2 AM',
            ],
            'cosmic_connection':
                'Your Scorpio rising draws in someone whose air element brings lightness to your intensity. They challenge your assumptions without disrupting your peace.',
          };
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _generateSoulmateAnalysis();
  }

  @override
  Widget build(BuildContext context) {
    final colors = CoStarColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'AI SOULMATE PORTRAIT',
          style: GoogleFonts.cormorantGaramond(
            color: colors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'READING 7TH HOUSE TRANSTIS & SYNASTRY...',
                    style: TextStyle(
                      color: colors.textMuted,
                      fontSize: 10,
                      fontFamily: 'monospace',
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Soulmate Hero Card (Amora Editorial Aesthetic)
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colors.border.withOpacity(0.6), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: colors.isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Cosmic Aura Avatar Ring
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.textPrimary.withOpacity(0.3), width: 1),
                            gradient: RadialGradient(
                              colors: [
                                colors.textPrimary.withOpacity(0.12),
                                colors.surface,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: colors.textPrimary, width: 1.5),
                                color: colors.background,
                              ),
                              child: Icon(LucideIcons.sparkles, size: 28, color: colors.textPrimary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'YOUR COSMIC SOULMATE',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 9,
                            fontFamily: 'monospace',
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _soulmateData?['archetype'] ?? 'The Luminous Mirror',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            color: colors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Compatibility Pill Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: colors.textPrimary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: colors.textPrimary.withOpacity(0.2)),
                          ),
                          child: Text(
                            _soulmateData?['compatibility'] ?? '94% Synastry Alignment',
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Divider(color: colors.border.withOpacity(0.5), height: 1),
                        const SizedBox(height: 20),

                        // Highlights Row
                        Row(
                          children: [
                            Expanded(
                              child: _statTile(
                                'IDEAL SIGNS',
                                _soulmateData?['sun_sign'] ?? 'Gemini / Aquarius',
                                LucideIcons.compass,
                                colors,
                              ),
                            ),
                            Container(
                              height: 36,
                              width: 1,
                              color: colors.border.withOpacity(0.5),
                            ),
                            Expanded(
                              child: _statTile(
                                'ELEMENT',
                                _soulmateData?['element'] ?? 'Air Element',
                                LucideIcons.wind,
                                colors,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Key Traits Section
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border.withOpacity(0.6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(LucideIcons.flame, size: 16, color: colors.textPrimary),
                            const SizedBox(width: 8),
                            Text(
                              'KEY RESONANCE TRAITS',
                              style: TextStyle(
                                color: colors.textMuted,
                                fontSize: 10,
                                fontFamily: 'monospace',
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...((_soulmateData?['key_traits'] as List<dynamic>?) ?? []).map(
                          (trait) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Icon(LucideIcons.check, size: 14, color: colors.textPrimary),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    trait.toString(),
                                    style: TextStyle(
                                      color: colors.textPrimary,
                                      fontSize: 14,
                                      height: 1.4,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Cosmic Connection Deep Dive Card
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border.withOpacity(0.6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(LucideIcons.heart, size: 16, color: colors.textPrimary),
                            const SizedBox(width: 8),
                            Text(
                              'SYNASTRY ALIGNMENT',
                              style: TextStyle(
                                color: colors.textMuted,
                                fontSize: 10,
                                fontFamily: 'monospace',
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _soulmateData?['cosmic_connection'] ?? '',
                          style: GoogleFonts.cormorantGaramond(
                            color: colors.textPrimary,
                            fontSize: 17,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _statTile(String label, String value, IconData icon, CoStarColors colors) {
    return Column(
      children: [
        Icon(icon, size: 16, color: colors.textMuted),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: colors.textMuted,
            fontSize: 9,
            fontFamily: 'monospace',
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

