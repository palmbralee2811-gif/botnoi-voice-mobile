import 'package:botnoivoice/presentation/widgets/language/language_change_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
// Language Change Button with Arrow
class LanguageChangeBottomSheetLogin extends StatefulWidget {
  const LanguageChangeBottomSheetLogin({Key? key}) : super(key: key);

  @override
  _LanguageChangeBottomSheetLoginState createState() =>
      _LanguageChangeBottomSheetLoginState();
}

class _LanguageChangeBottomSheetLoginState
    extends State<LanguageChangeBottomSheetLogin> {
  String selectedLanguage = 'en'; // Default to English
  String selectedLanguageImage = 'assets/images/national_flag/english.png'; // Default flag
  bool isExpanded = false; // For arrow state (up or down)

  // Function to show the language bottom sheet
  void showLanguageBottomSheetWithState(
      BuildContext context, String selectedLanguage) {
    showLanguageBottomSheet(
      context: context,
      selectedLanguage: selectedLanguage,
      onLanguageSelected: (String languageCode) {
        setState(() {
          selectedLanguage = languageCode;
          selectedLanguageImage = languageCode == 'th'
              ? 'assets/images/national_flag/thai.png'
              : 'assets/images/national_flag/english.png';
        });
      },
    );
  }

  // Language selection button
  Widget showLanguageBottomSheet(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = true;
        });

        // Trigger the bottom sheet
        showLanguageBottomSheetWithState(context, selectedLanguage);

        // Reset the expanded state when the bottom sheet is closed
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
            // Show the current language flag
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
                  selectedLanguage == 'th' ? 'ภาษาไทย' : 'English', // Language name
                  style: GoogleFonts.prompt(fontSize: 16.sp),
                ),
              ),
            ),
            // Arrow icon to indicate whether it's expanded or not
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
    return showLanguageBottomSheet(context); // Return the language selection button
  }
}

