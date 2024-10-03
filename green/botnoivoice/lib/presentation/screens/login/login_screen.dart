import 'package:botnoivoice/presentation/screens/login/email_login_button.dart';
import 'package:botnoivoice/presentation/screens/login/google_login_button.dart';
import 'package:botnoivoice/presentation/screens/login/line_login_button.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: 320.w,
            height: 684.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFB1E9FD),
                  Color(0xFFF9D8FD),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/auth_screen/background.png',
              width: 320.w,
              height: 684.h,
              fit: BoxFit.cover,
            ),
          ),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 167.h),
          _buildCenter(),
          SizedBox(height: 120.h),
          const EmailLoginButton(),
          SizedBox(height: 20.h),
          const LineLoginButton(),
          SizedBox(height: 20.h),
          const GoogleLoginButton(),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }

  Widget _buildCenter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: SizedBox(
            width: 320.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    SizedBox(width: 20.w),
                    SvgPicture.asset(
                      'assets/images/icon/play-on.svg',
                      width: 33.33.w,
                      height: 33.33.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, bottom: 10.h),
                      child: GradientTextStyle(
                        'เปลี่ยนข้อความเป็นเสียง',
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9340FF),
                            Color(0xFF34BDFA),
                          ],
                        ),
                        style: GoogleFonts.prompt(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    bottom: 13.h,
                  ),
                  child: GradientTextStyle(
                    'บอทน้อย',
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9340FF),
                        Color(0xFF34BDFA),
                      ],
                    ),
                    style: GoogleFonts.prompt(
                      fontWeight: FontWeight.bold,
                      fontSize: 56.sp,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: GradientTextStyle(
                    'ว้อยส์',
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9340FF),
                        Color(0xFF34BDFA),
                      ],
                    ),
                    style: GoogleFonts.prompt(
                      fontWeight: FontWeight.bold,
                      fontSize: 48.sp,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
