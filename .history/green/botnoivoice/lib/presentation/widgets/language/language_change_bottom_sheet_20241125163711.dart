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

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.w), // Responsive padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 24.sp, // Responsive icon size
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/national_flag/thai.png',
                  width: 24.w, // Responsive flag size
                  height: 24.h,
                ),
                title: Text(
                  'ไทย',
                  style: GoogleFonts.prompt(
                    fontSize: 18.sp, // Responsive font size
                    fontWeight: _selectedLanguage == 'th'
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'th';
                  });
                  context.setLocale(const Locale('th', 'TH'));
                  _saveLanguage('th');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/national_flag/english.png',
                  width: 24.w,
                  height: 24.h,
                ),
                title: Text(
                  'English',
                  style: GoogleFonts.prompt(
                    fontSize: 18.sp,
                    fontWeight: _selectedLanguage == 'en'
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'en';
                  });
                  context.setLocale(const Locale('en', 'US'));
                  _saveLanguage('en');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _showLanguageBottomSheet,
      child: Text(
        tr('change_language'),
        style: GoogleFonts.prompt(
          fontSize: 16.sp, // Responsive font size
        ),
      ),
    );
  }
}
