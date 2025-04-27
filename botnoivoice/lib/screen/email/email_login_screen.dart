import 'dart:io';
import 'package:botnoivoice/screen/appbar/appbar_template.dart';
import 'package:botnoivoice/shared/function/open_login_function.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/widget/button/apple_login_button.dart';
import 'package:botnoivoice/shared/widget/button/google_login_button.dart';
import 'package:botnoivoice/shared/widget/button/line_login_button.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_popup.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text_align.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text_button.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailOrUsernameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  /// Login with Username and Password
  void _loginUser() async {
    final emailLoginProvider = context.read<EmailLogin>();

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_emailOrUsernameController.text.contains('@')) {
          await emailLoginProvider.loginWithEmailPassword(
            _emailOrUsernameController.text.trim(),
            _passwordController.text.trim(),
          );
        } else {
          await emailLoginProvider.loginWithUsernamePassword(
            _emailOrUsernameController.text.trim(),
            _passwordController.text.trim(),
            context,
          );
        }

        // แสดงผลข้อผิดพลาด ถ้ามี
        final errorMessage = emailLoginProvider.errorMessage;
        if (errorMessage != null && errorMessage.isNotEmpty) {
          NotificationDialog(
            context: context,
            text: errorMessage,
          ).showErrorModal(context);
        } else {
          // Redirect to AuthChecker
          context.go('/auth');
        }
      } catch (error) {
        NotificationPopup(
          context: context,
          text:
              '${'sign_in.error_occurred'.tr()} $error', //เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง.
        ).showAsError();
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarTemplate(
        onPressed: () {
          // Redirect to LoginScreen
          context.go('/login');
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: ResponsiveDesignOrientation.isLandscape ? 38.w : 24.w,
                    right:
                        ResponsiveDesignOrientation.isLandscape ? 38.w : 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientTextAlign(
                        'auth.sign_in'.tr(), //เข้าสู่ระบบ
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9340FF),
                            Color(0xFF34BDFA),
                          ],
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveDesignOrientation.isLandscape
                              ? 16.sp
                              : 20.sp,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                          height: ResponsiveDesignOrientation.isLandscape
                              ? 4.h
                              : 8.h),
                      GradientTextAlign(
                        'sign_in.welcome_message'
                            .tr(), //สวัสดี, Botnoi Voice ยินดีต้อนรับ
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9340FF),
                            Color(0xFF34BDFA),
                          ],
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveDesignOrientation.isLandscape
                              ? 12.sp
                              : 14.sp,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                          height: ResponsiveDesignOrientation.isLandscape
                              ? 22.h
                              : 32.h),
                      TextFormField(
                        controller: _emailOrUsernameController,
                        style: TextStyle(
                            fontSize: ResponsiveDesignOrientation.isLandscape
                                ? 11.sp
                                : 16.sp,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          labelText: 'sign_in.username_or_email'
                              .tr(), //ชื่อผู้ใช้งานหรืออีเมล
                          labelStyle: TextStyle(
                              fontSize: ResponsiveDesignOrientation.isLandscape
                                  ? 11.sp
                                  : 16.sp,
                              fontWeight: FontWeight.w400),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: TextStyle(
                              fontSize: ResponsiveDesignOrientation.isLandscape
                                  ? 10.sp
                                  : 14.sp),
                          errorMaxLines: 5,
                          suffixIcon: IconButton(
                            icon: Icon(
                              null,
                              size: ResponsiveDesignOrientation.isLandscape
                                  ? 16.w
                                  : 24.w,
                            ),
                            onPressed: null,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'sign_in.please_enter_username_or_email'
                                .tr(); //โปรดใส่ชื่อผู้ใช้งานหรืออีเมลของคุณ
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                          height: ResponsiveDesignOrientation.isLandscape
                              ? 14.h
                              : 16.h),
                      TextFormField(
                        controller: _passwordController,
                        style: TextStyle(
                            fontSize: ResponsiveDesignOrientation.isLandscape
                                ? 11.sp
                                : 16.sp,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          labelText: 'sign_in.password'.tr(), //รหัสผ่าน
                          labelStyle: TextStyle(
                              fontSize: ResponsiveDesignOrientation.isLandscape
                                  ? 11.sp
                                  : 16.sp,
                              fontWeight: FontWeight.w400),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: TextStyle(
                              fontSize: ResponsiveDesignOrientation.isLandscape
                                  ? 10.sp
                                  : 14.sp),
                          errorMaxLines: 5,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: ResponsiveDesignOrientation.isLandscape
                                  ? 16.w
                                  : 24.w, // Adjust icon size
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) => value!.isEmpty
                            ? 'sign_in.please_enter_password'.tr()
                            : null, //โปรดใส่รหัสผ่านของคุณ
                      ),
                      SizedBox(
                          height: ResponsiveDesignOrientation.isLandscape
                              ? 14.h
                              : 12.h),
                      _isLoading
                          ? const Center(
                              child:
                                  CircularProgressIndicator()) // แสดงสถานะการโหลด
                          : GradientTextButton(
                              text: 'auth.sign_in'.tr(),
                              onPressed: _loginUser,
                            ),
                      SizedBox(
                          height: ResponsiveDesignOrientation.isLandscape
                              ? 14.h
                              : 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // จัดตำแหน่งปุ่มในแนวนอน
                        children: [
                          TextButton(
                            onPressed: () {
                              // Redirect to RegisterScreen
                              context.go('/register');
                            },
                            child: Text(
                              'sign_in.register'.tr(), //สมัครใช้งาน
                              style: TextStyle(
                                fontSize:
                                    ResponsiveDesignOrientation.isLandscape
                                        ? 9.sp
                                        : 14.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Redirect to ForgetPasswordScreen
                              context.go('/forget-password');
                            },
                            child: Text(
                              'sign_in.forgot_password'.tr(), //ลืมรหัสผ่าน?
                              style: TextStyle(
                                fontSize:
                                    ResponsiveDesignOrientation.isLandscape
                                        ? 9.sp
                                        : 14.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: ResponsiveDesignOrientation.isLandscape
                              ? 13.h
                              : 16.h),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 1.0,
                              color: Color(0xFF34BDFA),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              'sign_in.or'.tr(), //หรือ
                              style: TextStyle(
                                  fontSize:
                                      ResponsiveDesignOrientation.isLandscape
                                          ? 9.sp
                                          : 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              thickness: 1.0,
                              color: Color(0xFF34BDFA),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: ResponsiveDesignOrientation.isLandscape
                              ? 14.h
                              : 16.h),
                      Padding(
                        padding: EdgeInsets.only(
                            left: ResponsiveDesignOrientation.isLandscape
                                ? 40.w
                                : 15.w,
                            right: ResponsiveDesignOrientation.isLandscape
                                ? 40.w
                                : 15.w),
                        child: LineLoginButton(
                          onPressed: () {
                            openLineLogin(context);
                          },
                        ),
                      ),
                      SizedBox(
                          height: ResponsiveDesignOrientation.isLandscape
                              ? 14.h
                              : 16.h),
                      Padding(
                        padding: EdgeInsets.only(
                            left: ResponsiveDesignOrientation.isLandscape
                                ? 40.w
                                : 15.w,
                            right: ResponsiveDesignOrientation.isLandscape
                                ? 40.w
                                : 15.w),
                        child: GoogleLoginButton(
                          onPressed: () {
                            openGoogleLogin(context);
                          },
                        ),
                      ),
                      SizedBox(
                          height: ResponsiveDesignOrientation.isLandscape
                              ? 14.h
                              : 16.h),
                      if (Platform.isIOS)
                        Padding(
                          padding: EdgeInsets.only(
                              left: ResponsiveDesignOrientation.isLandscape
                                  ? 40.w
                                  : 15.w,
                              right: ResponsiveDesignOrientation.isLandscape
                                  ? 40.w
                                  : 15.w),
                          child: AppleLoginButton(
                            onPressed: () {
                              openAppleLogin(context);
                            },
                          ),
                        ),
                      SizedBox(
                          height: ResponsiveDesignOrientation.isLandscape
                              ? 100.h
                              : 140.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
