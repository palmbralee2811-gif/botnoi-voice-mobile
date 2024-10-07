import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LineLoginButton extends StatelessWidget {
  const LineLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: ElevatedButton(
              onPressed: () {
                // /* When Sign in with LINE is Successfuly and close Email Login Screen */
                Provider.of<LineLoginProvider>(context, listen: false)
                    .signInWithLine()
                    .whenComplete(() {
                  Navigator.pop(context);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3ACE01),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.zero,
                minimumSize: Size(256.w, 44.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/auth_screen/line-512x512.png',
                    height: 36.h,
                    width: 36.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'เข้าสู่ระบบด้วย LINE',
                    style: GoogleFonts.prompt(
                      fontSize: 12.sp,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
