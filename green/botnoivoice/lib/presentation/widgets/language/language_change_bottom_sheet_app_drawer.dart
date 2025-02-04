import 'package:botnoivoice/presentation/screens/home/home_screen.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
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
        height: OrientationHelper.isLandscape ? 280.h : 180.h,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'language'.tr(),
                    style: GoogleFonts.prompt(
                      fontSize: OrientationHelper.isLandscape ? 12.sp : 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: Icon(
                      Icons.close,
                      size: OrientationHelper.isLandscape ? 16.sp : 24.sp,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: OrientationHelper.isLandscape ? 20.h : 15.h),
              InkWell(
                onTap: () async {
                  // On selecting Thai language
                  await saveSelectedLanguage('th');
                  onLanguageSelected('th');
                  context.setLocale(const Locale('th'));
          
                  // Refresh the current screen by navigating to it again
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const HomeScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                      left: OrientationHelper.isLandscape ? 0.w : 10.w),
                  height: OrientationHelper.isLandscape ? 62.h : 42.h,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/national_flag/thai.png',
                        width: OrientationHelper.isLandscape ? 44.w : 23.w,
                        height: OrientationHelper.isLandscape ? 44.h : 23.h,
                      ),
                      SizedBox(
                          width: OrientationHelper.isLandscape ? 10.w : 20.w),
                      Text(
                        'ไทย',
                        style: GoogleFonts.prompt(
                          fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
                          fontWeight: selectedLanguage == 'th'
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: OrientationHelper.isLandscape ? 20.h : 15.h),
              InkWell(
                onTap: () async {
                  // On selecting English language
                  await saveSelectedLanguage('en');
                  onLanguageSelected('en');
                  context.setLocale(const Locale('en'));
          
                  // Refresh the current screen by navigating to it again
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const HomeScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                      left: OrientationHelper.isLandscape ? 0.w : 10.w),
                  height: OrientationHelper.isLandscape ? 62.h : 42.h,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/national_flag/english.png',
                        width: OrientationHelper.isLandscape ? 44.w : 23.w,
                        height: OrientationHelper.isLandscape ? 44.h : 23.h,
                      ),
                      SizedBox(
                          width: OrientationHelper.isLandscape ? 10.w : 20.w),
                      Text(
                        'English',
                        style: GoogleFonts.prompt(
                          fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
                          fontWeight: selectedLanguage == 'en'
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: OrientationHelper.isLandscape ? 20.h : 15.h),
              InkWell(
                onTap: () async {
                  // On selecting English language
                  await saveSelectedLanguage('id');
                  onLanguageSelected('id');
                  context.setLocale(const Locale('id'));
          
                  // Refresh the current screen by navigating to it again
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const HomeScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(
                      left: OrientationHelper.isLandscape ? 0.w : 10.w),
                  height: OrientationHelper.isLandscape ? 62.h : 42.h,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/national_flag/indonesian.png',
                        width: OrientationHelper.isLandscape ? 44.w : 23.w,
                        height: OrientationHelper.isLandscape ? 44.h : 23.h,
                      ),
                      SizedBox(
                          width: OrientationHelper.isLandscape ? 10.w : 20.w),
                      Text(
                        'Indonesian',
                        style: GoogleFonts.prompt(
                          fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
                          fontWeight: selectedLanguage == 'id'
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
        ),
      );
    },
  );
}
