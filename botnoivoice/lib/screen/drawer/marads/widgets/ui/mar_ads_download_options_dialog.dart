import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsDownloadOptionsDialog extends StatefulWidget {
  final int points; // รับค่าพอยท์ที่จะหัก (ถ้ามี)
  final Function(String extension) onConfirm; // Callback เมื่อกดตกลง

  const MarAdsDownloadOptionsDialog({
    super.key,
    this.points = 197, // Default ไว้ก่อน
    required this.onConfirm,
  });

  @override
  State<MarAdsDownloadOptionsDialog> createState() =>
      _MarAdsDownloadOptionsDialogState();
}

class _MarAdsDownloadOptionsDialogState
    extends State<MarAdsDownloadOptionsDialog> {
  String _selectedFormat = 'mp3'; // ค่าเริ่มต้น
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
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 24.sp, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // 2. Tab (เฉพาะเสียง / วิดีโอ) - ทำ UI หลอกไว้ก่อน
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // ใช้ ShaderMask เพื่อให้ตัวหนังสือเป็น Gradient
                      ShaderMask(
                        shaderCallback: (bounds) => MarAdsUIStyle
                            .cyanPurpleGradient
                            .createShader(bounds),
                        child: Text(
                          "เฉพาะเสียง",
                          style: GoogleFonts.prompt(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors
                                .white, // ต้องเป็นสีขาวเพื่อให้ Shader ทำงาน
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      // เส้นใต้ Gradient
                      Container(
                        height: 2.h,
                        decoration: const BoxDecoration(
                          gradient: MarAdsUIStyle.cyanPurpleGradient,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "วิดีโอ",
                        style: GoogleFonts.prompt(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Container(height: 2.h, color: Colors.transparent),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // 3. Dropdown เลือกนามสกุล
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
                  isExpanded: true,
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
            SizedBox(height: 10.h),
            const Divider(),
            SizedBox(height: 10.h),

            // 4. ยืนยันพอยท์
            Text(
              "ยืนยันการดาวน์โหลดไฟล์",
              style: GoogleFonts.prompt(
                  fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("พอยท์ที่ต้องจ่ายทั้งหมด:",
                    style: GoogleFonts.prompt(fontSize: 14.sp)),
                // ใช้ ShaderMask กับตัวเลขพอยท์
                ShaderMask(
                  shaderCallback: (bounds) =>
                      MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                  child: Text(
                    "${widget.points} PT",
                    style: GoogleFonts.prompt(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16.sp, color: Colors.blue),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    "หมายเหตุ : หากดาวน์โหลดเสียงแล้วเสียงพื้นหลังจะหายไป",
                    style:
                        GoogleFonts.inter(fontSize: 10.sp, color: Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // 5. ปุ่ม ยกเลิก / ตกลง
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
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
                  // สร้างปุ่ม Gradient โดยใช้ Container หุ้ม ElevatedButton
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onConfirm(_selectedFormat);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: const Color(0xFF262626), // สีดำ
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
