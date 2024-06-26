import 'package:flutter/material.dart';

class GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.purple, Colors.blue],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
      

    final RRect rRect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}