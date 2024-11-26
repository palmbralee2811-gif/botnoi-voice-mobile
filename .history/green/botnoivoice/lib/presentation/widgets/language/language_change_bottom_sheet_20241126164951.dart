import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:botnoivoice/presentation/widgets/language/language_change_bottom_sheet_function.dart'; // Your language selection function

class LanguageChangeBottomSheetLogin extends StatefulWidget {
  const LanguageChangeBottomSheetLogin({Key? key}) : super(key: key);

  @override
  _LanguageChangeBottomSheetLoginState createState() =>
      _LanguageChangeBottomSheetLoginState();
}

class _LanguageChangeBottomSheetLoginState
    extends State<LanguageChangeBottomSheetLogin> {
  String selectedLanguage = 'en'; // Default language is English
  String selectedLanguageImage = 'assets/images/national_flag/english.png'; // Default flag for English

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Show the bottom sheet when tapped
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
      },
      child: Container(
        width: 100.w, // Responsive width using ScreenUtil
        height: 35.h, // Responsive height using ScreenUtil
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFE2E3E9), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the selected language flag
            Image.asset(
              selectedLanguageImage,
              width: 28.w, // Responsive width
              height: 28.h, // Responsive height
            ),
            SizedBox(width: 6.w),
            // Display the language text (Thai or English)
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  selectedLanguage == 'th' ? 'ภาษาไทย' : 'English',
                  style: GoogleFonts.prompt(fontSize: 16.sp),
                ),
              ),
            ),
            // Display the arrow icon (down)
            Icon(
              Icons.keyboard_arrow_down_sharp,
              size: 20.sp, // Responsive icon size
              color: const Color(0xFF323130),
            ),
          ],
        ),
      ),
    );
  }
}
