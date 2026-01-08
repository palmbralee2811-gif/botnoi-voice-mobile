import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsPointsBadge extends StatelessWidget {
  final String points;

  const MarAdsPointsBadge({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: SvgPicture.asset(
              'assets/images/logo/credit-icon.svg',
              width: 20.w,
              height: 20.h,
            ),
          ),
          SizedBox(width: 4.w),
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Text(
              points,
              style: GoogleFonts.prompt(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold, // ใช้ Bold ให้เหมือน App Bar
                color: const Color(0xFF262626), // หรือ kDark
              ),
            ),
          ),
        ],
      ),
    );
  }
}
