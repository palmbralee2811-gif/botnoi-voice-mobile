import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class GenskriptDownloadOptionsDialog extends StatefulWidget {
  final int points;
  final Function(String extension) onConfirm;

  const GenskriptDownloadOptionsDialog({
    super.key,
    required this.points,
    required this.onConfirm,
  });

  @override
  State<GenskriptDownloadOptionsDialog> createState() =>
      _GenskriptDownloadOptionsDialogState();
}

class _GenskriptDownloadOptionsDialogState
    extends State<GenskriptDownloadOptionsDialog> {
  String _selectedFormat = 'mp3';
  final List<String> _formats = ['mp3', 'wav'];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 320.w,
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. หัวข้อ + ปุ่มปิด
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ดาวน์โหลดไฟล์",
                  style: GoogleFonts.prompt(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Icon(Icons.close, size: 24.sp, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // 2. Dropdown เลือกนามสกุล
            Text(
              "เลือกนามสกุลไฟล์",
              style: GoogleFonts.prompt(
                  fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFormat,
                  isExpanded: true, // ทำให้กว้างเต็มกรอบ
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: _formats.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.inter(fontSize: 14.sp),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedFormat = newValue!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // 3. หมายเหตุ (Warning Text)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 18.sp, color: Colors.grey[600]),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    "หมายเหตุ : หากดาวน์โหลดเสียงแล้วเสียงพื้นหลังจะหายไป",
                    style: GoogleFonts.prompt(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // 4. ปุ่ม ยกเลิก / ตกลง (สไตล์ดำ-เทา แบบ MarAds)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(color: Color(0xFF888888)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "ยกเลิก",
                      style: GoogleFonts.prompt(
                        fontSize: 16.sp,
                        color: const Color(0xFF888888),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                      widget.onConfirm(_selectedFormat);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor:
                          const Color(0xFF262626), // สีดำตามแบบ MarAds
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "ตกลง",
                      style: GoogleFonts.prompt(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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
