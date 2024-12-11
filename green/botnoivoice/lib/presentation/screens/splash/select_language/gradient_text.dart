import 'package:flutter/material.dart';

// GradientText: วิดเจ็ตสำหรับแสดงข้อความที่มีสีไล่เฉด
class GradientText extends StatelessWidget {
  final String text; // ข้อความที่ต้องการแสดง
  final Gradient gradient; // ไล่สีที่ใช้
  final TextStyle style; // รูปแบบตัวอักษร (ฟอนต์, ขนาด ฯลฯ)

  const GradientText(this.text,
      {required this.gradient, required this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      // ใช้ ShaderMask เพื่อสร้างเอฟเฟกต์ไล่สี
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white), // ใช้ฟอนต์กึ่งหนา
      ),
    );
  }
}
