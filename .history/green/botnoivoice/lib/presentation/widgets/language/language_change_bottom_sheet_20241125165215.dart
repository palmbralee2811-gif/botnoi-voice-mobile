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

  // Supported languages
  final List<Map<String, String>> _languages = [
    {'code': 'th', 'country': 'TH', 'name': 'ไทย', 'flag': 'assets/images/national_flag/thai.png'},
    {'code': 'en', 'country': 'US', 'name': 'English', 'flag': 'assets/images/national_flag/english.png'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('selected_language');
    if (savedLanguage != null) {
      setState(() {
        _selectedLanguage = savedLanguage;
      });
      _setLocale(savedLanguage);
    }
  }

  Future<void> _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
  }

  void _setLocale(String languageCode) {
    Locale locale;
    if (languageCode == 'th') {
      locale = const Locale('th', 'TH');
    } else if (languageCode == 'en') {
      locale = const Locale('en', 'US');
    } else {
      return; // Default or unsupported language
    }
    context.setLocale(locale);
  }

  Widget _buildLanguageTile({
    required String code,
    required String name,
    required String flag,
    required String country,
    required Function(String) onLanguageSelected,
  }) {
    return ListTile(
      leading: Image.asset(
        flag,
        width: 28.w,
        height: 28.h,
      ),
      title: Text(
        name,
        style: GoogleFonts.prompt(
          fontSize: 18.sp,
          fontWeight: _selectedLanguage == code ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      onTap: () {
        onLanguageSelected(code);
        Navigator.pop(context);
      },
    );
  }

  void showLanguageBottomSheet(BuildContext context) {
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
              ..._languages.map((lang) {
                return _buildLanguageTile(
                  code: lang['code']!,
                  name: lang['name']!,
                  flag: lang['flag']!,
                  country: lang['country']!,
                  onLanguageSelected: (String newLanguage) {
                    setState(() {
                      _selectedLanguage = newLanguage;
                    });
                    _setLocale(newLanguage);
                    _saveLanguage(newLanguage);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showLanguageBottomSheet(context),
      child: Text(
        tr('change_language'),
        style: GoogleFonts.prompt(
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
