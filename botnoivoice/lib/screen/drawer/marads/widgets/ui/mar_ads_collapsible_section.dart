import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsCollapsibleSection extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;

  const MarAdsCollapsibleSection({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // ปรับระยะห่างระหว่าง Section
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              gradient: LinearGradient(
                colors: MarAdsUIStyle.cyanPurpleGradient.colors
                    .map((color) => color.withOpacity(0.15))
                    .toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // หุ้มด้วย Expanded เพื่อป้องกันข้อความยาวเกิน
                  child: Text(
                    title,
                    style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF262626),
                      height: 1.43,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 24.sp,
                  color: const Color(0xFF262626),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
