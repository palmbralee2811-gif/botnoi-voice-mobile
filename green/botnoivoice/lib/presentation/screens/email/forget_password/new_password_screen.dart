import 'package:botnoivoice/presentation/screens/email/email_login_screen.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_align.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:botnoivoice/presentation/widgets/dialog/notification/notification_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_forget_password_provider.dart';

class NewPasswordScreen extends StatefulWidget {
  final String resetCode;

  const NewPasswordScreen({super.key, required this.resetCode});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;

  /// ฟังก์ชันรีเซ็ตรหัสผ่าน
  Future<void> _resetPassword(String code, String newPassword) async {
    final emailForgetPasswordProvider =
        Provider.of<EmailForgetPasswordProvider>(context, listen: false);

    try {
      await emailForgetPasswordProvider.confirmPasswordReset(code, newPassword);

      if (emailForgetPasswordProvider.errorMessage == null) {
        NotificationDialog(
          context: context,
          text: "new_password.password_reset_success".tr(),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const EmailLoginScreen()),
            );
          },
        ).showCheckmarkModalWithAction(context);
      } else {
        NotificationDialog(
          context: context,
          text: "${'new_password.error_occurred'.tr()} ${emailForgetPasswordProvider.errorMessage}",
        ).showErrorModal(context);
      }
    } catch (e) {
      NotificationDialog(
        context: context,
        text:
            "${'new_password.error_occurred'.tr()} ${emailForgetPasswordProvider.errorMessage ?? e.toString()}",
      ).showErrorModal(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GradientTextAlign(
                        'new_password.reset_password'.tr(),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      GradientTextAlign(
                        'new_password.password_length'.tr(),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 40.h),
                      TextFormField(
                        controller: _passwordController,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          labelText: 'new_password.password'.tr(),
                          labelStyle: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w400),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 24.w,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'new_password.please_enter_password'.tr();
                          } else if (value.length < 6) {
                            return 'new_password.password_min_length'.tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _confirmPasswordController,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          labelText: 'new_password.confirm_password'.tr(),
                          labelStyle: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w400),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 24.w,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'new_password.password_mismatch'.tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      GradientTextButton(
                        text: 'new_password.confirm'.tr(),
                        onPressed: () {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            _resetPassword(widget.resetCode,
                                _passwordController.text.trim());
                          }
                        },
                      ),
                      SizedBox(height: 60.h),
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
