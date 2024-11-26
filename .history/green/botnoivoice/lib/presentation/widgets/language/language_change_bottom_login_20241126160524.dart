import 'package:botnoivoice/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // For responsive screen size adjustments

class LanguageChangeBottomSheetLogin extends StatefulWidget {
  const LanguageChangeBottomSheetLogin({Key? key}) : super(key: key);

  @override
  _LanguageChangeCustomWidgetState createState() =>
      _LanguageChangeCustomWidgetState();
}

class _LanguageChangeCustomWidgetState extends State<LanguageChangeCustomWidget> {
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
  void _showLanguageSelection() {
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
                    'language'.tr(),
                    style: GoogleFonts.prompt(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);  // Close the bottom sheet
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
                    Navigator.pop(context);  // Close the bottom sheet after selection
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
              }),
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

    // Set the locale based on the selected language
    if (language == 'th') {
      context.setLocale(const Locale('th', 'TH'));
    } else if (language == 'en') {
      context.setLocale(const Locale('en', 'US'));
    }

    // Optionally, navigate or refresh the app to reflect the language change
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BotnoiVoiceApp()), // Your app's entry point or home page
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showLanguageSelection, // Trigger the language selection modal
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
