import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsModeSelector extends StatelessWidget {
  final String selectedMode;
  final VoidCallback onTap;

  const MarAdsModeSelector({
    super.key,
    required this.selectedMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: Colors.white,
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: onTap,
          child: CustomPaint(
            painter: GradientBorderPainter(
              gradient: MarAdsUIStyle.cyanPurpleGradient,
              radius: 18.r,
              strokeWidth: 2,
            ),
            child: Container(
              height: 36.h, // ← ฟิกความสูงให้คอนเทนต์อยู่กลางแน่นอน
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                    child: Text(
                      selectedMode,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
