import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/models/astrology_models.dart';
import '../../../shared/widgets/natal_chart_painter.dart';
import '../../../core/theme/co_star_theme.dart';
import '../../../core/router/app_router.dart';

class ChartScreen extends ConsumerStatefulWidget {
  const ChartScreen({super.key});

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen> {
  PlanetPosition? _selectedPlanet;

  @override
  Widget build(BuildContext context) {
    final chart = ref.watch(userNatalChartProvider);
    final colors = CoStarColors.of(context);

    if (chart == null) {
      return Center(child: CircularProgressIndicator(color: colors.textPrimary));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Text('COSMIC BLUEPRINT', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
                const SizedBox(height: 4),
                Text('YOUR NATAL CHART', style: GoogleFonts.cormorantGaramond(fontSize: 26, color: colors.textPrimary)),
                const SizedBox(height: 12),
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
              ],
            ),
          ),
          const SizedBox(height: 24),

          // CustomPainter Wheel Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.cardBg,
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: [
                Text(
                  'INTERACTIVE 360° WHEEL',
                  style: TextStyle(color: colors.textMuted, fontSize: 9, fontFamily: 'monospace'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CustomPaint(
                    painter: NatalChartPainter(
                      chart: chart,
                      hoveredPlanet: _selectedPlanet,
                      isDark: colors.isDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Planetary Placements List
          Text('PLANET PLACEMENTS', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: colors.cardBg,
              border: Border.all(color: colors.border),
            ),
            child: Column(
              children: chart.planets.map((planet) {
                return ListTile(
                  leading: Text(planet.symbol, style: TextStyle(fontSize: 20, color: colors.textPrimary, fontFamily: 'serif')),
                  title: Text(planet.name.toUpperCase(), style: TextStyle(color: colors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                  subtitle: Text(planet.meaning, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: colors.textSecondary, fontSize: 10)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${planet.sign.symbol} ${planet.sign.displayName}', style: TextStyle(color: colors.textPrimary, fontSize: 11, fontFamily: 'monospace')),
                      Text('${planet.degree}° • House ${planet.house}', style: TextStyle(color: colors.textMuted, fontSize: 9, fontFamily: 'monospace')),
                    ],
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: colors.bg,
                      shape: const RoundedRectangleBorder(),
                      builder: (_) => _buildPlanetSheet(context, planet),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // 12 Houses
          Text('12 HOUSES SYSTEM', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: chart.houses.length,
            itemBuilder: (context, idx) {
              final house = chart.houses[idx];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colors.cardBg,
                  border: Border.all(color: colors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(house.name.toUpperCase(), style: TextStyle(color: colors.textMuted, fontSize: 9, fontFamily: 'monospace')),
                        Text(house.sign.symbol, style: TextStyle(color: colors.textPrimary, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(house.sign.displayName, style: TextStyle(color: colors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(house.theme, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: colors.textSecondary, fontSize: 9)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _badge(BuildContext context, String text) {
    final colors = CoStarColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.cardBg,
        border: Border.all(color: colors.border),
      ),
      child: Text(text, style: TextStyle(color: colors.textPrimary, fontSize: 10, fontFamily: 'monospace')),
    );
  }

  Widget _buildPlanetSheet(BuildContext context, PlanetPosition planet) {
    final colors = CoStarColors.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(planet.symbol, style: TextStyle(fontSize: 32, color: colors.textPrimary, fontFamily: 'serif')),
              const SizedBox(width: 12),
              Text('${planet.name.toUpperCase()} IN ${planet.sign.displayName.toUpperCase()}', style: GoogleFonts.cormorantGaramond(fontSize: 22, color: colors.textPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          Text('Sign: ${planet.sign.displayName} (${planet.degree}°)', style: TextStyle(color: colors.textPrimary, fontSize: 12, fontFamily: 'monospace')),
          Text('House: ${planet.house}th House', style: TextStyle(color: colors.textPrimary, fontSize: 12, fontFamily: 'monospace')),
          const SizedBox(height: 16),
          Text('CORE MEANING', style: TextStyle(color: colors.textMuted, fontSize: 10, fontFamily: 'monospace')),
          const SizedBox(height: 4),
          Text(planet.meaning, style: TextStyle(color: colors.textSecondary, fontSize: 13, height: 1.5)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.btnBg,
              foregroundColor: colors.btnText,
              minimumSize: const Size.fromHeight(44),
              shape: const RoundedRectangleBorder(),
            ),
            child: const Text('CLOSE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
