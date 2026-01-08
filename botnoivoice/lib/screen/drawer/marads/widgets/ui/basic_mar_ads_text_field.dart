import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool isRequired;
  final double? height;
  final int? maxLines;
  final Widget? suffixIcon;

  const MarAdsTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.isRequired = false,
    this.height,
    this.maxLines = 1,
    this.suffixIcon,
  });

  @override
  State<MarAdsTextField> createState() => _MarAdsTextFieldState();
}

class _MarAdsTextFieldState extends State<MarAdsTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: GoogleFonts.prompt(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF262626),
              height: 1.43,
              letterSpacing: 0.25,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            // ใช้ SizedBox คุมความสูงเฉพาะถ้ามีการกำหนด height (เช่นช่องกรอกยาวๆ)
            // ถ้าช่องปกติให้ TextField จัดการความสูงเองเพื่อให้ Text อยู่กลางพอดี
            height: widget.height,
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              maxLines: widget.maxLines,
              // ถ้า maxLines เป็น null (ช่องใหญ่) ให้ขยายเต็ม, ถ้าไม่ ให้เป็น false
              expands: widget.maxLines == null,
              textAlignVertical: widget.maxLines == null
                  ? TextAlignVertical.top
                  : TextAlignVertical.center,
              style: GoogleFonts.prompt(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF262626),
              ),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                hintText: widget.placeholder,
                hintStyle: GoogleFonts.prompt(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFC4C4C4), // สี Placeholder อ่อนๆ
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: widget.height != null ? 16.h : 14.h),
                // เส้นขอบปกติ (สีเทาอ่อน)
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(
                    color: Color(0xFFDBDBDB),
                    width: 1.0,
                  ),
                ),
                // เส้นขอบตอนกด (Focus)
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(
                    color: Color(0xFF9E9E9E),
                    width: 1.0,
                  ),
                ),
                suffixIcon: widget.suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
