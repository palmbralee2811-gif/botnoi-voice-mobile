import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const MarAdsPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap:
                currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
            child: Icon(
              Icons.arrow_left_rounded,
              size: 32.sp,
              color:
                  currentPage > 1 ? const Color(0xFF262626) : Colors.grey[300],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.white,
            ),
            child: Text(
              '$currentPage',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: currentPage < totalPages
                ? () => onPageChanged(currentPage + 1)
                : null,
            child: Icon(
              Icons.arrow_right_rounded,
              size: 32.sp,
              color: currentPage < totalPages
                  ? const Color(0xFF262626)
                  : Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
