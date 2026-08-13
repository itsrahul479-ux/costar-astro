import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            'element': 'Air',
            'key_traits': [
              'Intellectually stimulating',
              'Deeply empathetic and observant',
              'Values personal freedom with loyalty',
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
        title: Text(
          'AI SOULMATE PORTRAIT',
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Reading 7th House transits & synastry...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Soulmate Archetype Header Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.border),
                      borderRadius: BorderRadius.circular(16),
                      color: colors.surface,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.textPrimary),
                          ),
                          child: Center(
                            child: Icon(LucideIcons.userCheck, size: 36, color: colors.textPrimary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'YOUR COSMIC SOULMATE',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _soulmateData?['archetype'] ?? 'The Complementary Flame',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statColumn('IDEAL SIGNS', _soulmateData?['sun_sign'] ?? 'Air Signs', colors),
                            _statColumn('ELEMENT', _soulmateData?['element'] ?? 'Air', colors),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Key Traits Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.border),
                      borderRadius: BorderRadius.circular(12),
                      color: colors.surface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KEY RESONANCE TRAITS',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...((_soulmateData?['key_traits'] as List<dynamic>?) ?? []).map(
                          (trait) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Icon(LucideIcons.sparkles, size: 14, color: colors.textPrimary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    trait.toString(),
                                    style: TextStyle(color: colors.textPrimary, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Cosmic Connection Deep Dive Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.border),
                      borderRadius: BorderRadius.circular(12),
                      color: colors.surface,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SYNASTRY ALIGNMENT',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _soulmateData?['cosmic_connection'] ?? '',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _statColumn(String label, String value, CoStarColors colors) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
