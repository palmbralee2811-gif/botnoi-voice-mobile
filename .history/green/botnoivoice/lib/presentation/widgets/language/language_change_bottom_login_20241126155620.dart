import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';  // For responsive screen size adjustments

class LanguageChangeBottomSheetLogin extends StatefulWidget {
  const LanguageChangeBottomSheetLogin({Key? key}) : super(key: key);

  @override
  _LanguageChangeBottomSheetState createState() =>
      _LanguageChangeBottomSheetState();
}

class _LanguageChangeBottomSheetState extends State<LanguageChangeBottomSheetLogin> {
  String _selectedLanguage = 'th'; // Default language is Thai

  // Define language options (with flags)
  final List<Map<String, String>> _languageOptions = [
    {'language': 'th', 'label': 'thai'.tr(), 'icon': 'assets/images/national_flag/thai.png'}, // Thai flag path
    {'language': 'en', 'label': 'english'.tr(), 'icon': 'assets/images/national_flag/english.png'}, // English flag path
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage(); // Load the saved language when the widget is initialized
  }

  // Load saved language from SharedPreferences
  _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('selected_language');
    if (savedLanguage != null) {
      setState(() {
        _selectedLanguage = savedLanguage; // Set the selected language
      });
      // Set the locale based on the saved language
      if (_selectedLanguage == 'th') {
        context.setLocale(const Locale('th', 'TH'));
      } else if (_selectedLanguage == 'en') {
        context.setLocale(const Locale('en', 'US'));
      }
    }
  }

  // Save selected language to SharedPreferences
  _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
  }

void _showLanguageBottomSheet() {
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
                SizedBox(height: 15.h),
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
                          'thai'.tr(),
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
                    onLanguageSelected('en');
                    context.setLocale(const Locale('en', 'US'));
                    Navigator.pop(context);
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
                          'english'.tr(),
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
            ));
      });
}


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showLanguageBottomSheet, // Show the bottom sheet on tap
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _selectedLanguage == 'th'
                  ? 'assets/images/national_flag/thai.png'
                  : 'assets/images/national_flag/english.png',
              width: 25.w,
              height: 25.h,
            ),
            SizedBox(width: 10.w),
            Text(
              _selectedLanguage == 'th' ? 'thai'.tr() : 'english'.tr(),
              style: GoogleFonts.prompt(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
