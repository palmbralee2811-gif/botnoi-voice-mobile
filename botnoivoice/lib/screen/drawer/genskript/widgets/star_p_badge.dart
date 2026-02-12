// lib/widgets/star_p_badge.dart
import 'package:flutter/material.dart';

// เปลี่ยนชื่อเป็น buildStarPBadge (ไม่มีขีดล่าง) เพื่อให้ไฟล์อื่นเรียกใช้ได้
Widget buildStarPBadge() {
  return Container(
    padding: const EdgeInsets.all(2),
    decoration: const BoxDecoration(
      color: Color(0xFF424242),
      shape: BoxShape.circle,
    ),
    child: const Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.stars,
          color: Color(0xFF80DEEA),
          size: 22,
        ),
        Text(
          "P",
          style: TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}