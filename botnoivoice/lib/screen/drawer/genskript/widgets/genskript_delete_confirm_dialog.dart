import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class GenskriptDeleteConfirmDialog extends StatelessWidget {
  const GenskriptDeleteConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 320.w, // ล็อคความกว้างให้สมส่วนกับหน้าจอและ Dialog อื่นๆ
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // เพิ่มกรอบวงกลมสีแดงอ่อนด้านหลังไอคอนถังขยะให้ดูพรีเมียมและโมเดิร์นขึ้น
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.delete_outline,
                        color: Colors.red, size: 40.sp),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "ยืนยันการลบ",
                    style: GoogleFonts.prompt(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "คุณแน่ใจหรือไม่\nว่าต้องการลบรายการนี้?\nเมื่อลบแล้วจะไม่สามารถกู้คืนได้",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.prompt(
                        fontSize: 14.sp, color: Colors.black54),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context
                              .pop(false), // ส่งค่า false กลับไป (ยกเลิก)
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                          ),
                          child: Text(
                            "ยกเลิก",
                            style: GoogleFonts.prompt(
                                fontSize: 14.sp, color: Colors.black87),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context
                              .pop(true), // ส่งค่า true กลับไป (ยืนยันลบ)
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                          ),
                          child: Text(
                            "ลบข้อมูล",
                            style: GoogleFonts.prompt(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ไอคอนกากบาทมุมขวาบน
            Positioned(
              top: 4.h,
              right: 4.w,
              child: IconButton(
                icon:
                    Icon(Icons.close, color: Colors.grey.shade600, size: 24.sp),
                onPressed: () => context.pop(false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
