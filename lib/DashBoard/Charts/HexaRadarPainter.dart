import 'dart:math';

import 'package:flutter/material.dart';

class HexRadarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> skills;
  final Color dataColor;
  final Color textColor;

  HexRadarChartPainter({
    required this.values,
    required this.skills,
    required this.dataColor,
    required this.textColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.8;
    final points = skills.length;
    final angleStep = 2 * pi / points;

    // Draw axis lines
    _drawAxisLines(canvas, center, radius, points, angleStep);

    // Draw data polygon
    _drawDataPolygon(canvas, center, radius, points, angleStep);

    // Draw labels
    _drawSkillLabels(canvas, center, radius, points, angleStep);
  }

  void _drawAxisLines(Canvas canvas, Offset center, double radius, int points,
      double angleStep) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    for (int i = 0; i < points; i++) {
      final angle = i * angleStep - pi / 2;
      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * cos(angle),
          center.dy + radius * sin(angle),
        ),
        paint,
      );
    }
  }

  void _drawDataPolygon(Canvas canvas, Offset center, double radius, int points,
      double angleStep) {
    final path = Path();

    for (int i = 0; i < points; i++) {
      final angle = i * angleStep - pi / 2;
      final value = values[i] / 100;
      final point = Offset(
        center.dx + radius * value * cos(angle),
        center.dy + radius * value * sin(angle),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = dataColor.withOpacity(0.2)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = dataColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawSkillLabels(Canvas canvas, Offset center, double radius, int points,
      double angleStep) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < points; i++) {
      final angle = i * angleStep - pi / 2;
      final point = Offset(
        center.dx + radius * 1.2 * cos(angle),
        center.dy + radius * 1.2 * sin(angle),
      );

      textPainter.text = TextSpan(
        text: '${skills[i]}\n${values[i].toInt()}%',
        style: TextStyle(
          color: textColor,
          fontSize: 12,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          point.dx - textPainter.width / 2,
          point.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
