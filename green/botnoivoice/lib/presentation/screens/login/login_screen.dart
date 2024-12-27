import 'dart:io';

import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/screens/email/email_login_screen.dart';
import 'package:botnoivoice/presentation/widgets/button/apple_login_button.dart';
import 'package:botnoivoice/presentation/widgets/button/email_login_button.dart';
import 'package:botnoivoice/presentation/widgets/button/google_login_button.dart';
import 'package:botnoivoice/presentation/widgets/button/line_login_button.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _openEmailLogin(context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const EmailLoginScreen()));
  }

  void _openLineLogin(context) async {
    Provider.of<LineLoginProvider>(context, listen: false).signInWithLine();
  }

  void _openGoogleLogin(context) async {
    Provider.of<GoogleLoginProvider>(context, listen: false).signInWithGoogle();
  }

  void _openAppleLogin(context) async {
    Provider.of<AppleLoginProvider>(context, listen: false).signInWithApple();
  }

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
    final orientation =
        MediaQuery.of(context).orientation; // ตรวจสอบ orientation
    final isLandscape = orientation == Orientation.landscape;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isLandscape ? 30.h : 127.h),
              _buildCenter(context),
              SizedBox(height: isLandscape ? 75.h : 95.h),
              EmailLoginButton(onPressed: () {
                _openEmailLogin(context);
              }),
              SizedBox(height: isLandscape ? 10.h : 20.h),
              Padding(
                padding: EdgeInsets.only(
                    left: isLandscape ? 65.w : 30.w,
                    right: isLandscape ? 65.w : 30.w),
                child: LineLoginButton(onPressed: () {
                  _openLineLogin(context);
                }),
              ),
              SizedBox(height: isLandscape ? 10.h : 20.h),
              Padding(
                padding: EdgeInsets.only(
                    left: isLandscape ? 65.w : 30.w,
                    right: isLandscape ? 65.w : 30.w),
                child: GoogleLoginButton(onPressed: () {
                  _openGoogleLogin(context);
                }),
              ),
              SizedBox(height: isLandscape ? 10.h : 20.h),
              if (Platform.isIOS)
                Padding(
                  padding: EdgeInsets.only(
                      left: isLandscape ? 65.w : 30.w,
                      right: isLandscape ? 65.w : 30.w),
                  child: AppleLoginButton(onPressed: () {
                    _openAppleLogin(context);
                  }),
                ),
              SizedBox(height: isLandscape ? 15.h : 40.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCenter(BuildContext context) {
    final orientation =
        MediaQuery.of(context).orientation; // ตรวจสอบ orientation
    final isLandscape = orientation == Orientation.landscape;
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
                      width: isLandscape ? 66.66.w : 33.33.w,
                      height: isLandscape ? 66.66.h : 33.33.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, bottom: 10.h),
                      child: GradientTextStyle(
                        'welcome_message.line1'.tr(), //เปลี่ยนข้อความเป็นเสียง
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9340FF),
                            Color(0xFF34BDFA),
                          ],
                        ),
                        style: GoogleFonts.prompt(
                          fontWeight: FontWeight.w500,
                          fontSize: isLandscape ? 15.sp : 20.sp,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     left: 20.w,
                //     bottom: 13.h,
                //   ),
                //   child: GradientTextStyle(
                //     'welcome_message.line2'.tr(), //บอทน้อย
                //     gradient: const LinearGradient(
                //       colors: [
                //         Color(0xFF9340FF),
                //         Color(0xFF34BDFA),
                //       ],
                //     ),
                //     style: GoogleFonts.prompt(
                //       fontWeight: FontWeight.bold,
                //       fontSize: isLandscape ? 32.sp : 56.sp,
                //       decoration: TextDecoration.none,
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(left: isLandscape ? 20.sp : 20.w),
                //   child: GradientTextStyle(
                //     'welcome_message.line3'.tr(), //ว้อยส์
                //     gradient: const LinearGradient(
                //       colors: [
                //         Color(0xFF9340FF),
                //         Color(0xFF34BDFA),
                //       ],
                //     ),
                //     style: GoogleFonts.prompt(
                //       fontWeight: FontWeight.bold,
                //       fontSize: isLandscape ? 28.sp : 48.sp,
                //       decoration: TextDecoration.none,
                //     ),
                //   ),
                // ),
                isLandscape
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.w,
                              // bottom: 13.h,
                            ),
                            child: GradientTextStyle(
                              'welcome_message.line2'.tr(), // บอทน้อย
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF9340FF),
                                  Color(0xFF34BDFA),
                                ],
                              ),
                              style: GoogleFonts.prompt(
                                fontWeight: FontWeight.bold,
                                fontSize: 32.sp, // ขนาดตัวอักษรเมื่อเป็นแนวนอน
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.w), // ระยะห่างระหว่างข้อความ
                            child: GradientTextStyle(
                              'welcome_message.line3'.tr(), // ว้อยส์
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF9340FF),
                                  Color(0xFF34BDFA),
                                ],
                              ),
                              style: GoogleFonts.prompt(
                                fontWeight: FontWeight.bold,
                                fontSize: 32.sp, // ขนาดตัวอักษรเมื่อเป็นแนวนอน
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.w,
                              bottom: 13.h,
                            ),
                            child: GradientTextStyle(
                              'welcome_message.line2'.tr(), // บอทน้อย
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF9340FF),
                                  Color(0xFF34BDFA),
                                ],
                              ),
                              style: GoogleFonts.prompt(
                                fontWeight: FontWeight.bold,
                                fontSize: 56.sp, // ขนาดตัวอักษรเมื่อเป็นแนวตั้ง
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: GradientTextStyle(
                              'welcome_message.line3'.tr(), // ว้อยส์
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF9340FF),
                                  Color(0xFF34BDFA),
                                ],
                              ),
                              style: GoogleFonts.prompt(
                                fontWeight: FontWeight.bold,
                                fontSize: 48.sp, // ขนาดตัวอักษรเมื่อเป็นแนวตั้ง
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
