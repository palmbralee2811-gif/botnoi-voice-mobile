import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';


void showLanguageBottomSheet({
  required BuildContext context,
  required String selectedLanguage,
  required Function(String) onLanguageSelected,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.transparent,
        width: 280.w,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'language'.tr(),
                  style: GoogleFonts.prompt(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: Icon(
                    Icons.close,
                    size: 24.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            InkWell(
              onTap: () {
                // On selecting Thai language
                onLanguageSelected('th');
                context.setLocale(const Locale('th', 'TH'));

                // Refresh the current screen by navigating to it again
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const YourCurrentPage(), // Replace with your current page widget
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: 10.w),
                height: 42.h,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/national_flag/thai.png',
                      width: 23.w,
                      height: 23.h,
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      'thai'.tr(),
                      style: GoogleFonts.prompt(
                        fontSize: 14.sp,
                        fontWeight: selectedLanguage == 'th'
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // On selecting English language
                onLanguageSelected('en');
                context.setLocale(const Locale('en', 'US'));

                // Refresh the current screen by navigating to it again
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const YourCurrentPage(), // Replace with your current page widget
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(left: 10.w),
                height: 42.h,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/national_flag/english.png',
                      width: 23.w,
                      height: 23.h,
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      'english'.tr(),
                      style: GoogleFonts.prompt(
                        fontSize: 14.sp,
                        fontWeight: selectedLanguage == 'en'
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

