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
  final TextInputAction? textInputAction;

  const MarAdsTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.isRequired = false,
    this.height,
    this.maxLines = 1,
    this.suffixIcon,
    this.textInputAction,
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
    final bool isFocused = _focusNode.hasFocus;

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
          Container(
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                        color: const Color(0xFFD6C8DD).withOpacity(0.6),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ]
                  : [],
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              
              // [สำคัญ] ถ้า maxLines เป็น null (กล่องใหญ่) ให้ใช้ multiline
              keyboardType: widget.maxLines == null 
                  ? TextInputType.multiline 
                  : TextInputType.text,
                  
              // [เพิ่ม] รับค่าปุ่ม Done หรือปุ่มอื่นๆ
              textInputAction: widget.textInputAction, 

              maxLines: widget.maxLines,
              expands: widget.maxLines == null, // ขยายเต็มพื้นที่ถ้า maxLines เป็น null
              textAlignVertical: widget.maxLines == null
                  ? TextAlignVertical.top // พิมพ์ชิดบน
                  : TextAlignVertical.center,
                  
              style: GoogleFonts.prompt(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF262626),
              ),
              
              // [เพิ่ม] ถ้ามีปุ่ม Done ให้กดแล้วปิดคีย์บอร์ด
               onSubmitted: (_) {
                _focusNode.unfocus(); // Close the keyboard with the "Done" button
              },
              
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                hintText: widget.placeholder,
                hintStyle: GoogleFonts.prompt(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFC4C4C4),
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: widget.height != null ? 16.h : 14.h),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(
                    color: Color(0xFFDBDBDB),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: const BorderSide(
                    // เปลี่ยนสีขอบตอน Focus ให้เข้ากับเงา หรือใช้สีเทาเข้มแบบเดิม
                    color: Color(0xFFDBDBDB),
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