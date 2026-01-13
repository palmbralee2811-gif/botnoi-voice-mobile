import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart'; 
import 'genskript_ui_style.dart';

class GenskriptDownloadOptionsDialog extends StatefulWidget {
  final int points;
  final Function(String extension) onConfirm;

  const GenskriptDownloadOptionsDialog({
    super.key,
    required this.points,
    required this.onConfirm,
  });

  @override
  State<GenskriptDownloadOptionsDialog> createState() => _GenskriptDownloadOptionsDialogState();
}

class _GenskriptDownloadOptionsDialogState extends State<GenskriptDownloadOptionsDialog> {
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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Download File",
                  style: GoogleFonts.prompt(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Icon(Icons.close, size: 24.sp, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Tabs
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => GenskriptUIStyle.cyanPurpleGradient.createShader(bounds),
                        child: Text("Audio Only", style: GoogleFonts.prompt(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                      SizedBox(height: 5.h),
                      Container(height: 2.h, decoration: const BoxDecoration(gradient: GenskriptUIStyle.cyanPurpleGradient)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text("Video", style: GoogleFonts.prompt(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey)),
                      SizedBox(height: 5.h),
                      Container(height: 2.h, color: Colors.transparent),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Dropdown
            Text("Select File Format", style: GoogleFonts.prompt(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8.r)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFormat,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: _formats.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: GoogleFonts.inter(fontSize: 14.sp)),
                    );
                  }).toList(),
                  onChanged: (newValue) => setState(() => _selectedFormat = newValue!),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            const Divider(),
            SizedBox(height: 10.h),

            // Points
            Text("Confirm Download", style: GoogleFonts.prompt(fontSize: 14.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Points:", style: GoogleFonts.prompt(fontSize: 14.sp)),
                ShaderMask(
                  shaderCallback: (bounds) => GenskriptUIStyle.cyanPurpleGradient.createShader(bounds),
                  child: Text("${widget.points} PT", style: GoogleFonts.prompt(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16.sp, color: Colors.blue),
                SizedBox(width: 5.w),
                Expanded(child: Text("Note: Background music will be removed in download.", style: GoogleFonts.inter(fontSize: 10.sp, color: Colors.grey))),
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
                      side: const BorderSide(color: Color(0xFF888888)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text("Cancel", style: GoogleFonts.prompt(fontSize: 16.sp, color: const Color(0xFF888888))),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop(); // Close dialog first
                      widget.onConfirm(_selectedFormat); // Then callback
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      backgroundColor: const Color(0xFF262626),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    ),
                    child: Text("Confirm", style: GoogleFonts.prompt(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w600)),
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