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
      // Set the locale based on the saved language
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

  Widget buildLanguageOption({
    required String languageName,
    required String flagPath,
    required String languageCode,
    required String countryCode,
    required BuildContext context,
    required void Function(StateSetter setModalState) setModalState,
  }) {
    return ListTile(
      leading: Image.asset(
        flagPath,
        width: 28.w, // Responsive width
        height: 28.h, // Responsive height
      ),
      title: Text(
        languageName,
        style: GoogleFonts.prompt(
          fontSize: 16.sp, // Responsive font size
          fontWeight: _selectedLanguage == languageCode
              ? FontWeight.w600
              : FontWeight.w400,
        ),
      ),
      onTap: () {
        setModalState((StateSetter setState) {
          setState(() {
            _selectedLanguage = languageCode;
          });
        } as StateSetter);
        context.setLocale(Locale(languageCode, countryCode));
        _saveLanguage(languageCode);
        Navigator.pop(context);
      },
    );
  }

  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: 220.h, // Responsive height
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                child: Column(
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
                    buildLanguageOption(
                      languageName: 'ไทย',
                      flagPath: 'assets/images/national_flag/thai.png',
                      languageCode: 'th',
                      countryCode: 'TH',
                      context: context,
                      setModalState: setModalState,
                    ),
                    SizedBox(height: 15.h),
                    buildLanguageOption(
                      languageName: 'English',
                      flagPath: 'assets/images/national_flag/english.png',
                      languageCode: 'en',
                      countryCode: 'US',
                      context: context,
                      setModalState: setModalState,
                    ),
                  ],
                ),
              ),
            );
          },
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
