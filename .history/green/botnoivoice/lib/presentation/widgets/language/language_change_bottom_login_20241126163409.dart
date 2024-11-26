import 'package:botnoivoice/presentation/widgets/language/language_change_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageChangeBottomSheetLogin extends StatelessWidget {
  const LanguageChangeBottomSheetLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assume selectedLanguage is something like 'en' initially
    String selectedLanguage = 'en'; 

    return InkWell(
      onTap: () {
        // Call the showLanguageBottomSheet function when the user taps
        showLanguageBottomSheet(
          context: context,
          selectedLanguage: selectedLanguage,
          onLanguageSelected: (String languageCode) {
            // Update the selected language here
            selectedLanguage = languageCode;
          },
        );
      },
      child: Icon(
        Icons.language,
        size: 30.sp, // Adjust size as needed
        color: Colors.black, // Change color if needed
      ),
    );
  }
}
