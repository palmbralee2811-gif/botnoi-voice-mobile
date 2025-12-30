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
                  style: GoogleFonts.prompt(
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
            onTap: widget.onTap,
            child: Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: const Color(0xFFDBDBDB), // สีขอบเทา
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.value,
                      style: GoogleFonts.prompt(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF262626),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: const Color(0xFF262626),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
