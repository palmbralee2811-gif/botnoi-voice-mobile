import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSortTap;

  const MarAdsSearchBar({
    super.key,
    required this.controller,
    this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: TextField(
                controller: controller,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  prefixIcon:
                      Icon(Icons.search, color: Colors.grey, size: 20.sp),
                  hintText: 'ค้นหา',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
          ),
          // เพิ่มปุ่ม Sort ด้านขวา
          if (onSortTap != null) ...[
            SizedBox(width: 12.w),
            InkWell(
              onTap: onSortTap,
              child: Icon(
                Icons.swap_vert, // ไอคอนลูกศรขึ้นลง
                color: const Color(0xFF262626),
                size: 24.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
