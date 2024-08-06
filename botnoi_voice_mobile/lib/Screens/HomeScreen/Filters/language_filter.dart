import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageFilter extends StatefulWidget {
  const LanguageFilter({super.key});

  @override
  State<LanguageFilter> createState() => _LanguageFilterState();
}

class _LanguageFilterState extends State<LanguageFilter> {
  bool isExpanded = false;
  String selectedLanguage = 'ไทย';
  String selectedLanguageImage = 'assets/logo/Ellipse 12.jpg';
  String language = 'TH';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = true;
        });

        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  child: SingleChildScrollView(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                color: Colors.transparent,
                                width: 280.w,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'ภาษา',
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
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                    _buildLanguageOption(
                                        'Thai(Thailand) - ไทย',
                                        'assets/logo/Ellipse 12.jpg',
                                        'th',
                                        context,
                                        setState),
                                    _buildLanguageOption(
                                        'English (UK) - อังกฤษ',
                                        'assets/logo/Ellipse 13.jpg',
                                        'en',
                                        context,
                                        setState),
                                    _buildLanguageOption(
                                        'Indonesia - อินโดนีเซีย',
                                        'assets/logo/Ellipse 13 (2).jpg',
                                        'indo',
                                        context,
                                        setState),
                                    _buildLanguageOption(
                                        'Japanese - ญี่ปุ่น',
                                        'assets/logo/Ellipse 14.jpg',
                                        'jp',
                                        context,
                                        setState),
                                    _buildLanguageOption(
                                        'Laos - ลาว',
                                        'assets/logo/Ellipse 15.jpg',
                                        'loas',
                                        context,
                                        setState),
                                    _buildLanguageOption(
                                        'Myanmar - เมียนมาร์',
                                        'assets/logo/Ellipse 11.jpg',
                                        'mym',
                                        context,
                                        setState),
                                    _buildLanguageOption(
                                        'Vietnam - เวียดนาม',
                                        'assets/logo/Ellipse 19.jpg',
                                        'vn',
                                        context,
                                        setState),
                                    _buildLanguageOption(
                                        'Chinese (Simplified) - จีน',
                                        'assets/logo/Ellipse 18.jpg',
                                        'ch',
                                        context,
                                        setState),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ).whenComplete(() {
          setState(() {
            isExpanded = false;
          });
        });
      },
      child: Container(
        width: 67.w,
        height: 26.h,
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
              width: 14,
              height: 14,
            ),
            const SizedBox(
              width: 3,
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  selectedLanguage,
                  style: GoogleFonts.prompt(fontSize: 12.sp),
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

  Widget _buildLanguageOption(
    String text,
    String imagePath,
    String lang,
    BuildContext context,
    StateSetter setState,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedLanguage = text.split(' - ')[1];
          selectedLanguageImage = imagePath;
          language = lang; // Update the language variable
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10.w),
        height: 42.h,
        width: 320.w,
        color: const Color(0xFFFFFFFF),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  imagePath,
                  width: 23.w,
                  height: 23.h,
                ),
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  text,
                  style: GoogleFonts.prompt(
                    fontSize: 14.sp,
                    fontWeight: selectedLanguage == text.split(' - ')[1]
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
