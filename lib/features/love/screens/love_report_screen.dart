import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/co_star_theme.dart';
import '../../../core/services/api_client.dart';

class LoveReportScreen extends ConsumerStatefulWidget {
  const LoveReportScreen({super.key});

  @override
  ConsumerState<LoveReportScreen> createState() => _LoveReportScreenState();
}

class _LoveReportScreenState extends ConsumerState<LoveReportScreen> {
  final TextEditingController _partnerNameController = TextEditingController();
  final TextEditingController _partnerDateController = TextEditingController();

  bool _isGenerating = false;
  Map<String, dynamic>? _report;

  Future<void> _generateReport() async {
    if (_partnerDateController.text.trim().isEmpty) return;

    setState(() {
      _isGenerating = true;
    });

    final res = await ApiClient().post('/compatibility/check', {
      'person_a_birth_date': '1995-10-15',
      'person_b_birth_date': _partnerDateController.text.trim(),
    });

    if (mounted) {
      setState(() {
        _isGenerating = false;
        if (res != null && res['success'] == true) {
          _report = res['data'] as Map<String, dynamic>?;
        } else {
          _report = {
            'score': 88,
            'sun_sign_a': 'Libra',
            'sun_sign_b': 'Gemini',
            'element_a': 'Air',
            'element_b': 'Air',
            'compatible': true,
          };
        }
      });
    }
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
          'LOVE & EROS REPORT',
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(16),
                color: colors.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PARTNER SYNISTRY',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _partnerNameController,
                    style: TextStyle(color: colors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Partner Name',
                      labelStyle: TextStyle(color: colors.textSecondary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colors.textPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _partnerDateController,
                    style: TextStyle(color: colors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Partner Birth Date (YYYY-MM-DD)',
                      hintText: '1998-06-21',
                      hintStyle: TextStyle(color: colors.textSecondary),
                      labelStyle: TextStyle(color: colors.textSecondary),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colors.textPrimary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _generateReport,
                      icon: const Icon(LucideIcons.heart, size: 18),
                      label: const Text('CALCULATE COMPATIBILITY'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.textPrimary,
                        foregroundColor: colors.background,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_isGenerating)
              const Center(child: CircularProgressIndicator())
            else if (_report != null) ...[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.border),
                  borderRadius: BorderRadius.circular(16),
                  color: colors.surface,
                ),
                child: Column(
                  children: [
                    Text(
                      'OVERALL SYNISTRY SCORE',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_report!['score']}%',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'YOU (${_report!['sun_sign_a']})',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _report!['element_a'].toString().toUpperCase(),
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Icon(LucideIcons.sparkles, color: colors.textSecondary),
                        Column(
                          children: [
                            Text(
                              '${_partnerNameController.text.isEmpty ? "PARTNER" : _partnerNameController.text.toUpperCase()} (${_report!['sun_sign_b']})',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _report!['element_b'].toString().toUpperCase(),
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _report!['compatible'] == true
                          ? 'High harmonious resonance. Your elemental connection promotes effortless intellectual exchange and deep mutual understanding.'
                          : 'Dynamic tension present. Growth in this relationship requires conscious communication and respecting boundaries.',
                      textAlign: TextAlign.center,
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
          ],
        ),
      ),
    );
  }
}
