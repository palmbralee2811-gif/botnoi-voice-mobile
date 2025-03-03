import 'dart:async'; // สำหรับ StreamSubscription
import 'dart:io';
import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/screens/email/email_login_screen.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/button/apple_login_button.dart';
import 'package:botnoivoice/presentation/widgets/button/email_login_button.dart';
import 'package:botnoivoice/presentation/widgets/button/google_login_button.dart';
import 'package:botnoivoice/presentation/widgets/button/line_login_button.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_style.dart';
import 'package:botnoivoice/presentation/widgets/dialog/notification/notification_dialog.dart'; //สำหรับแสดง dialog
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'; // สำหรับเช็ค Internet

class LoginScreen extends StatefulWidget { // เปลี่ยนเป็น StatefulWidget
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late StreamSubscription<InternetStatus> _listener; // ตัวแปรสำหรับ StreamSubscription
  bool _isInternetAvailable = true; // ตัวแปรสำหรับเก็บสถานะ internet

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startListeningToInternetChanges(); // เรียกฟังก์ชันเริ่มฟังการเปลี่ยนแปลงของ Internet
    });
  }

  @override
  void dispose() {
    _listener.cancel(); // ยกเลิกการฟังเมื่อ widget ถูกทำลาย
    super.dispose();
  }

  void _startListeningToInternetChanges() {
    _listener = InternetConnection().onStatusChange.listen((status) {
      final isAvailable = status == InternetStatus.connected; // เช็คว่ามีการเชื่อมต่อ internet หรือไม่
      if (_isInternetAvailable != isAvailable) { // เช็คว่าสถานะ internet เปลี่ยนไปจากเดิมหรือไม่
        setState(() {
          _isInternetAvailable = isAvailable; // อัปเดตสถานะ internet
        });
        if (!_isInternetAvailable) { // ถ้าไม่มี internet
          NotificationDialog( // แสดง Notification Dialog
            context: context,
            text: 'No Internet Connection', // ข้อความแจ้งเตือน
          ).showErrorModal(context);//เเสดง Dialog เเบบ Error
        }
      }
    });
  }

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
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: OrientationHelper.isLandscape ? 80.h : 127.h),
              _buildCenter(context),
              SizedBox(height: OrientationHelper.isLandscape ? 75.h : 95.h),
              EmailLoginButton(onPressed: () {
                _openEmailLogin(context);
              }),
              SizedBox(height: OrientationHelper.isLandscape ? 10.h : 20.h),
              Padding(
                padding: EdgeInsets.only(
                    left: OrientationHelper.isLandscape ? 65.w : 30.w,
                    right: OrientationHelper.isLandscape ? 65.w : 30.w),
                child: LineLoginButton(onPressed: () {
                  _openLineLogin(context);
                }),
              ),
              SizedBox(height: OrientationHelper.isLandscape ? 10.h : 20.h),
              Padding(
                padding: EdgeInsets.only(
                    left: OrientationHelper.isLandscape ? 65.w : 30.w,
                    right: OrientationHelper.isLandscape ? 65.w : 30.w),
                child: GoogleLoginButton(onPressed: () {
                  _openGoogleLogin(context);
                }),
              ),
              SizedBox(height: OrientationHelper.isLandscape ? 10.h : 20.h),
              if (Platform.isIOS)
                Padding(
                  padding: EdgeInsets.only(
                      left: OrientationHelper.isLandscape ? 65.w : 30.w,
                      right: OrientationHelper.isLandscape ? 65.w : 30.w),
                  child: AppleLoginButton(onPressed: () {
                    _openAppleLogin(context);
                  }),
                ),
              SizedBox(height: OrientationHelper.isLandscape ? 70.h : 40.h),
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
                      width: OrientationHelper.isLandscape ? 66.66.w : 33.33.w,
                      height: OrientationHelper.isLandscape ? 66.66.h : 33.33.h,
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
                          fontSize: OrientationHelper.isLandscape ? 15.sp : 20.sp,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                OrientationHelper.isLandscape
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
