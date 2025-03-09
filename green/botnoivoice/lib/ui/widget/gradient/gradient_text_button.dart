import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientTextButton(
      {super.key, required this.text, required this.onPressed});

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
        onPressed: onPressed,
        child: Text(text,
            style: GoogleFonts.prompt(
                color: Colors.white,
                fontSize:
                    ResponsiveDesignOrientation.isLandscape ? 13.sp : 16.sp,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
