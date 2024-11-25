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
    _loadLanguage(); // Load saved language when the widget initializes
  }

  // Load saved language from SharedPreferences
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

  // Save selected language to SharedPreferences
  Future<void> _saveLanguage(String language) async {
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
                    fontSize: 18, // Adjust size to match your layout
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
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  'English',
                  style: GoogleFonts.prompt(
                    fontSize: 18, // Adjust size to match your layout
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
    return InkWell(
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return SizedBox(
                  height: 220.h,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        buildGenderButton(context),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        )
    );
    )

  // buildGenderButton: แสดง Modal สำหรับเลือกเพศ พร้อมรายการตัวเลือกของเพศที่รองรับ
  Widget buildGenderButton(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 280.w,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'เพศ',
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
          SizedBox(
            height: 15.h,
          ),
          _buildGenderFilter(
              'ช/ญ', 'assets/images/gender/all.svg', '', context, setState),
          _buildGenderFilter('หญิง', 'assets/images/gender/woman.svg',
              'ผู้หญิง', context, setState),
          _buildGenderFilter('ชาย', 'assets/images/gender/man.svg', 'ผู้ชาย',
              context, setState)
        ],
      ),
    );
  }
}