import 'dart:ui';

import 'package:flutter/material.dart';

class GradientBorderPainter extends CustomPainter {
  final List<Color> gradientColors;
  final double borderRadius;

  GradientBorderPainter({
    required this.gradientColors, 
    required this.borderRadius
    });
  
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final RRect rRect = RRect.fromRectAndRadius(
      rect.deflate(1),
      Radius.circular(borderRadius)
    );
    _drawDashedLine(canvas, rRect, paint);
  }
  void _drawDashedLine(Canvas canvas, RRect rRect, Paint paint) {
    final dashWidth = 10.0; // Increase the length of the dash
    final dashSpace = 7.0;
    double distance = 0.0;

    final path = Path()..addRRect(rRect);

    for (PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        final extractPath = measurePath.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
      distance = 0.0; // Reset distance for next segment
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}