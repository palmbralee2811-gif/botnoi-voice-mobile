import 'package:botnoivoice/data/authentication/auth_checker.dart';
import 'package:botnoivoice/presentation/screens/select_language/language_button.dart';
import 'package:botnoivoice/presentation/screens/select_language/language_helper.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = ''; // ตัวแปรสำหรับเก็บภาษาที่เลือก

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation; // ตรวจสอบ orientation
    final isPortrait = orientation == Orientation.portrait;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/splash_screen/background-320x684.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // GradientText: ข้อความ "Languages"
                Container(
                  width: isPortrait ? 256.w : 300.w, // ปรับตาม orientation
                  height: isPortrait ? 56.h : 70.h,
                  alignment: Alignment.center,
                  child: GradientText(
                    text: 'Languages',
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9340FF),
                        Color(0xFF34BDFA),
                      ],
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w600, // กึ่งหนา
                      fontSize: isPortrait ? 22.sp : 28.sp, // ปรับขนาดฟอนต์
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                SizedBox(height: isPortrait ? 20.h : 30.h), // ปรับระยะห่าง
                // ปุ่มสำหรับเลือกภาษา English
                LanguageButton(
                  flagAsset: 'assets/images/national_flag/english.png',
                  language: 'English (UK)',
                  width: isPortrait ? 256.w : 300.w,
                  height: isPortrait ? 48.h : 60.h,
                  fontSize: isPortrait ? 16.sp : 18.sp,
                  isSelected: selectedLanguage == 'English (UK)',
                  onTap: () async {
                    await LanguageHelper.saveSelectedLanguage('en');
                    context.setLocale(const Locale('en'));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AuthChecker(),
                      ),
                    );
                  },
                ),
                SizedBox(height: isPortrait ? 10.h : 15.h),
                // ปุ่มสำหรับเลือกภาษาไทย
                LanguageButton(
                  flagAsset: 'assets/images/national_flag/thai.png',
                  language: 'ไทย',
                  width: isPortrait ? 256.w : 300.w,
                  height: isPortrait ? 48.h : 60.h,
                  fontSize: isPortrait ? 16.sp : 18.sp,
                  isSelected: selectedLanguage == 'ไทย',
                  onTap: () async {
                    await LanguageHelper.saveSelectedLanguage('th');
                    context.setLocale(const Locale('th'));

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AuthChecker(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Save the selected language in shared preferences
Future<void> saveSelectedLanguage(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('selected_language', languageCode);
}

// Load the selected language from shared preferences
Future<String> loadSelectedLanguage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('selected_language') ??
      ''; // ตั้งภาษาเริ่มต้นที่แสดงเป็นค่าว่าง ตามภาษาที่ถูกเลือกหน้าแรก
}
