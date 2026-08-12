import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PaywallDialog extends StatelessWidget {
  const PaywallDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('CO-STAR PREMIUM', style: TextStyle(color: Color(0xFF888888), fontSize: 9, fontFamily: 'monospace')),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.black, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('UNLOCK YOUR FULL CHART', textAlign: TextAlign.center, style: GoogleFonts.cormorantGaramond(fontSize: 24, color: Colors.black)),
            const SizedBox(height: 8),
            const Text('Understand yourself and your relationships on a deeper level.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF555555), fontSize: 12)),
            const SizedBox(height: 24),
            _featureRow('Full Birth Chart Interpretation'),
            _featureRow('Advanced Synastry & Compatibility'),
            _featureRow('Eros Couple Relationship Report'),
            _featureRow('AI Cosmic Astrologer Assistant'),
            _featureRow('Full Natal Chart for Non-Users'),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                border: Border.all(color: Colors.black),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ANNUAL PASS', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                      Text('₹1,999 / year (Save 45%)', style: TextStyle(color: Color(0xFF666666), fontSize: 10)),
                    ],
                  ),
                  Text('BEST VALUE', style: TextStyle(color: Colors.amber, fontSize: 9, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: const RoundedRectangleBorder(),
              ),
              child: const Text('START 7-DAY FREE TRIAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.0)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(LucideIcons.check, color: Colors.black, size: 14),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.black, fontSize: 12)),
        ],
      ),
    );
  }
}
