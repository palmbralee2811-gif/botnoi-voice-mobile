import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageChangeBottomSheet extends StatefulWidget {
  const LanguageChangeBottomSheet({super.key});

  @override
  State<LanguageChangeBottomSheet> createState() =>
      _LanguageChangeBottomSheetState();
}

class _LanguageChangeBottomSheetState extends State<LanguageChangeBottomSheet> {
  String _selectedLanguage = 'th'; // Default language (Thai)

  @override
  void initState() {
    super.initState();
    _loadLanguage(); // Load saved language when the widget initializes
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('selected_language');
    if (savedLanguage != null) {
      setState(() {
        _selectedLanguage = savedLanguage; // Set the selected language
      });
      if (_selectedLanguage == 'th') {
        context.setLocale(const Locale('th', 'TH'));
      } else if (_selectedLanguage == 'en') {
        context.setLocale(const Locale('en', 'US'));
      }
    }
  }

  Future<void> _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
  }

  void showLanguageBottomSheet(BuildContext context, String selectedLanguage,
      Function(String newLanguage) onLanguageSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 24.sp,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/national_flag/thai.png',
                  width: 28.w,
                  height: 28.h,
                ),
                title: Text(
                  'ไทย',
                  style: GoogleFonts.prompt(
                    fontSize: 18.sp,
                    fontWeight: selectedLanguage == 'th'
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                onTap: () {
                  onLanguageSelected('th');
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 15.h),
              ListTile(
                leading: Image.asset(
                  'assets/images/national_flag/english.png',
                  width: 28.w,
                  height: 28.h,
                ),
                title: Text(
                  'English',
                  style: GoogleFonts.prompt(
                    fontSize: 18.sp,
                    fontWeight: selectedLanguage == 'en'
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                onTap: () {
                  onLanguageSelected('en');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
