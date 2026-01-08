import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsSuccessDialog extends StatelessWidget {
  // เพิ่มตัวแปรรับค่า
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onPressed;

  const MarAdsSuccessDialog({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonText = 'ตกลง', // ค่า default คือ "ตกลง" แต่แก้ได้
    this.onPressed, // ถ้าไม่ส่งมา จะทำงานเป็น context.pop(); (ปิด Dialog)
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Container(
        width: 300.w,
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
              child: Icon(Icons.check_circle, size: 60.sp, color: Colors.white),
            ),
            SizedBox(height: 16.h),
            // ใช้ตัวแปร title แทนข้อความเดิม
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF262626)),
            ),
            SizedBox(height: 8.h),
            // ใช้ตัวแปร subtitle แทนข้อความเดิม
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 14.sp, color: const Color(0xFF888888)),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                // ถ้ามี onPressed ให้ทำตามนั้น ถ้าไม่มีให้ปิด Dialog
                onPressed: onPressed ??
                    () {
                      context.pop();
                    },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF888888), width: 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  foregroundColor: const Color(0xFF888888),
                ),
                child: Text(
                  buttonText,
                  style: GoogleFonts.prompt(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF888888)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
