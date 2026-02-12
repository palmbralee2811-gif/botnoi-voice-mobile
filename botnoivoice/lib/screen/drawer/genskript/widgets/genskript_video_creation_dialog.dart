import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class GenskriptVideoCreationDialog extends StatefulWidget {
  final int videoPoints;
  final int voicePoints;
  // ✅ Callback now accepts the selected Codec string ('h264' or 'h265')
  final Function(String) onConfirm;

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
  // ✅ Default format
  String _selectedCodec = 'h264'; 

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
            _buildPointRow("พอยท์ที่ใช้สร้างวิดีโอ :", "${widget.videoPoints} PT", Colors.blue),
            SizedBox(height: 8.h),
            _buildPointRow("พอยท์ที่ใช้สร้างเสียง :", "${widget.voicePoints} PT", Colors.blue),
            const Divider(),
            _buildPointRow("พอยท์ที่ต้องใช้ทั้งหมด :", "$total PT", Colors.blue, isBold: true),
            
            SizedBox(height: 15.h),

            // ✅ Format Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("รูปแบบไฟล์วิดีโอ :", style: GoogleFonts.prompt(fontSize: 14.sp)),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCodec,
                        isExpanded: true,
                        style: GoogleFonts.prompt(fontSize: 14.sp, color: Colors.black),
                        // ✅ Options: H.264 & H.265
                        items: const [
                          DropdownMenuItem(
                            value: 'h264', 
                            child: Text("H.264 (General)", overflow: TextOverflow.ellipsis)
                          ),
                          DropdownMenuItem(
                            value: 'h265', 
                            child: Text("H.265 (High Quality)", overflow: TextOverflow.ellipsis)
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCodec = value;
                            });
                          }
                        },
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
                Icon(Icons.info_outline, color: Colors.blue, size: 18.sp),
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
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text("ยกเลิก", style: GoogleFonts.prompt(color: Colors.blue, fontSize: 16.sp)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop(); // Close dialog
                      // ✅ Pass selected codec back to parent
                      widget.onConfirm(_selectedCodec); 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
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