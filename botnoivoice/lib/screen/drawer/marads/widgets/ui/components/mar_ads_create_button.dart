import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsCreateButton extends StatelessWidget {
  final String remainingCount; // e.g. "10/10"
  final bool isFormValid;
  final bool isLoading;
  final VoidCallback onPressed;

  const MarAdsCreateButton({
    super.key,
    required this.remainingCount,
    required this.isFormValid,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.info_outline,
                  size: 12.w, color: const Color(0xFF262626)),
              SizedBox(width: 5.w),
              Text(
                'สร้างได้ $remainingCount ครั้ง',
                style: GoogleFonts.prompt(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF262626)),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Opacity(
            opacity: isFormValid ? 1.0 : 0.5,
            child: Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                color: const Color(0xFF262626),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r)),
                ),
                onPressed: (isFormValid && !isLoading) ? onPressed : null,
                child: isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: const CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 3))
                    : Text('สร้างข้อความ',
                        style: GoogleFonts.prompt(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
