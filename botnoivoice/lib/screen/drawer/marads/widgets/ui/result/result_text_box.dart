import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsResultTextBox extends StatelessWidget {
  final TextEditingController controller;
  final String mode; // 'Result' or 'Edit'
  final VoidCallback onClear;

  const MarAdsResultTextBox({
    super.key,
    required this.controller,
    required this.mode,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: MarAdsUIStyle.cyanPurpleGradient,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9747FF).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300.h,
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                readOnly: mode == 'Result',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF262626),
                  height: 1.43,
                  letterSpacing: 0.25,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // จัดการพื้นที่ด้านซ้าย: แสดงปุ่มลบ (ถ้ามี) + ข้อความเตือน (ถ้าเกิน)
                Expanded(
                  child: Row(
                    children: [
                      if (mode == 'Edit')
                        Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: GestureDetector(
                            onTap: onClear,
                            child: Icon(Icons.close,
                                size: 24.sp, color: const Color(0xFF4F4F4F)),
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  '${controller.text.length} ตัวอักษร',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: controller.text.length >= 1000
                        ? Colors.red
                        : const Color(0xFF888888),
                  ),
                ),
              ],
            ),
            // ส่วนนี้ต่อท้าย Row เพื่อให้แสดงข้อความเตือนด้านล่างสุด
            if (controller.text.length >= 1000)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  "ข้อความเกิน 1,000 ตัว ไม่สามารถสร้างเสียงได้",
                  style: GoogleFonts.prompt(
                    fontSize: 12.sp,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
