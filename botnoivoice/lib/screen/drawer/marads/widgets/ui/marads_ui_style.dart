import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarAdsUIStyle {
  // สีหลัก
  static const Color primary = Color(0xFF262626);
  static const Color grayLight = Color(0xFFC2C2C2);
  static const Color grayBackground = Color(0xFFF7F8FA);

  //  Gradient ฟ้า-ชมพู
  static const LinearGradient cyanPurpleGradient = LinearGradient(
    colors: [Color(0xFF01BFFB), Color(0xFFEB85FC)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Gradient ม่วงเข้ม-แดง
  static const LinearGradient purplePinkGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF332261), Color(0xFF7E2449)],
  );

  // Radius
  static BorderRadius radius16 = BorderRadius.circular(16.r);
  static BorderRadius radius20 = BorderRadius.circular(20.r);

  // Stroke default
  static BoxDecoration strokeBox = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: grayLight, width: 1),
  );

  // ปุ่ม hover หรือ focus
  static BoxDecoration hoverStrokeBox = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    border: Border.all(color: primary, width: 1.5),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6,
        offset: Offset(0, 2),
      )
    ],
  );

  // ปุ่มดำ
  static BoxDecoration solidButton = const BoxDecoration(
    color: primary,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );
}

// ย้าย Painter มาไว้ที่นี่ (รองรับ strokeWidth)
class GradientBorderPainter extends CustomPainter {
  final Gradient gradient;
  final double radius;
  final double strokeWidth;

  GradientBorderPainter(
      {required this.gradient, required this.radius, this.strokeWidth = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
