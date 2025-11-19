import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsDropdown extends StatefulWidget {
  final String label;
  final String value;
  final bool showInfoIcon;
  final VoidCallback onTap;

  const MarAdsDropdown({
    super.key,
    required this.label,
    required this.value,
    this.showInfoIcon = false,
    required this.onTap,
  });

  @override
  State<MarAdsDropdown> createState() => _MarAdsDropdownState();
}

class _MarAdsDropdownState extends State<MarAdsDropdown> {

  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF262626),
                    height: 1.43,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
              if (widget.showInfoIcon)
                Icon(
                  Icons.info_outline,
                  size: 12.w,
                  color: const Color(0xFF262626),
                ),
            ],
          ),
          SizedBox(height: 5.h),
          GestureDetector(
  onTapDown: (_) {
    setState(() {
      _isPressed = true;
    });
  },
  onTapUp: (_) {
    setState(() {
      _isPressed = false;
    });
    widget.onTap();
  },
  onTapCancel: () {
    setState(() {
      _isPressed = false;
    });
  },
  child: Container(
    height: 46.h,
    padding: EdgeInsets.all(1.5), // ความหนาเส้นขอบไล่สี
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              widget.value,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF262626),
                height: 1.25,  // ★ ทำให้ข้อความอยู่กึ่งกลางแนวตั้ง
                letterSpacing: 0.25,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: 12.w,
            color: const Color(0xFF262626),
          ),
        ],
      ),
    ),
  ),
),
        ],
      ),
    );
  }
}
