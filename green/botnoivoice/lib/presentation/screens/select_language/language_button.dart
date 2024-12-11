import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageButton extends StatelessWidget {
  final String flagAsset; // ไฟล์รูปธงชาติที่จะแสดงในปุ่ม
  final String language; // ชื่อภาษาที่จะแสดงในปุ่ม
  final double width; // ความกว้างของปุ่ม
  final double height; // ความสูงของปุ่ม
  final double fontSize; // ขนาดตัวอักษร
  final bool isSelected; // สถานะว่าปุ่มนี้ถูกเลือกหรือไม่
  final VoidCallback onTap; // ฟังก์ชันที่เรียกเมื่อกดปุ่ม

  const LanguageButton({
    required this.flagAsset,
    required this.language,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // เรียกฟังก์ชัน onTap เมื่อกดปุ่ม
      child: Container(
        width: width, // กำหนดความกว้างของปุ่ม
        height: height, // กำหนดความสูงของปุ่ม
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          // กำหนดสีพื้นหลังและกรอบ
          color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF34BDFA) : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10.r), // มุมโค้งของปุ่ม
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // แสดงรูปธงชาติ
            Image.asset(
              flagAsset,
              width: 30.w,
              height: 20.h,
            ),
            SizedBox(width: 10.w),
            // แสดงชื่อภาษา
            Text(
              language,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, // กึ่งหนาเมื่อถูกเลือก
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
