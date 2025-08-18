import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientLoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading; // Added isLoading parameter

  const GradientLoadingButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ResponsiveDesignOrientation.isLandscape ? 75.h : 50.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: isLoading ? null : onPressed, // Disable button when loading
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: GoogleFonts.prompt(
                  color: Colors.white,
                  fontSize:
                      ResponsiveDesignOrientation.isLandscape ? 13.sp : 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}