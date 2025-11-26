import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool isRequired;

  const MarAdsTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.isRequired = false,
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
      setState(() {
      });
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
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF262626),
              height: 1.43,
              letterSpacing: 0.25,
            ),
          ),
          SizedBox(height: 5.h),
          Container(
  height: 49.h,
  padding: const EdgeInsets.all(1.5), // ความหนาของกรอบไล่สี
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16.r),
    gradient: const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF332261),
        Color(0xFF7E2449),
      ],
    ),
  ),
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 20.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.r),
    ),
    child: TextField(
  controller: widget.controller,
  focusNode: _focusNode,
  textAlignVertical: TextAlignVertical.center,   // จัด baseline ให้ตรงกลาง
  style: GoogleFonts.inter(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF262626),
  ),
  decoration: InputDecoration(
    hintText: widget.placeholder,
    hintStyle: GoogleFonts.inter(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: const Color(0xFF888888),
    ),
    border: InputBorder.none,

    // 💡 ค่าที่ตรงกลางที่สุดสำหรับช่องสูง 49.h
    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
  ),
)

  ),
)
        ],
      ),
    );
  }
}
