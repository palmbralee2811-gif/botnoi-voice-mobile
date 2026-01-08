import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsDeleteConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const MarAdsDeleteConfirmDialog({
    super.key,
    required this.onConfirm,
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
            // ไอคอนถังขยะสีแดงอ่อน
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: MarAdsUIStyle.errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_forever_outlined,
                size: 48.sp,
                color: MarAdsUIStyle.errorColor,
              ),
            ),
            SizedBox(height: 16.h),

            // หัวข้อ
            Text(
              "ลบข้อความ Generate นี้",
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF262626),
              ),
            ),
            SizedBox(height: 8.h),

            // รายละเอียด
            Text(
              "คุณยืนยันที่จะลบกล่องเสียงที่เลือกนี้ใช่หรือไม่",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: MarAdsUIStyle.textGrey,
              ),
            ),
            SizedBox(height: 24.h),

            // ปุ่ม Action
            Row(
              children: [
                // ปุ่มยกเลิก
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(
                          color: MarAdsUIStyle.linkColor, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "ยกเลิก",
                      style: GoogleFonts.prompt(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: MarAdsUIStyle.linkColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // ปุ่มตกลง (Gradient)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: MarAdsUIStyle.cyanPurpleGradient,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Close Dialog After Confirm
                        context.pop(); // ปิด Dialog ยืนยัน
                        onConfirm(); // เรียกฟังก์ชันลบ
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        "ตกลง",
                        style: GoogleFonts.prompt(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
