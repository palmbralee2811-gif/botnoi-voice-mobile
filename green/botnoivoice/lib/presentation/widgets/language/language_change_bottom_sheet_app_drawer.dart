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
  // โหลดภาษาที่เลือกไว้ก่อนหน้า
  String selectedLanguage = await loadSelectedLanguage();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // ✅ ให้ Bottom Sheet ใช้ขนาดที่เหมาะสม
    builder: (BuildContext context) {
      return Container(
        width: double.infinity, // ✅ ให้เต็มความกว้างจอ
        height: OrientationHelper.isLandscape ? 150.h : 250.h, // ✅ ใช้ OrientationHelper แทน MediaQuery
        decoration: const BoxDecoration(
          color: Colors.white, // ✅ พื้นหลังสีขาว
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)), // ✅ มุมโค้งด้านบน
        ),
        child: SingleChildScrollView( // ✅ ป้องกัน Overflow
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ ป้องกันขยายเกินไป
            children: [
              // แถบหัวข้อ
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'language'.tr(),
                      style: GoogleFonts.prompt(
                        fontSize: OrientationHelper.isLandscape ? 14.sp : 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context); // ปิด Bottom Sheet
                      },
                      child: Icon(
                        Icons.close,
                        size: OrientationHelper.isLandscape ? 18.sp : 24.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h), // ✅ เพิ่มระยะห่าง

              // ปุ่มเลือกภาษาไทย
              InkWell(
                onTap: () async {
                  await saveSelectedLanguage('th');
                  onLanguageSelected('th');
                  context.setLocale(const Locale('th'));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomeScreen()));
                },
                child: Container(
                  height: OrientationHelper.isLandscape ? 45.h : 55.h, // ✅ ปรับขนาดตามแนวนอน/แนวตั้ง
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Image.asset('assets/images/national_flag/thai.png', width: 34.w, height: 34.h),
                      SizedBox(width: 12.w),
                      Flexible(
                        child: Text(
                          'ไทย',
                          style: GoogleFonts.prompt(
                            fontSize: OrientationHelper.isLandscape ? 14.sp : 18.sp,
                            fontWeight: selectedLanguage == 'th' ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h), // ✅ เพิ่มระยะห่าง

              // ปุ่มเลือกภาษาอังกฤษ
              InkWell(
                onTap: () async {
                  await saveSelectedLanguage('en');
                  onLanguageSelected('en');
                  context.setLocale(const Locale('en'));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomeScreen()));
                },
                child: Container(
                  height: OrientationHelper.isLandscape ? 45.h : 55.h, // ✅ ปรับขนาดตามแนวนอน/แนวตั้ง
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Image.asset('assets/images/national_flag/english.png', width: 34.w, height: 34.h),
                      SizedBox(width: 12.w),
                      Flexible(
                        child: Text(
                          'English',
                          style: GoogleFonts.prompt(
                            fontSize: OrientationHelper.isLandscape ? 14.sp : 18.sp,
                            fontWeight: selectedLanguage == 'en' ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h), // ✅ ป้องกันติดขอบล่าง
            ],
          ),
        ),
      );
    },
  );
}
