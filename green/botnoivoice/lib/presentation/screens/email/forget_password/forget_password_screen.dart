import 'package:botnoivoice/presentation/providers/email/email_forget_password_provider.dart';
import 'package:botnoivoice/presentation/screens/appbar/botnoi_app_bar.dart';
import 'package:botnoivoice/presentation/screens/email/forget_password/confirm_forget_password_screen.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_align.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:botnoivoice/presentation/widgets/dialog/notification/notification_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  void sendPasswordResetEmail() async {
    final emailForgetPassword =
        Provider.of<EmailForgetPasswordProvider>(context, listen: false);

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      await emailForgetPassword.sendPasswordResetEmail(_emailController.text);
      final errorMessage = emailForgetPassword.errorMessage;
      if (errorMessage != null && errorMessage.isNotEmpty) {
        NotificationDialog(
          context: context,
          text: errorMessage,
        ).showErrorModal(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ConfirmForgetPasswordScreen(),
          ),
        );
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
      appBar: const BotnoiAppBar(),
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
                SizedBox(height: OrientationHelper.isLandscape ? 20.h : 40.h),
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
                    fontSize: OrientationHelper.isLandscape ? 14.sp : 20.sp,
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
                    fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 32.h),
                TextFormField(
                  controller: _emailController,
                  style:
                      TextStyle(fontSize: OrientationHelper.isLandscape ? 11.sp : 16.sp, fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    labelText: 'forget_password.email'.tr(),
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
