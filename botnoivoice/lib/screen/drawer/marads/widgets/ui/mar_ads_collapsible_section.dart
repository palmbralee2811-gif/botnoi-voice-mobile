import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsCollapsibleSection extends StatefulWidget {
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
  State<MarAdsCollapsibleSection> createState() =>
      _MarAdsCollapsibleSectionState();
}

class _MarAdsCollapsibleSectionState extends State<MarAdsCollapsibleSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 42.h,
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          gradient: MarAdsUIStyle.purplePinkGradient,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
          ),
          child: InkWell(
            onTap: widget.onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF262626),
                      height: 1.43,
                      letterSpacing: 0.25,
                    ),
                  ),
                ),
                Icon(
                  widget.isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16.w,
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
