import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsResultActionButtons extends StatelessWidget {
  final VoidCallback onCreateVoice;
  final VoidCallback onMakePersuasive;

  const MarAdsResultActionButtons({
    super.key,
    required this.onCreateVoice,
    required this.onMakePersuasive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r)),
              ),
              onPressed: onCreateVoice,
              child: Text(
                'สร้างเสียง',
                style: GoogleFonts.lexend(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r)),
              ),
              onPressed: onMakePersuasive,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ทำให้ดูโน้มน้าวมากขึ้น',
                    style: GoogleFonts.lexend(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF262626),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  _buildPointsIcon(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Stack(
            children: [
              Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF262626))),
              Center(
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                  child: Text(
                    'P',
                    style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          '15',
          style: GoogleFonts.lexend(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF262626)),
        ),
      ],
    );
  }
}
