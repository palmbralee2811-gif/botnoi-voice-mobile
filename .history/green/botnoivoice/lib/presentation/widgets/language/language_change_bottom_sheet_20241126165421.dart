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
  bool changeIcon = false; // To track whether the arrow should be up or down

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Toggle the arrow state when the button is clicked
        setState(() {
          changeIcon = !changeIcon;
        });
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
        ).whenComplete(() {
          // Reset the icon to down after the bottom sheet is dismissed
          setState(() {
            changeIcon = false;
          });
        });
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
            // Toggle arrow direction based on `changeIcon`
            Icon(
              changeIcon
                  ? Icons.keyboard_arrow_up_sharp
                  : Icons.keyboard_arrow_down_sharp,
              size: 20.sp, // Responsive icon size
              color: const Color(0xFF323130),
            ),
          ],
        ),
      ),
    );
  }
  void showLanguageBottomSheet({
  required BuildContext context,
  required String selectedLanguage,
  required Function(String) onLanguageSelected,
}) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            color: Colors.transparent,
            width: 280.w,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'language'.tr(),
                      style: GoogleFonts.prompt(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 24.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                InkWell(
                  onTap: () {
                    onLanguageSelected('th');
                    context.setLocale(const Locale('th', 'TH'));
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10.w),
                    height: 42.h,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/national_flag/thai.png',
                          width: 23.w,
                          height: 23.h,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          'thai'.tr(),
                          style: GoogleFonts.prompt(
                            fontSize: 14.sp,
                            fontWeight: selectedLanguage == 'th'
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    onLanguageSelected('en');
                    context.setLocale(const Locale('en', 'US'));
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10.w),
                    height: 42.h,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/national_flag/english.png',
                          width: 23.w,
                          height: 23.h,
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          'english'.tr(),
                          style: GoogleFonts.prompt(
                            fontSize: 14.sp,
                            fontWeight: selectedLanguage == 'en'
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
      });
}
}
