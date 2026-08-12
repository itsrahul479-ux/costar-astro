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

    final outerRadius = radius * 0.92;
    final innerRadius = radius * 0.70;
    final houseRadius = radius * 0.48;
    final aspectRadius = radius * 0.42;

    final strokeColor = isDark ? Colors.white : Colors.black;
    final lineColor = isDark ? const Color(0xFF404040) : const Color(0xFFCCCCCC);
    final textMutedColor = isDark ? const Color(0xFF888888) : const Color(0xFF666666);

    final paintLine = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final paintStrongLine = Paint()
      ..color = strokeColor
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

      // Draw Zodiac Symbol
      final sign = ZodiacSign.values[i];
      final midAngle = signAngle + (pi / 12);
      final glyphR = (outerRadius + innerRadius) / 2;
      final gx = center.dx + cos(midAngle) * glyphR;
      final gy = center.dy + sin(midAngle) * glyphR;

      textPainter.text = TextSpan(
        text: sign.symbol,
        style: TextStyle(
          color: strokeColor,
          fontSize: 16,
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

    // 3. Draw Aspect Lines
    for (final asp in chart.aspects) {
      final p1 = chart.planets.firstWhere((p) => p.name == asp.planet1, orElse: () => chart.planets.first);
      final p2 = chart.planets.firstWhere((p) => p.name == asp.planet2, orElse: () => chart.planets.last);

      final p1Angle = rotationOffset + (p1.sign.index + p1.degree / 30) * (pi / 6);
      final p2Angle = rotationOffset + (p2.sign.index + p2.degree / 30) * (pi / 6);

      final ax1 = center.dx + cos(p1Angle) * aspectRadius;
      final ay1 = center.dy + sin(p1Angle) * aspectRadius;
      final ax2 = center.dx + cos(p2Angle) * aspectRadius;
      final ay2 = center.dy + sin(p2Angle) * aspectRadius;

      final aspPaint = Paint()
        ..color = (asp.type == 'Trine' || asp.type == 'Sextile') ? strokeColor : textMutedColor
        ..strokeWidth = 1.0;

      canvas.drawLine(Offset(ax1, ay1), Offset(ax2, ay2), aspPaint);
    }

    // 4. Draw Planetary Nodes
    final nodeFillPaint = Paint()..color = isDark ? const Color(0xFF121212) : Colors.white;
    final nodeStrokePaint = Paint()
      ..color = strokeColor
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (final planet in chart.planets) {
      final angle = rotationOffset + (planet.sign.index + planet.degree / 30) * (pi / 6);
      final px = center.dx + cos(angle) * houseRadius;
      final py = center.dy + sin(angle) * houseRadius;

      final isHovered = hoveredPlanet?.name == planet.name;
      final nodeR = isHovered ? 14.0 : 10.0;

      canvas.drawCircle(Offset(px, py), nodeR, isHovered ? (Paint()..color = strokeColor) : nodeFillPaint);
      canvas.drawCircle(Offset(px, py), nodeR, nodeStrokePaint);

      textPainter.text = TextSpan(
        text: planet.symbol,
        style: TextStyle(
          color: isHovered ? (isDark ? Colors.black : Colors.white) : strokeColor,
          fontSize: 11,
          fontFamily: 'serif',
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(px - textPainter.width / 2, py - textPainter.height / 2));
    }

    // 5. Draw Horizon Line (ASC)
    canvas.drawLine(
      Offset(center.dx - houseRadius, center.dy),
      Offset(center.dx + houseRadius, center.dy),
      Paint()..color = strokeColor..strokeWidth = 1.5,
    );

    textPainter.text = TextSpan(
      text: 'ASC',
      style: TextStyle(color: strokeColor, fontSize: 9, fontWeight: FontWeight.bold),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - outerRadius - 20, center.dy - 6));
  }

  @override
  bool shouldRepaint(covariant NatalChartPainter oldDelegate) {
    return oldDelegate.chart != chart || oldDelegate.hoveredPlanet != hoveredPlanet || oldDelegate.isDark != isDark;
  }
}
