import 'dart:math';

import 'package:flutter/material.dart';

class HexGridPainter extends CustomPainter {
  final Color gridColor;

  HexGridPainter({required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.8;

    final layers = [];
    final borderPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var layer in layers) {
      _drawHexBorder(canvas, center, radius * layer, borderPaint);
      _drawPercentageLabel(canvas, center, radius * layer, layer * 100);
    }
  }

  void _drawHexBorder(
      Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const sides = 6;
    const startAngle = -pi / 2;

    for (int i = 0; i <= sides; i++) {
      final angle = startAngle + (2 * pi * i / sides);
      final point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawPercentageLabel(
      Canvas canvas, Offset center, double radius, double percentage) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text: '${percentage.toInt()}%',
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 10,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx + radius * cos(-pi / 2) - textPainter.width / 2,
        center.dy + radius * sin(-pi / 2) - textPainter.height,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
