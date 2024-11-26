import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';  // For responsive screen size adjustments

class LanguageChangeBottomSheetLogin extends StatefulWidget {
  const LanguageChangeBottomSheet({Key? key}) : super(key: key);

  @override
  _LanguageChangeBottomSheetState createState() =>
      _LanguageChangeBottomSheetState();
}

class _LanguageChangeBottomSheetState extends State<LanguageChangeBottomSheet> {
  String _selectedLanguage = 'th'; // Default language is Thai

  // Define language options (with flags)
  final List<Map<String, String>> _languageOptions = [
    {'language': 'th', 'label': 'ไทย', 'icon': 'assets/images/national_flag/thai.png'}, // Thai flag path
    {'language': 'en', 'label': 'English', 'icon': 'assets/images/national_flag/english.png'}, // English flag path
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

  // Show the BottomSheet for language selection
  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Language',
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
              // Language selection options (with flags)
              ..._languageOptions.map((language) {
                return InkWell(
                  onTap: () {
                    _onLanguageSelected(language['language']!);
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
                          language['icon']!,
                          width: 23.w,
                          height: 23.h,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          language['label']!,
                          style: GoogleFonts.prompt(
                            fontSize: 14.sp,
                            fontWeight: _selectedLanguage == language['language']
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  // Handle language selection
  _onLanguageSelected(String language) {
    setState(() {
      _selectedLanguage = language;
    });
    _saveLanguage(language); // Save the selected language
    if (language == 'th') {
      context.setLocale(const Locale('th', 'TH'));
    } else if (language == 'en') {
      context.setLocale(const Locale('en', 'US'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showLanguageBottomSheet, // Show the bottom sheet on tap
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
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
              _selectedLanguage == 'th' ? 'ไทย' : 'English',
              style: GoogleFonts.prompt(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
