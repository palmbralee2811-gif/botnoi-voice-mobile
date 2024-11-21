import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:botnoivoice/main.dart'; // Assuming BotnoiVoiceApp is in main.dart

class LanguageChangeDropdown extends StatefulWidget {
  const LanguageChangeDropdown({Key? key}) : super(key: key);

  @override
  _LanguageChangeDropdownState createState() => _LanguageChangeDropdownState();
}

class _LanguageChangeDropdownState extends State<LanguageChangeDropdown> {
  String _selectedLanguage = 'th'; // Default language is Thai

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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Ensures no background
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10), // Add padding
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.transparent), // Borderless
        ),
        child: DropdownButton<String>(
          value: _selectedLanguage, // Display selected value
          icon: const Icon(Icons.keyboard_arrow_down), // Icon for dropdown
          underline: const SizedBox(), // Remove the underline
          onChanged: (String? newValue) {
            if (newValue == null) return;  // Ensure newValue is not null

            setState(() {
              _selectedLanguage = newValue; // Update selected value
            });

            // Change the language based on the selection
            if (newValue == 'th') {
              context.setLocale(const Locale('th', 'TH')); // Change to Thai
            } else if (newValue == 'en') {
              context.setLocale(const Locale('en', 'US')); // Change to English
            }

            // Save the selected language to SharedPreferences
            _saveLanguage(newValue);

            // Navigate and refresh the app to reflect the language change
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BotnoiVoiceApp()),
            );
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
                  const SizedBox(width: 8),
                  Text(
                    value == 'th' ? 'ไทย' : 'English', // Language names
                    style: const TextStyle(
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
