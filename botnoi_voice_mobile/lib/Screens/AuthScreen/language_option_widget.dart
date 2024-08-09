import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageOptionWidget extends StatelessWidget {
  const LanguageOptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.all(20.r),
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
                            Container(
                              padding: EdgeInsets.only(left: 10.w),
                              height: 42.h,
                              width: 320.w,
                              color: const Color(0xFFF7F8FA),
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
                                          'ไทย',
                                          style: GoogleFonts.prompt(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10.w),
                              height: 42.h,
                              width: 320.w,
                              color: const Color(0xFFFFFFFF),
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
                                          'อังกฤษ',
                                          style: GoogleFonts.prompt(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
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
        width: 320.w, //62
        height: 40.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/AuthScreenIcon/flag-thai.png',
                  width: 24.w,
                  height: 24.w,
                ),
                SizedBox(width: 10.w),
                Text(
                  'ไทย',
                  style: GoogleFonts.prompt(
                      fontSize: 20.sp, fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
