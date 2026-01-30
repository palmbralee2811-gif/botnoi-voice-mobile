import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget สำหรับ Dialog กำลังสร้างเสียง
class MarAdsLoadingDialog extends StatelessWidget {
  final String? title;

  const MarAdsLoadingDialog({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        width: 300.w,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        height: 200.h,
        child: Column(
          children: [
            const Spacer(),
            // ส่วนวงกลม Loading
            SizedBox(
              width: 80.w,
              height: 80.w,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 3,
                    color: Color(0xFFF0F0F0),
                  ),
                  // วงกลมหมุน
                  const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xFF262626),
                    strokeCap: StrokeCap.round,
                  ),
                  // ข้อความตรงกลาง
                  Center(
                    child: Icon(
                      Icons.mic,
                      color: const Color(0xFF262626),
                      size: 25.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              title ?? "marads_history.processing".tr(),
              style: GoogleFonts.prompt(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF262626),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
