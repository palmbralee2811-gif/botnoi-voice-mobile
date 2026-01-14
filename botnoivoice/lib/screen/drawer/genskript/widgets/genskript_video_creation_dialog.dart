import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class GenskriptVideoCreationDialog extends StatefulWidget {
  final int videoPoints;
  final int voicePoints;
  final VoidCallback onConfirm;

  const GenskriptVideoCreationDialog({
    super.key,
    required this.videoPoints,
    required this.voicePoints,
    required this.onConfirm,
  });

  @override
  State<GenskriptVideoCreationDialog> createState() => _GenskriptVideoCreationDialogState();
}

class _GenskriptVideoCreationDialogState extends State<GenskriptVideoCreationDialog> {
  String _videoFormat = 'H.264 (General)';

  @override
  Widget build(BuildContext context) {
    int total = widget.videoPoints + widget.voicePoints;

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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("สร้างวิดีโอ HQ", // Create HQ Video
                    style: GoogleFonts.prompt(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black)),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Icon(Icons.close, size: 24.sp, color: Colors.black),
                )
              ],
            ),
            const Divider(),
            SizedBox(height: 10.h),

            // Points Calculation
            _buildPointRow("พอยท์ที่ใช้สร้างวิดีโอ :", "${widget.videoPoints} PT", Colors.cyan),
            SizedBox(height: 8.h),
            _buildPointRow("พอยท์ที่ใช้สร้างเสียง :", "${widget.voicePoints} PT", Colors.cyan),
            const Divider(),
            _buildPointRow("พอยท์ที่ต้องใช้ทั้งหมด :", "$total PT", Colors.cyan, isBold: true),
            
            SizedBox(height: 15.h),

            // Format Dropdown with Overflow Fix
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("รูปแบบไฟล์วิดีโอ :", style: GoogleFonts.prompt(fontSize: 14.sp)),
                SizedBox(width: 10.w),
                // ✅ Expanded prevents "Right Overflowed by 43 pixels"
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _videoFormat,
                        isExpanded: true, // Ensures text wraps if needed
                        style: GoogleFonts.prompt(fontSize: 14.sp, color: Colors.black),
                        items: ['H.264 (General)'].map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (v) {},
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 15.h),
            
            // Note
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.cyan, size: 18.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "หมายเหตุ :\n* วิดีโอจะถูกสร้างเป็นไฟล์เดียว\n* ราคาวิดีโอคำนวณจากสคริปต์\n* คุณสามารถปิดหน้านี้และไปทำอย่างอื่นได้",
                    style: GoogleFonts.inter(fontSize: 11.sp, color: Colors.grey),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      side: const BorderSide(color: Colors.cyan),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text("ยกเลิก", style: GoogleFonts.prompt(color: Colors.cyan, fontSize: 16.sp)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop(); // Close dialog
                      widget.onConfirm(); // Trigger API flow
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text("สร้างวิดีโอ HQ", style: GoogleFonts.prompt(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointRow(String label, String value, Color color, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.prompt(fontSize: 14.sp)),
        Text(value, style: GoogleFonts.prompt(fontSize: 16.sp, color: color, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}