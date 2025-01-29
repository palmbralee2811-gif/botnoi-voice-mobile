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
  // โหลดภาษาที่เลือกไว้ก่อนหน้า
  String selectedLanguage = await loadSelectedLanguage();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // ✅ ให้ Bottom Sheet ขยายเต็มความกว้าง
    builder: (BuildContext context) {
      return Container(
        width: double.infinity, // ✅ ทำให้ Bottom Sheet กว้างเต็มจอ
        height: OrientationHelper.isLandscape ? 180.h : 200.h, // ✅ คงความสูงเดิม
        decoration: const BoxDecoration(
          color: Colors.white, // ✅ ตั้งสีพื้นหลังให้เหมือน AppBar
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)), // ✅ ทำให้มุมบนโค้ง
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // แถบหัวข้อ
            Padding(
              padding: EdgeInsets.all(16.w),
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
                      Navigator.pop(context); // ปิด Bottom Sheet
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

            // ปุ่มเลือกภาษาไทย
            InkWell(
              onTap: () async {
                await saveSelectedLanguage('th');
                onLanguageSelected('th');
                context.setLocale(const Locale('th'));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomeScreen()));
              },
              child: Container(
                height: 50.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Image.asset('assets/images/national_flag/thai.png', width: 30.w, height: 30.h),
                    SizedBox(width: 10.w),
                    Text(
                      'ไทย',
                      style: GoogleFonts.prompt(
                        fontSize: 16.sp,
                        fontWeight: selectedLanguage == 'th' ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ปุ่มเลือกภาษาอังกฤษ
            InkWell(
              onTap: () async {
                await saveSelectedLanguage('en');
                onLanguageSelected('en');
                context.setLocale(const Locale('en'));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const HomeScreen()));
              },
              child: Container(
                height: 50.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Image.asset('assets/images/national_flag/english.png', width: 30.w, height: 30.h),
                    SizedBox(width: 10.w),
                    Text(
                      'English',
                      style: GoogleFonts.prompt(
                        fontSize: 16.sp,
                        fontWeight: selectedLanguage == 'en' ? FontWeight.w600 : FontWeight.w400,
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

