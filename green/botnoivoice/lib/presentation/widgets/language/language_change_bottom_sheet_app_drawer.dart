import 'package:botnoivoice/presentation/screens/home/home_screen.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/screens/select_language/select_language_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void showLanguageBottomSheet({
  required BuildContext context,
  required Function(String) onLanguageSelected,
}) async {
  String selectedLanguage = await loadSelectedLanguage();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    builder: (BuildContext context) {
      return SafeArea( 
        child: Padding(
          padding: EdgeInsets.only(bottom: OrientationHelper.isLandscape ? 10.h : 15.h), 
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: OrientationHelper.isLandscape ? 260.h : 320.h), 
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h), 
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'language'.tr(),
                        style: GoogleFonts.prompt(
                          fontSize: 14.sp, // 
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 16.sp, // 
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 1, height: 1, color: Colors.grey[300]), 

                
                Flexible(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(), 
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16.h), 

                        // ปุ่มเลือกภาษาไทย
                        InkWell(
                          onTap: () async {
                            await saveSelectedLanguage('th');
                            onLanguageSelected('th');
                            context.setLocale(const Locale('th'));
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomeScreen()));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.h), 
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 14.w),
                                Image.asset('assets/images/national_flag/thai.png', width: 26.w, height: 26.h), 
                                SizedBox(width: 8.w), 
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

                        SizedBox(height: 16.h), 

                        // ปุ่มเลือกภาษาอังกฤษ
                        InkWell(
                          onTap: () async {
                            await saveSelectedLanguage('en');
                            onLanguageSelected('en');
                            context.setLocale(const Locale('en'));
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomeScreen()));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.h), 
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 14.w),
                                Image.asset('assets/images/national_flag/english.png', width: 26.w, height: 26.h), 
                                SizedBox(width: 8.w), 
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
                        SizedBox(height: 16.h), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
