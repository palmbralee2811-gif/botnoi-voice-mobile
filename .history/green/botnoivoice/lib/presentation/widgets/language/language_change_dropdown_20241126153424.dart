import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // Get screen size for responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define responsive padding and font size
    double padding = screenWidth * 0.05; // 5% of screen width
    double fontSize = screenWidth * 0.04; // Font size relative to screen width

    return Material(
      color: Colors.transparent, // Ensures no background
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: padding), // Responsive padding
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.transparent), // Borderless
        ),
        child: DropdownButton<String>(
          value: _selectedLanguage, // Display selected value
          icon: const Icon(Icons.keyboard_arrow_down), // Icon for dropdown
          underline: const SizedBox(), // Remove the underline
          onChanged: (String? newValue) {
            if (newValue == null) return; // Ensure newValue is not null

            setState(() {
              _selectedLanguage = newValue; // Update selected language
            });

            // Change the language based on the selection
            if (newValue == 'th') {
              context.setLocale(const Locale('th', 'TH')); // Change to Thai
            } else if (newValue == 'en') {
              context.setLocale(const Locale('en', 'US')); // Change to English
            }

            // Save the selected language (optional, like using SharedPreferences)
            // _saveLanguage(newValue);

            // Optionally refresh or navigate to another screen after language change
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const BotnoiVoiceApp()),
            // );
          },
          items: _languageOptions.map<DropdownMenuItem<String>>((Map<String, String> language) {
            return DropdownMenuItem<String>(
              value: language['language'],
              child: Row(
                children: [
                  // Flag icon (responsive size)
                  Image.asset(
                    language['icon']!,
                    width: screenWidth * 0.1, // Responsive icon size (10% of screen width)
                    height: screenHeight * 0.05, // Responsive height
                  ),
                  SizedBox(width: screenWidth * 0.02), // Responsive space between icon and text
                  Text(
                    language['label']!,
                    style: GoogleFonts.prompt(
                      color: Colors.black,
                      fontSize: fontSize, // Responsive font size
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
