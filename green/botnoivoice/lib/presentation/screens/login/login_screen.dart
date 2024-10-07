import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/screens/email/email_login_screen.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 167.h),
          _buildCenter(),
          SizedBox(height: 120.h),
          _buildEmailLoginButton(context),
          SizedBox(height: 20.h),
          _buildLineLoginButton(context),
          SizedBox(height: 20.h),
          _buildGoogleLoginButton(context),
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

  Widget _buildEmailLoginButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmailLoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                padding: EdgeInsets.zero,
                minimumSize: Size(256.w, 44.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/auth_screen/email-512x512.png',
                    height: 32.h,
                    width: 32.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'เข้าสู่ระบบด้วย Email',
                    style: GoogleFonts.prompt(
                      fontSize: 12.sp,
                      color: Colors.black,
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

  Widget _buildLineLoginButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: ElevatedButton(
              onPressed: () {
                Provider.of<LineLoginProvider>(context, listen: false)
                    .signInWithLine();
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

  Widget _buildGoogleLoginButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: ElevatedButton(
              onPressed: () {
                //TODO: Check on production if don't login show alert notification
                Provider.of<GoogleLoginProvider>(context, listen: false)
                    .signInWithGoogle();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                padding: EdgeInsets.zero,
                minimumSize: Size(256.w, 44.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/auth_screen/google-512x512.png',
                    height: 32.h,
                    width: 32.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'เข้าสู่ระบบด้วย Google',
                    style: GoogleFonts.prompt(
                      fontSize: 12.sp,
                      color: Colors.black,
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
