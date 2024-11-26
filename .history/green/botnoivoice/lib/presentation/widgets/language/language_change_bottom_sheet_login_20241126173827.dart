import 'package:botnoivoice/domain/repositories/auth_checker.dart';
import 'package:botnoivoice/presentation/screens/home/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeBottomSheetLogin extends StatefulWidget {
  const LanguageChangeBottomSheetLogin({Key? key}) : super(key: key);

  @override
  _LanguageChangeBottomSheetLoginState createState() =>
      _LanguageChangeBottomSheetLoginState();
}

class _LanguageChangeBottomSheetLoginState
    extends State<LanguageChangeBottomSheetLogin> {
  String selectedLanguage = 'th'; // Default language is Thai
  String selectedLanguageImage =
      'assets/images/national_flag/thai.png'; // Default flag for Thai

  @override
  void initState() {
    super.initState();
    _loadLanguage(); // Load selected language when the widget is initialized
  }

  // Function to load the selected language from SharedPreferences
  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('selectedLanguage') ?? 'th';
    _updateLanguage(languageCode); // Update the language and flag
  }

  // Function to update language and flag
  void _updateLanguage(String languageCode) {
    setState(() {
      selectedLanguage = languageCode;
      selectedLanguageImage = languageCode == 'th'
          ? 'assets/images/national_flag/thai.png'
          : 'assets/images/national_flag/english.png';
    });
  }

  // Save selected language in SharedPreferences
  void _saveLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
  }

  // Function to handle language selection from bottom sheet
  void _onLanguageSelected(String languageCode) {
    context.setLocale(Locale(languageCode == 'th' ? 'th' : 'en',
        languageCode == 'th' ? 'TH' : 'US'));
    _saveLanguage(languageCode);
    _updateLanguage(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showLanguageBottomSheetLogin(
          context: context,
          selectedLanguage: selectedLanguage,
          onLanguageSelected: _onLanguageSelected,
        );
      },
      child: Container(
        width: 100.w,
        height: 35.h,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              selectedLanguageImage,
              width: 28.w,
              height: 28.h,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  selectedLanguage == 'th' ? 'ภาษาไทย' : 'English',
                  style: GoogleFonts.prompt(fontSize: 16.sp),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(ส),
              child: Icon(
                Icons.keyboard_arrow_down_sharp,
                size: 20,
                color: Color(0xFF323130),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showLanguageBottomSheetLogin({
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
                    builder: (BuildContext context) =>
                        AuthChecker(), // Replace with your current page widget
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
              onTap: () {
                // On selecting English language
                onLanguageSelected('en');
                context.setLocale(const Locale('en', 'US'));

                // Refresh the current screen by navigating to it again
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        AuthChecker(), // Replace with your current page widget
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
