import 'package:botnoi_voice_mobile/Screens/SharedWidgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({ super.key, });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      width: 320.w,
      color: const Color(0xFF27282B),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              debugPrint('on tapped Studio Button 01 !!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 2.h),
                SvgPicture.asset(
                  'assets/images/icons/linear-icon.svg',
                  width: 17.25.w,
                  height: 20.25.h,
                ),
                SizedBox(height: 2.h),
                GradientText(
                  text: 'สตูดิโอ',
                  style: GoogleFonts.prompt(
                    color: const Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
                  ), 
                ),
              ],
            ),
          ),
          SizedBox(width: 40.w),
          InkWell(
            onTap: () {
              debugPrint('on tapped Studio Button 02 !!!');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 2.h),
                SvgPicture.asset(
                  'assets/images/icons/linear-icon.svg',
                  width: 17.25.w,
                  height: 20.25.h,
                ),
                SizedBox(height: 2.h),
                GradientText(
                  text: 'โปรเจค',
                  style: GoogleFonts.prompt(
                    color: const Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
                  ), 
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
