import 'package:botnoivoice/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../screens/select_language/select_language_screen.dart';

void showLanguageBottomSheet({
  required BuildContext context,
  required Function(String) onLanguageSelected,
}) async {
  // Load the previously selected language
  String selectedLanguage = await loadSelectedLanguage();

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
              onTap: () async {
                // On selecting Thai language
                await saveSelectedLanguage('th');
                onLanguageSelected('th');
                context.setLocale(const Locale('th', 'TH'));

                // Refresh the current screen by navigating to it again
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const HomeScreen(),
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
                      'ไทย',
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
              onTap: () async {
                // On selecting English language
                await saveSelectedLanguage('en');
                onLanguageSelected('en');
                context.setLocale(const Locale('en', 'US'));

                // Refresh the current screen by navigating to it again
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const HomeScreen(),
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
                      'English',
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
