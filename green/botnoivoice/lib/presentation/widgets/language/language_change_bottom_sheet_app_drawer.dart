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
  String selectedLanguage = await loadSelectedLanguage();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (BuildContext context) {
      return Align( // ✅ ติดขอบล่างของจอ
        alignment: Alignment.bottomCenter, 
        child: FractionallySizedBox(
          heightFactor: 0.4, // ✅ ปรับขนาด (40% ของหน้าจอ)
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                    child: Row(
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
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: OrientationHelper.isLandscape ? 16.sp : 24.sp,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 16.h),

                          // ✅ ปุ่มเลือกภาษาไทย
                          Material(
                            color: Colors.transparent, 
                            child: InkWell(
                              onTap: () async {
                                await saveSelectedLanguage('th');
                                onLanguageSelected('th');
                                context.setLocale(const Locale('th'));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const HomeScreen()));
                              },
                              highlightColor: Colors.grey[300], 
                              splashColor: Colors.transparent, 
                              borderRadius: BorderRadius.circular(8.r),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/national_flag/thai.png',
                                        width: 26.w, height: 26.h),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'ไทย',
                                      style: GoogleFonts.prompt(
                                        fontSize: 14.sp,
                                        fontWeight: selectedLanguage == 'th' ? FontWeight.w600 : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // ✅ ปุ่มเลือกภาษาอังกฤษ
                          Material(
                            color: Colors.transparent, 
                            child: InkWell(
                              onTap: () async {
                                await saveSelectedLanguage('en');
                                onLanguageSelected('en');
                                context.setLocale(const Locale('en'));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const HomeScreen()));
                              },
                              highlightColor: Colors.grey[300], 
                              splashColor: Colors.transparent, 
                              borderRadius: BorderRadius.circular(8.r),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/national_flag/english.png',
                                        width: 26.w, height: 26.h),
                                    SizedBox(width: 12.w),
                                    Text(
                                      'English',
                                      style: GoogleFonts.prompt(
                                        fontSize: 14.sp,
                                        fontWeight: selectedLanguage == 'en' ? FontWeight.w600 : FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
