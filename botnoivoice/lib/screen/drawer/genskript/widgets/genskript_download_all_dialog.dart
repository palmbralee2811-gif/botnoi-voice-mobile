import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

enum DownloadMode { zip, single }

class GenskriptDownloadAllDialog extends StatefulWidget {
  final int points;
  final Function(String extension, DownloadMode mode) onConfirm;

  const GenskriptDownloadAllDialog({
    super.key,
    required this.points,
    required this.onConfirm,
  });

  @override
  State<GenskriptDownloadAllDialog> createState() =>
      _GenskriptDownloadAllDialogState();
}

class _GenskriptDownloadAllDialogState
    extends State<GenskriptDownloadAllDialog> {
  String _selectedFormat = 'mp3';
  final List<String> _formats = ['mp3', 'wav'];
  DownloadMode _selectedMode = DownloadMode.zip;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: 340.w,
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(height: 16.h),

            Text(
              "เลือกนามสกุลไฟล์",
              style: GoogleFonts.prompt(
                  fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("นามสกุลไฟล์:",
                    style: GoogleFonts.prompt(fontSize: 14.sp)),
                Container(
                  height: 35.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedFormat,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _formats.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: GoogleFonts.inter(fontSize: 14.sp)),
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
              ],
            ),
            SizedBox(height: 16.h),

            // 3. ตัวเลือกรูปแบบไฟล์ (Zip - Single)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ดาวน์โหลดไฟล์ Zip:",
                    style: GoogleFonts.prompt(fontSize: 14.sp)),
                Radio<DownloadMode>(
                  value: DownloadMode.zip,
                  groupValue: _selectedMode,
                  activeColor: Colors.lightBlue,
                  onChanged: (DownloadMode? value) {
                    setState(() {
                      _selectedMode = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("รวมเป็นไฟล์เดียว:",
                    style: GoogleFonts.prompt(fontSize: 14.sp)),
                Radio<DownloadMode>(
                  value: DownloadMode.single,
                  groupValue: _selectedMode,
                  activeColor: Colors.lightBlue,
                  onChanged: (DownloadMode? value) {
                    setState(() {
                      _selectedMode = value!;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 8.h),
            const Divider(color: Colors.black87),
            SizedBox(height: 12.h),

            // ส่วนแสดงพอยท์ที่ต้องจ่าย
            Text(
              "ยืนยันการดาวน์โหลดไฟล์",
              style: GoogleFonts.prompt(
                  fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("พอยท์ที่ต้องจ่ายทั้งหมด:",
                    style: GoogleFonts.prompt(fontSize: 14.sp)),
                Text(
                  "${widget.points} PT",
                  style: GoogleFonts.prompt(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF00BFFF),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // 5. หมายเหตุ
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16.sp, color: Colors.lightBlue),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "หมายเหตุ : หากดาวน์โหลดเสียงแล้วเสียงพื้นหลังจะหายไป",
                    style: GoogleFonts.prompt(
                      fontSize: 12.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // 6. ปุ่ม ยกเลิก / ตกลง
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(color: Colors.lightBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "ยกเลิก",
                      style: GoogleFonts.prompt(
                          fontSize: 16.sp,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                      widget.onConfirm(_selectedFormat, _selectedMode);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "ตกลง",
                      style: GoogleFonts.prompt(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
