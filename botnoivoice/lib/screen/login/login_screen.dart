import 'dart:io';
import 'package:botnoivoice/auth/internet_checker.dart';
import 'package:botnoivoice/shared/function/open_login_function.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/widget/button/apple_login_button.dart';
import 'package:botnoivoice/shared/widget/button/email_login_button.dart';
import 'package:botnoivoice/shared/widget/button/google_login_button.dart';
import 'package:botnoivoice/shared/widget/button/line_login_button.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final InternetChecker _internetChecker = InternetChecker();
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _internetChecker.startListeningToInternetChanges(context, (isAvailable) {
        logger.d("internet change in login : $isAvailable");
      });
    });
  }

  @override
  void dispose() {
    _internetChecker.cancelListener();
    super.dispose();
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
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 80.h : 127.h),
              _buildCenter(context),
              SizedBox(
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 75.h : 95.h),
              EmailLoginButton(
                onPressed: () {
                  openEmailLogin(context);
                },
              ),
              SizedBox(
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 10.h : 20.h),
              Padding(
                padding: EdgeInsets.only(
                    left: ResponsiveDesignOrientation.isLandscape ? 65.w : 30.w,
                    right:
                        ResponsiveDesignOrientation.isLandscape ? 65.w : 30.w),
                child: LineLoginButton(
                  onPressed: () {
                    openLineLogin(ref);
                  },
                ),
              ),
              SizedBox(
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 10.h : 20.h),
              Padding(
                padding: EdgeInsets.only(
                    left: ResponsiveDesignOrientation.isLandscape ? 65.w : 30.w,
                    right:
                        ResponsiveDesignOrientation.isLandscape ? 65.w : 30.w),
                child: GoogleLoginButton(
                  onPressed: () {
                    openGoogleLogin(ref);
                  },
                ),
              ),
              SizedBox(
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 10.h : 20.h),
              if (Platform.isIOS)
                Padding(
                  padding: EdgeInsets.only(
                      left:
                          ResponsiveDesignOrientation.isLandscape ? 65.w : 30.w,
                      right: ResponsiveDesignOrientation.isLandscape
                          ? 65.w
                          : 30.w),
                  child: AppleLoginButton(
                    onPressed: () {
                      openAppleLogin(ref);
                    },
                  ),
                ),
              SizedBox(
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 70.h : 40.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCenter(BuildContext context) {
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
                      width: ResponsiveDesignOrientation.isLandscape
                          ? 66.66.w
                          : 33.33.w,
                      height: ResponsiveDesignOrientation.isLandscape
                          ? 66.66.h
                          : 33.33.h,
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
                          fontSize: ResponsiveDesignOrientation.isLandscape
                              ? 15.sp
                              : 20.sp,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                ResponsiveDesignOrientation.isLandscape
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
