import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageChangeDropdown extends StatefulWidget {
  const LanguageChangeDropdown({Key? key}) : super(key: key);

  @override
  _LanguageChangeDropdownState createState() => _LanguageChangeDropdownState();
}

class _LanguageChangeDropdownState extends State<LanguageChangeDropdown> {
  String _selectedLanguage = 'th'; // Default language (Thai)

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Ensures no background
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10), // Add some padding
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.transparent), // Borderless
        ),
        child: DropdownButton<String>(
          value: _selectedLanguage,
          icon: Icon(Icons.keyboard_arrow_down), // Icon for dropdown
          underline: SizedBox(), // Remove the underline
          onChanged: (String? newValue) {
            setState(() {
              _selectedLanguage = newValue!;
            });

            // Change the app language using easy_localization
            if (newValue == 'th') {
              EasyLocalization.of(context)?.setLocale(Locale('th', 'TH'));
            } else if (newValue == 'en') {
              EasyLocalization.of(context)?.setLocale(Locale('en', 'US'));
            }
          },
          items: <String>['th', 'en'] // Thai and English options
              .map<DropdownMenuItem<String>>((String value) {
            String flagPath = value == 'th'
                ? 'assets/images/national_flag/thai.png' // Thai flag path
                : 'assets/images/national_flag/english.png'; // English flag path

            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Image.asset(
                    flagPath,
                    width: 24, // Adjust size as needed
                    height: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    value == 'th' ? 'ไทย' : 'English', // Language names
                    style: TextStyle(
                      color: Colors.black, // Text color
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
