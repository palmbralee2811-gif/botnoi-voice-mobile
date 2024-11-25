  // Function to show a bottom sheet for language selection
  import 'package:flutter/material.dart';
import 'package:path/path.dart';

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