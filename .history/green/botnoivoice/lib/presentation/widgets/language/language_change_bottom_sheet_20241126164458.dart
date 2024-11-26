import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:botnoivoice/presentation/widgets/language/language_change_bottom_sheet_function.dart'; // Your existing language bottom sheet function

class LanguageChangeBottomSheetLogin extends StatefulWidget {
  const LanguageChangeBottomSheetLogin({Key? key}) : super(key: key);

  @override
  _LanguageChangeBottomSheetLoginState createState() =>
      _LanguageChangeBottomSheetLoginState();
}

class _LanguageChangeBottomSheetLoginState
    extends State<LanguageChangeBottomSheetLogin> {
  String selectedLanguage = 'en'; // Default language is English
  String selectedLanguageImage = 'assets/images/national_flag/english.png'; // Default language flag
  bool isExpanded = false; // Track whether the bottom sheet is expanded

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = true;
        });

        // Show the language bottom sheet
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

        // Close the bottom sheet and reset the expanded state when it's closed
        Navigator.of(context).pop();
        setState(() {
          isExpanded = false;
        });
      },
      child: Container(
        width: 100.w,
        height: 35.h,
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
              width: 24.w,
              height: 24.h,
            ),
            SizedBox(width: 6.w),
            Text(
              selectedLanguage == 'th' ? 'ภาษาไทย' : 'English',
              style: GoogleFonts.prompt(fontSize: 16.sp),
            ),
            // Display the arrow icon indicating the expanded state
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_sharp
                  : Icons.keyboard_arrow_down_sharp,
              size: 20.sp,
              color: const Color(0xFF323130),
            ),
          ],
        ),
      ),
    );
  }
}
