import 'package:botnoivoice/service/email/email_change_username.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_text_align.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_text_button.dart';
import 'package:botnoivoice/ui/dialog/notification/notification_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Change Username for Email Account
class ChangeEmailUsernameScreen extends StatefulWidget {
  const ChangeEmailUsernameScreen({super.key});

  @override
  State<ChangeEmailUsernameScreen> createState() =>
      _ChangeEmailUsernameScreenState();
}

class _ChangeEmailUsernameScreenState extends State<ChangeEmailUsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmUsernameController =
      TextEditingController();

  bool isValidUsername(String username) {
    if (username.length < 3) return false;
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    return usernameRegex.hasMatch(username);
  }

  void submitUsernameChangeRequest() async {
    final changeUsername =
        Provider.of<EmailChangeUsername>(context, listen: false);

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await changeUsername.postChangeUsername(
          context, _usernameController.text);
      final errorMessage = changeUsername.errorMessage;

      if (errorMessage != null && errorMessage.isNotEmpty) {
        NotificationDialog(
          context: context,
          text: errorMessage,
        ).showErrorModal(context);
      } else {
        NotificationDialog(
          context: context,
          text: 'change_email_username.username_changed_successfully'
              .tr(), //ตั้งชื่อผู้ใช้งานใหม่สำเร็จ
          onPressed: () async {
            await Provider.of<EmailLogin>(context, listen: false)
                .signOutWithEmail(context);

            // Redirect to AuthChecker
            context.go('/auth');
          },
        ).showCheckmarkModalWithAction(context);
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          iconSize: ResponsiveDesignOrientation.isLandscape ? 12.sp : 16.sp,
          onPressed: () {
            // Redirect to Account Screen
            context.go('/account');
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40.h),
                  GradientTextAlign(
                    'change_email_username.change_username'
                        .tr(), //เปลี่ยนชื่อผู้ใช้
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
                  SizedBox(height: 8.h),
                  GradientTextAlign(
                    'change_email_username.set_new_username_for_login'
                        .tr(), //ตั้งชื่อผู้ใช้งานใหม่สำหรับใช้ในการเข้าสู่ระบบ
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9340FF),
                        Color(0xFF34BDFA),
                      ],
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveDesignOrientation.isLandscape
                          ? 10.sp
                          : 14.sp,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 32.h),
                  TextFormField(
                    controller: _usernameController,
                    style: TextStyle(
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 12.sp
                            : 16.sp,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      labelText: 'change_email_username.new_username'
                          .tr(), //ชื่อผู้ใช้งานใหม่
                      labelStyle: TextStyle(
                          fontSize: ResponsiveDesignOrientation.isLandscape
                              ? 12.sp
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
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'change_email_username.please_enter_your_username'
                            .tr(); //โปรดใส่ชื่อผู้ใช้งานของคุณ
                      }
                      if (!isValidUsername(value.trim())) {
                        return 'change_email_username.invalid_username'
                            .tr(); //ชื่อผู้ใช้งานไม่ถูกต้อง กรุณาใช้ตัวอักษร a-z, A-Z, ตัวเลข และเครื่องหมาย _ หรือ -
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _confirmUsernameController,
                    style: TextStyle(
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 12.sp
                            : 16.sp,
                        fontWeight: FontWeight.w400),
                    decoration: InputDecoration(
                      labelText: 'change_email_username.confirm_new_username'
                          .tr(), //ยืนยันชื่อผู้ใช้งานใหม่
                      labelStyle: TextStyle(
                          fontSize: ResponsiveDesignOrientation.isLandscape
                              ? 12.sp
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
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'change_email_username.please_confirm_your_username'
                            .tr(); //โปรดยืนยันชื่อผู้ใช้งานของคุณ
                      }
                      if (!isValidUsername(value.trim())) {
                        return 'change_email_username.invalid_username'
                            .tr(); //ชื่อผู้ใช้งานไม่ถูกต้อง กรุณาใช้ตัวอักษร a-z, A-Z, ตัวเลข และเครื่องหมาย _ หรือ -
                      }
                      if (value != _usernameController.text) {
                        return 'change_email_username.usernames_must_match'
                            .tr(); //ชื่อผู้ใช้งานทั้งสองช่องต้องตรงกัน
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  GradientTextButton(
                    text: 'change_email_username.confirm'.tr(), //ยืนยัน
                    onPressed: () {
                      submitUsernameChangeRequest();
                    },
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
