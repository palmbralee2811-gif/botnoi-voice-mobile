import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';


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

class BuildLanguageChange extends StatefulWidget {
  final String selectedGenderImage;
  final String gender;
  final String selectedGender;
  final bool changeIcon;

  BuildLanguageChange({
    required this.selectedGenderImage,
    required this.gender,
    required this.selectedGender,
    required this.changeIcon,
  });

  @override
  Widget buildlanguage(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          changeIcon = !changeIcon;
        });
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return SizedBox(
                  height: 220.h,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        buildGenderButton(context),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ).whenComplete(() {
          setState(() {
            changeIcon = false;
          });
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 3.w),
                SvgPicture.asset(
                  selectedGenderImage,
                  width: 28.w,
                  height: 28.h,
                ),
                SizedBox(width: 6.w),
                if (gender == '')
                  Text(
                    'ช/ญ',
                    style: GoogleFonts.prompt(
                      fontSize: 16.sp,
                    ),
                  ),
                if (gender.toString() != '')
                  Text(
                    selectedGender,
                    style: GoogleFonts.prompt(
                      fontSize: 12.sp,
                    ),
                  ),
                changeIcon
                    ? const Icon(
                        Icons.keyboard_arrow_up_sharp,
                        size: 20,
                        color: Color(0xFF323130),
                      )
                    : const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        size: 20,
                        color: Color(0xFF323130),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}