import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
  import 'package:flutter/material.dart';

class LanguageChangeBottomSheet extends StatefulWidget {
  const LanguageChangeBottomSheet({super.key});

  @override
  State<LanguageChangeBottomSheet> createState() => _LanguageChangeBottomSheetState();
}

class _LanguageChangeBottomSheetState extends State<LanguageChangeBottomSheet> {
  String _selectedLanguage = 'th'; // Default language (Thai)

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
    .addPostFrameCallback((_) async => await _loadUserInfo());
}

  String _selectedLanguage = 'th'; // Default language (Thai)

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

  // Function to show a bottom sheet for language selection
void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context); 
                  },
                ),
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/national_flag/thai.png',
                  width: 24, // Flag size
                  height: 24,
                ),
                title: Text(
                  'ไทย',
                  style: GoogleFonts.prompt(
                    fontSize: 18.sp,
                    fontWeight: _selectedLanguage == 'th'
                        ? FontWeight.w600
                        : FontWeight
                            .w400, 
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'th';
                  });
                  context.setLocale(const Locale('th', 'TH'));
                  _saveLanguage('th');
                  Navigator.pop(
                      context);
                },
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/national_flag/english.png',
                  width: 24, 
                  height: 24,
                ),
                title: Text(
                  'English',
                  style: GoogleFonts.prompt(
                    fontSize: 18.sp,
                    fontWeight: _selectedLanguage == 'en'
                        ? FontWeight.w600
                        : FontWeight
                            .w400, 
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'en';
                  });
                  context.setLocale(const Locale('en', 'US'));
                  _saveLanguage('en');
                  Navigator.pop(
                      context); 
                },
              ),
            ],
          ),
        );
      },
    );
  }
}