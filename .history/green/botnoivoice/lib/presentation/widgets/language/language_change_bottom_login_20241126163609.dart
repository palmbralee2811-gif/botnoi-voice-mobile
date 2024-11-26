import 'package:flutter/material.dart';

class LanguageChangeBottomSheetLogin extends StatefulWidget {
  const LanguageChangeBottomSheetLogin({Key? key}) : super(key: key);

  @override
  _LanguageChangeBottomSheetLoginState createState() =>
      _LanguageChangeBottomSheetLoginState();
}

class _LanguageChangeBottomSheetLoginState
    extends State<LanguageChangeBottomSheetLogin> {
  // Track selected language and its flag image
  String selectedLanguage = 'en'; // Default language is 'English'
  String selectedLanguageImage = 'assets/images/national_flag/english.png';
  bool isExpanded = false; // For the arrow direction in the button

  // Method to trigger the language bottom sheet
  void showLanguageBottomSheetWithState(
      BuildContext context, String selectedLanguage) {
    showLanguageBottomSheet(
      context: context,
      selectedLanguage: selectedLanguage,
      onLanguageSelected: (String languageCode) {
        setState(() {
          // Update selected language and flag image
          selectedLanguage = languageCode;
          selectedLanguageImage = languageCode == 'th'
              ? 'assets/images/national_flag/thai.png'
              : 'assets/images/national_flag/english.png';
        });
      },
    );
  }

  // The button that will trigger the bottom sheet
  Widget buildLanguageButtonTrigger(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = true;
        });

        // Show language selection bottom sheet
        showLanguageBottomSheetWithState(context, selectedLanguage);

        // Reset the expanded state when bottom sheet is dismissed
        Navigator.of(context).pop();
        setState(() {
          isExpanded = false;
        });
      },
      child: Container(
        width: 100.w,
        height: 35.h,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
          border: Border.all(
            color: const Color(0xFFE2E3E9),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              selectedLanguageImage,
              width: 28.w,
              height: 28.h,
            ),
            SizedBox(width: 6.w),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  selectedLanguage == 'th' ? 'ไทย' : 'English', // Localized text
                  style: GoogleFonts.prompt(fontSize: 16.sp),
                ),
              ),
            ),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_sharp
                  : Icons.keyboard_arrow_down_sharp,
              size: 20,
              color: const Color(0xFF323130),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildLanguageButtonTrigger(context); // Return the language button widget
  }
}
