import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarAdsUIStyle {
  // สีหลัก
  static const Color primary = Color(0xFF262626);
  static const Color grayLight = Color(0xFFC2C2C2);
  static const Color grayBackground = Color(0xFFF7F8FA);

  // Gradient
  static const LinearGradient purplePinkGradient = LinearGradient(
    colors: [
      Color(0xFF332261),
      Color(0xFF7E2449),
    ],
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
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6,
        offset: Offset(0, 2),
      )
    ],
  );

  // ปุ่มดำ
  static BoxDecoration solidButton = BoxDecoration(
    color: primary,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );
}
