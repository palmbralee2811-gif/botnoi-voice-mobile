import 'package:botnoivoice/presentation/widgets/language/language_change_bottom_sheet_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageChangeBottomSheetLogin extends StatefulWidget {
  const LanguageChangeBottomSheetLogin({Key? key}) : super(key: key);

  @override
  _LanguageChangeBottomSheetLoginState createState() =>
      _LanguageChangeBottomSheetLoginState();
}

class _LanguageChangeBottomSheetLoginState
    extends State<LanguageChangeBottomSheetLogin> {
  String selectedLanguage = 'en'; // Default language is English

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showLanguageBottomSheet(
          context: context,
          selectedLanguage: selectedLanguage,
          onLanguageSelected: (String languageCode) {
            setState(() {
              selectedLanguage = languageCode;
            });
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            // Language Flag (You can update the flag based on the selected language)
            Image.asset(
              selectedLanguage == 'th'
                  ? 'assets/images/national_flag/thai.png'
                  : 'assets/images/national_flag/english.png',
              width: 24,
              height: 24,
            ),
            SizedBox(width: 8),
            Text(
              selectedLanguage == 'th' ? 'ภาษาไทย' : 'English',
              style: GoogleFonts.prompt(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

