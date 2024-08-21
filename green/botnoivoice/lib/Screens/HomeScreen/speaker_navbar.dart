import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SpeakerNavbar extends StatelessWidget {
  const SpeakerNavbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40.h,
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
                "เลือกเสียง",
                style: GoogleFonts.prompt(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF323130),
                ),
              ),
            ),
          ],
        )
    );
  }
}
