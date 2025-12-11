import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsFreeBadge extends StatelessWidget {
  final String remainingCount;

  const MarAdsFreeBadge({
    super.key,
    required this.remainingCount,
  });

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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              gradient: MarAdsUIStyle.cyanPurpleGradient, // ใช้ Style กลาง
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Text(
              'ฟรี',
              style: GoogleFonts.prompt(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Text(
              remainingCount,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF262626),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
