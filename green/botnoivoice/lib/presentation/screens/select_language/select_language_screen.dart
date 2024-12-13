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
                  width: 256.w,
                  height: 56.h,
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
                      fontSize: 22.sp,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // ปุ่มสำหรับเลือกภาษา English
                LanguageButton(
                  flagAsset: 'assets/images/national_flag/english.png',
                  language: 'English (UK)',
                  width: 256.w,
                  height: 48.h,
                  fontSize: 16.sp,
                  isSelected: selectedLanguage ==
                      'English (UK)', // ตรวจสอบว่าภาษานี้ถูกเลือกหรือไม่
                  onTap: () async {
                    // เลือกภาษาอังกฤษ
                    // setState(() {
                    // saveSelectedLanguage('en');
                    await LanguageHelper.saveSelectedLanguage('en');
                    context.setLocale(const Locale('en'));
                    // });

                    // push ไปหน้า Login
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => AuthChecker(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                // ปุ่มสำหรับเลือกภาษาไทย
                LanguageButton(
                  flagAsset: 'assets/images/national_flag/thai.png',
                  language: 'ไทย',
                  width: 256.w,
                  height: 48.h,
                  fontSize: 16.sp,
                  isSelected: selectedLanguage ==
                      'ไทย', // ตรวจสอบว่าภาษานี้ถูกเลือกหรือไม่
                  onTap: () async {
                    // ใช้ setState เพื่ออัปเดตสถานะ
                    // setState(() {
                    // เลือกภาษาไทย
                    // saveSelectedLanguage('th');
                    await LanguageHelper.saveSelectedLanguage('th');
                    context.setLocale(const Locale('th'));
                    // });

                    // push ไปหน้า Login
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
