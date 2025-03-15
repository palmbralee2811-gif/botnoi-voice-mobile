import 'package:botnoivoice/function/is_vaild_data.dart';
import 'package:botnoivoice/service/email/email_forget_password.dart';
import 'package:botnoivoice/ui/screen/appbar/appbar_template.dart';
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

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void sendPasswordResetEmail() async {
    final emailForgetPassword =
        Provider.of<EmailForgetPassword>(context, listen: false);

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      await emailForgetPassword.sendPasswordResetEmail(_emailController.text);
      final errorMessage = emailForgetPassword.errorMessage;
      if (errorMessage != null && errorMessage.isNotEmpty) {
        NotificationDialog(
          context: context,
          text: errorMessage,
        ).showErrorModal(context);
      } else {
        // Redirect to ConfirmForgetPasswordScreen
        context.go('/confirm-forget-password');
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
          // Redirect to Email Login Screen
          context.go('/email-login');
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
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 20.h : 40.h),
                GradientTextAlign(
                  'forget_password.forgot_password'.tr(),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9340FF),
                      Color(0xFF34BDFA),
                    ],
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize:
                        ResponsiveDesignOrientation.isLandscape ? 14.sp : 20.sp,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 8.h),
                GradientTextAlign(
                  'forget_password.confirm_email'.tr(),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9340FF),
                      Color(0xFF34BDFA),
                    ],
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize:
                        ResponsiveDesignOrientation.isLandscape ? 10.sp : 14.sp,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 32.h),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(
                      fontSize: ResponsiveDesignOrientation.isLandscape
                          ? 11.sp
                          : 16.sp,
                      fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    labelText: 'forget_password.email'.tr(),
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
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'forget_password.please_enter_email'.tr();
                    }
                    if (!isValidEmail(value)) {
                      return 'forget_password.invalid_email_format'.tr();
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                GradientTextButton(
                  text: 'forget_password.send'.tr(),
                  onPressed: () {
                    sendPasswordResetEmail();
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
