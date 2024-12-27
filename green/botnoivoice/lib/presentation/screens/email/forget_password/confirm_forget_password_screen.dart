import 'package:botnoivoice/presentation/screens/email/forget_password/new_password_screen.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/dialog/notification_dialog.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_align.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

class ConfirmForgetPasswordScreen extends StatefulWidget {
  const ConfirmForgetPasswordScreen({super.key});

  @override
  State<ConfirmForgetPasswordScreen> createState() =>
      _ConfirmForgetPasswordScreenState();
}

class _ConfirmForgetPasswordScreenState
    extends State<ConfirmForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final Logger _logger = Logger(); // For debugging

  // นำฟังก์ชันจากไฟล์ 2 มาใช้
  String _extractCodeFromLink(String link) {
    try {
      Uri uri = Uri.parse(link);
      return uri.queryParameters['oobCode'] ?? '';
    } catch (e) {
      _logger.e("Error parsing reset link: $e");
      return '';
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
          iconSize: OrientationHelper.isLandscape ? 10.sp : 16.sp,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all( OrientationHelper.isLandscape ? 20.w : 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                GradientTextAlign(
                  'confirm_forget_password.check_your_email'.tr(),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9340FF),
                      Color(0xFF34BDFA),
                    ],
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: OrientationHelper.isLandscape ? 14.sp : 20.sp,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 8.h),
                GradientTextAlign(
                  'confirm_forget_password.copy_link_from_your_inbox'.tr(),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9340FF),
                      Color(0xFF34BDFA),
                    ],
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 32.h),
                TextFormField(
                  controller: _codeController,
                  style:
                      TextStyle(fontSize: OrientationHelper.isLandscape ? 11.sp : 16.sp, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    labelText: 'confirm_forget_password.link'.tr(),
                    labelStyle:
                        TextStyle(fontSize: OrientationHelper.isLandscape ? 11.sp : 16.sp, fontWeight: FontWeight.w400),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    errorStyle: TextStyle(fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp),
                    errorMaxLines: 5,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isEmpty
                      ? 'confirm_forget_password.please_enter_link_from_email'
                          .tr()
                      : null,
                ),
                SizedBox(height: 16.h),
                GradientTextButton(
                  text: 'confirm_forget_password.confirm'.tr(),
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      // ดึงรหัสจากลิงก์ที่ผู้ใช้ป้อน
                      String code = _extractCodeFromLink(_codeController.text);
                      if (code.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NewPasswordScreen(resetCode: code),
                          ),
                        );
                      } else {
                        NotificationDialog(
                          context: context,
                          text: "confirm_forget_password.link_invalid_try_again"
                              .tr(),
                        ).showErrorModal(context);
                      }
                    }
                  },
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
