import 'dart:math';
import 'package:flutter/material.dart';
import '../models/astrology_models.dart';

class NatalChartPainter extends CustomPainter {
  final NatalChart chart;
  final PlanetPosition? hoveredPlanet;
  final bool isDark;

  NatalChartPainter({
    required this.chart,
    this.hoveredPlanet,
    this.isDark = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final outerRadius = radius * 0.94;
    final innerRadius = radius * 0.72;
    final houseRadius = radius * 0.50;
    final aspectRadius = radius * 0.44;

    final strokeColor = isDark ? Colors.white : Colors.black;
    final lineColor = isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0);
    final textMutedColor = isDark ? const Color(0xFF888888) : const Color(0xFF666666);

    // Subtle cosmic radial background
    final bgGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: isDark
            ? [const Color(0xFF1E1B4B).withOpacity(0.4), Colors.transparent]
            : [const Color(0xFFEDE9FE).withOpacity(0.5), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius));
    canvas.drawCircle(center, outerRadius, bgGlowPaint);

    final paintLine = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final paintStrongLine = Paint()
      ..color = isDark ? const Color(0xFFD4AF37).withOpacity(0.7) : const Color(0xFFB45309).withOpacity(0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // 1. Draw Concentric Rings
    canvas.drawCircle(center, outerRadius, paintStrongLine);
    canvas.drawCircle(center, innerRadius, paintStrongLine);
    canvas.drawCircle(center, houseRadius, paintLine);
    canvas.drawCircle(center, aspectRadius, paintLine);

    // 2. Draw 12 Zodiac Sign Segments
    final ascIndex = chart.risingSign.index;
    final rotationOffset = -ascIndex * (pi / 6);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < 12; i++) {
      final signAngle = rotationOffset + i * (pi / 6);

      // Outer segment line
      final x1 = center.dx + cos(signAngle) * innerRadius;
      final y1 = center.dy + sin(signAngle) * innerRadius;
      final x2 = center.dx + cos(signAngle) * outerRadius;
      final y2 = center.dy + sin(signAngle) * outerRadius;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paintLine);

      // House spoke
      final hx1 = center.dx + cos(signAngle) * aspectRadius;
      final hy1 = center.dy + sin(signAngle) * aspectRadius;
      canvas.drawLine(Offset(hx1, hy1), Offset(x1, y1), paintLine);

      // Element-based Color
      final sign = ZodiacSign.values[i];
      Color elementColor;
      switch (sign.element) {
        case 'Fire':
          elementColor = const Color(0xFFFF5722); // Vibrant Fire Orange/Red
          break;
        case 'Earth':
          elementColor = const Color(0xFF10B981); // Emerald Green
          break;
        case 'Air':
          elementColor = const Color(0xFF06B6D4); // Cyan / Celestial Blue
          break;
        case 'Water':
          elementColor = const Color(0xFF8B5CF6); // Deep Mystic Purple
          break;
        default:
          elementColor = strokeColor;
      }

      final midAngle = signAngle + (pi / 12);
      final glyphR = (outerRadius + innerRadius) / 2;
      final gx = center.dx + cos(midAngle) * glyphR;
      final gy = center.dy + sin(midAngle) * glyphR;

