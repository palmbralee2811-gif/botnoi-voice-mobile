// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingAudioScreen extends StatelessWidget {
  const SettingAudioScreen({
    super.key,
    required this.screenSizeheight,
    required int selectedPageIndexSetting,
  }) : _selectedPageIndexSetting = selectedPageIndexSetting;

  final double screenSizeheight;
  final int _selectedPageIndexSetting;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: screenSizeheight * 0.05.h,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: const Color(0xFFE2E3E9),
              width: 1.w,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                "ตั้งค่าเพิ่มเติม",
                style: GoogleFonts.prompt(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF323130),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: _selectedPageIndexSetting == 1
                    ? Icon(
                        Icons.expand_less,
                        color: const Color(0xFF323130),
                        size: 20.sp,
                      )
                    : Icon(
                        Icons.expand_more,
                        color: const Color(0xFF323130),
                        size: 20.sp,
                      )),
          ],
        ));
  }
}
