import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageSelectingDrawer extends StatefulWidget {
  const LanguageSelectingDrawer({super.key});

  @override
  State<LanguageSelectingDrawer> createState() => _LanguageSelectingDrawerState();
}

class _LanguageSelectingDrawerState extends State<LanguageSelectingDrawer> {
  String selectedLanguage = 'ไทย'; 

  void _selectLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Green: ถ้าใช้ GestureDetector แทน InkWell เวลาคลิกที่ช่องว่าง SizedBox จะไม่แสดง showModalBottomSheet
    return InkWell( 
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) => SizedBox(
            height: 170.h,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.transparent,
                        width: 280.w,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            InkWell(
                              onTap: () {
                                _selectLanguage('ไทย');
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10.w),
                                height: 42.h,
                                width: 320.w,
                                color: selectedLanguage == 'ไทย'
                                    ? const Color(0xFFF7F8FA)
                                    : Colors.white, 
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/logo/Ellipse 12.jpg',
                                          width: 23.w,
                                          height: 23.h,
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Text(
                                          'Thai (Thailand) - ไทย',
                                          style: GoogleFonts.prompt(
                                            fontSize: 14.sp,
                                            fontWeight: selectedLanguage == 'ไทย'
                                              ? FontWeight.w600
                                              : FontWeight.normal
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _selectLanguage('อังกฤษ');
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10.w),
                                height: 42.h,
                                width: 320.w,
                                color: selectedLanguage == 'อังกฤษ'
                                    ? const Color(0xFFF7F8FA)
                                    : Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/logo/Ellipse 13.jpg',
                                          width: 23.w,
                                          height: 23.h,
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Text(
                                          'English (UK) - อังกฤษ',
                                          style: GoogleFonts.prompt(
                                            fontSize: 14.sp,
                                            fontWeight: selectedLanguage == 'อังกฤษ'
                                              ? FontWeight.w600
                                              : FontWeight.normal
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
      child: SizedBox(
        width: 62.w,
        height: 40.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  selectedLanguage == 'ไทย'
                      ? 'assets/logo/Ellipse 12.jpg'
                      : 'assets/logo/Ellipse 13.jpg',
                  width: 24.w,
                  height: 24.w,
                ),
                SizedBox(width: 10.w),
                Text(
                  selectedLanguage,
                  style: GoogleFonts.prompt(
                      fontSize: 20.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 80.w),
                Icon(
                  Icons.keyboard_arrow_down_sharp,
                  size: 24.sp,
                  color: const Color(0xFF323130),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
