import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'เพศ',
                  style: GoogleFonts.prompt(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 24.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                onLanguageSelected('th');
                context.setLocale(const Locale('th', 'TH'));
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.only(left: 10.w),
                height: 42.h,
                width: double.infinity,
                color: const Color(0xFFFFFFFF),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/national_flag/thai.png',
                      width: 24.w,
                      height: 24.h,
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      'ไทย',
                      style: GoogleFonts.prompt(
                        fontSize: 18.sp,
                        fontWeight: selectedLanguage == 'th'
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    SizedBox(height: 15.h),
    InkWell(
      onTap: () {
        onLanguageSelected('en');
        context.setLocale(const Locale('en', 'US'));
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10.w),
        height: 42.h,
        width: double.infinity,
        color: const Color(0xFFFFFFFF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/national_flag/english.png',
              width: 24.w,
              height: 24.h,
            ),
            SizedBox(width: 20.w),
            Text(
              'English',
              style: GoogleFonts.prompt(
                fontSize: 18.sp,
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
)
          ],
        ),
      );
    },
  );
}