      textPainter.text = TextSpan(
        text: sign.symbol,
        style: TextStyle(
          color: elementColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'serif',
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(gx - textPainter.width / 2, gy - textPainter.height / 2));

      // Draw House Number
      final houseR = (innerRadius + houseRadius) / 2;
      final hnx = center.dx + cos(midAngle) * houseR;
      final hny = center.dy + sin(midAngle) * houseR;

      textPainter.text = TextSpan(
        text: '${i + 1}',
        style: TextStyle(
          color: textMutedColor,
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(hnx - textPainter.width / 2, hny - textPainter.height / 2));
    }

    // 3. Draw Aspect Lines with True Astrological Colors
    for (final asp in chart.aspects) {
      final p1 = chart.planets.firstWhere((p) => p.name == asp.planet1, orElse: () => chart.planets.first);
      final p2 = chart.planets.firstWhere((p) => p.name == asp.planet2, orElse: () => chart.planets.last);

      final p1Angle = rotationOffset + (p1.sign.index + p1.degree / 30) * (pi / 6);
      final p2Angle = rotationOffset + (p2.sign.index + p2.degree / 30) * (pi / 6);

      final ax1 = center.dx + cos(p1Angle) * aspectRadius;
      final ay1 = center.dy + sin(p1Angle) * aspectRadius;
      final ax2 = center.dx + cos(p2Angle) * aspectRadius;
      final ay2 = center.dy + sin(p2Angle) * aspectRadius;

      Color aspectColor;
      double strokeW = 1.0;
      switch (asp.type.toLowerCase()) {
        case 'trine':
          aspectColor = const Color(0xFF38BDF8); // Harmonious Soft Blue
          strokeW = 1.3;
          break;
        case 'sextile':
          aspectColor = const Color(0xFF34D399); // Soft Spring Green
          strokeW = 1.1;
          break;
        case 'square':
          aspectColor = const Color(0xFFEF4444); // Challenging Crimson Red
          strokeW = 1.3;
          break;
        case 'opposition':
          aspectColor = const Color(0xFFF97316); // Dynamic Orange
          strokeW = 1.3;
          break;
        case 'conjunction':
          aspectColor = const Color(0xFFFACC15); // Golden Conjunction
          strokeW = 1.5;
          break;
        default:
          aspectColor = isDark ? const Color(0xFFA78BFA) : const Color(0xFF7C3AED);
      }

      final aspPaint = Paint()
        ..color = aspectColor.withOpacity(0.75)
        ..strokeWidth = strokeW;

      canvas.drawLine(Offset(ax1, ay1), Offset(ax2, ay2), aspPaint);
    }

    // 4. Draw Planetary Nodes with Color Accents
    for (final planet in chart.planets) {
      final angle = rotationOffset + (planet.sign.index + planet.degree / 30) * (pi / 6);
      final px = center.dx + cos(angle) * houseRadius;
      final py = center.dy + sin(angle) * houseRadius;

      final isHovered = hoveredPlanet?.name == planet.name;
      final nodeR = isHovered ? 15.0 : 11.0;

      Color planetGlowColor;
      switch (planet.name.toLowerCase()) {
        case 'sun':
          planetGlowColor = const Color(0xFFF59E0B); // Gold
          break;
        case 'moon':
          planetGlowColor = const Color(0xFF93C5FD); // Lunar Blue
          break;
        case 'mars':
          planetGlowColor = const Color(0xFFEF4444); // Red
          break;
        case 'venus':
          planetGlowColor = const Color(0xFFEC4899); // Rose Pink
          break;
        case 'jupiter':
          planetGlowColor = const Color(0xFFA855F7); // Royal Purple
          break;
        case 'saturn':
          planetGlowColor = const Color(0xFFD97706); // Amber
          break;
        case 'mercury':
          planetGlowColor = const Color(0xFF10B981); // Emerald
          break;
        default:
          planetGlowColor = const Color(0xFF6366F1); // Indigo
      }

      // Outer glow for hovered or prominent planets
      canvas.drawCircle(
        Offset(px, py),
        nodeR + 3,
        Paint()..color = planetGlowColor.withOpacity(isHovered ? 0.4 : 0.15),
      );

      final nodeFillPaint = Paint()..color = isDark ? const Color(0xFF18181B) : Colors.white;
      final nodeStrokePaint = Paint()
        ..color = planetGlowColor
        ..strokeWidth = isHovered ? 2.0 : 1.4
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(Offset(px, py), nodeR, nodeFillPaint);
      canvas.drawCircle(Offset(px, py), nodeR, nodeStrokePaint);

      textPainter.text = TextSpan(
        text: planet.symbol,
        style: TextStyle(
          color: planetGlowColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'serif',
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(px - textPainter.width / 2, py - textPainter.height / 2));
    }

    // 5. Draw Horizon Line (ASC - DSC)
    final ascPaint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..strokeWidth = 1.8;

    canvas.drawLine(
      Offset(center.dx - houseRadius - 6, center.dy),
      Offset(center.dx + houseRadius + 6, center.dy),
      ascPaint,
    );

    textPainter.text = const TextSpan(
      text: 'ASC',
      style: TextStyle(color: Color(0xFFD4AF37), fontSize: 9, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - outerRadius - 22, center.dy - 6));
  }

  @override
  bool shouldRepaint(covariant NatalChartPainter oldDelegate) {
    return oldDelegate.chart != chart || oldDelegate.hoveredPlanet != hoveredPlanet || oldDelegate.isDark != isDark;
  }
}
