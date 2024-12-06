import 'package:botnoivoice/data/authentication/auth_checker.dart';
import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_register_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/screens/email/email_login_screen.dart';
import 'package:botnoivoice/presentation/screens/email/policy/privacy_policy_screen.dart';
import 'package:botnoivoice/presentation/screens/email/policy/terms_service_screen.dart';
import 'package:botnoivoice/presentation/widgets/button/apple_login_button.dart';
import 'package:botnoivoice/presentation/widgets/button/google_login_button.dart';
import 'package:botnoivoice/presentation/widgets/button/line_login_button.dart';
import 'package:botnoivoice/presentation/widgets/dialog/email_permission/email_permission_dialog.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_style.dart';
import 'package:botnoivoice/presentation/widgets/dialog/notification_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  /// ฟังก์ชันตรวจสอบรูปแบบอีเมล
  bool isValidEmail(String email) {
    return EmailValidator.validate(email);
  }

  /// ตรวจสอบชื่อผู้ใช้งานว่าถูกต้องหรือไม่
  bool isValidUsername(String username) {
    if (username.length < 3) return false;
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    return usernameRegex.hasMatch(username);
  }

  /// ฟังก์ชันสมัครสมาชิก
  Future<void> _registerUser() async {
    final emailRegisterProvider =
        Provider.of<EmailRegisterProvider>(context, listen: false);

    if (_isLoading) return; // ป้องกันการกดปุ่มซ้ำ
    setState(() => _isLoading = true); // เริ่มสถานะการทำงาน

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      emailRegisterProvider.username = _usernameController.text.trim();
      await emailRegisterProvider.registerWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _confirmPasswordController.text.trim(),
      );

      final errorMessage = emailRegisterProvider.errorMessage;
      if (errorMessage != null && errorMessage.isNotEmpty) {
        NotificationDialog(
          context: context,
          text: errorMessage,
        ).showErrorModal(context);
        setState(
            () => _isLoading = false); // ยกเลิกสถานะการทำงานหากมีข้อผิดพลาด
        return;
      }

      final resultMessage = emailRegisterProvider.resultMessage;
      if (resultMessage != null && resultMessage.isNotEmpty) {
        NotificationDialog(
          context: context,
          text: resultMessage,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const EmailLoginScreen()),
            );
          },
        ).showCheckmarkModalWithAction(context);
      }
    } else {
      setState(() =>
          _isLoading = false); // ยกเลิกสถานะการทำงานหาก validation ล้มเหลว
    }

    setState(() => _isLoading = false); // การทำงานเสร็จสิ้น
  }

  /// Display Email Permission Dialog and Call Register Function
  void _openEmailPermissionDialog() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return EmailPermissionDialog(
            onPressed: _registerUser,
          );
        },
      );
    }
  }

  // แสดงหน้าจอ Apple Login
  Future<void> _openAppleLogin() async {
    await Provider.of<AppleLoginProvider>(context, listen: false)
        .signInWithApple();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthChecker()));
  }

  /// แสดงหน้าจอ Google Login
  Future<void> _openGoogleLogin() async {
    await Provider.of<GoogleLoginProvider>(context, listen: false)
        .signInWithGoogle();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthChecker()));
  }

  /// แสดงหน้าจอ Line Login
  Future<void> _openLineLogin() async {
    await Provider.of<LineLoginProvider>(context, listen: false)
        .signInWithLine();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AuthChecker()));
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
                padding: EdgeInsets.only(left: 24.w, right: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildGradientText('register.sign_up'.tr()),
                      SizedBox(height: 20.h),
                      _buildTextFormField(
                          _emailController, 'register.email'.tr()),
                      SizedBox(height: 16.h),
                      _buildTextFormField(
                          _usernameController, 'register.username'.tr()),
                      SizedBox(height: 16.h),
                      _buildPasswordField(
                          _passwordController, 'register.password'.tr()),
                      SizedBox(height: 16.h),
                      _buildPasswordField(_confirmPasswordController,
                          'register.confirm_password'.tr(),
                          isConfirmPassword: true),
                      SizedBox(height: 16.h),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : GradientTextButton(
                              text: 'register.sign_up'.tr(),
                              onPressed: _openEmailPermissionDialog,
                            ),
                      SizedBox(height: 16.h),
                      _buildBackToLoginButton(),
                      SizedBox(height: 16.h),
                      _buildDividerWithText('register.or'.tr()),
                      SizedBox(height: 16.h),
                      _buildSocialButtons(),
                      SizedBox(height: 16.h),
                      _buildPolicyScreen(),
                      SizedBox(height: 16.h),
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

  Widget _buildTextFormField(TextEditingController controller, String label,
      {bool isPassword = false, bool isConfirmPassword = false}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        errorStyle: TextStyle(fontSize: 14.sp),
        errorMaxLines: 5,
        suffixIcon: IconButton(
          icon: Icon(
            isPassword || isConfirmPassword
                ? (_isPasswordVisible ? Icons.visibility : Icons.visibility_off)
                : null,
            size: 24.w,
          ),
          onPressed: isPassword || isConfirmPassword
              ? () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                }
              : null,
        ),
      ),
      obscureText:
          isPassword || isConfirmPassword ? !_isPasswordVisible : false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please_enter_label'.tr(namedArgs: {'label': label});
        }
        if (label == 'อีเมล' && !isValidEmail(value)) {
          return 'register.email_invalid_format'.tr();
        }
        if (label == 'ชื่อผู้ใช้งาน' && !isValidUsername(value)) {
          return 'register.username_invalid'.tr();
        }
        if (isConfirmPassword && value != _passwordController.text) {
          return 'register.password_mismatch'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label,
      {bool isConfirmPassword = false}) {
    return TextFormField(
      controller: controller,
      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        errorStyle: TextStyle(fontSize: 14.sp),
        errorMaxLines: 5,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
          return 'register.please_enter_password'.tr();
        } else if (value.length < 6) {
          return 'register.password_minimum_length'.tr();
        } else if (isConfirmPassword && value != _passwordController.text) {
          return 'register.password_mismatch'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildGradientText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GradientTextStyle(
        text,
        gradient: const LinearGradient(
            colors: [Color(0xFF9340FF), Color(0xFF34BDFA)]),
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
      ),
    );
  }

  Widget _buildBackToLoginButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Align(
        alignment: Alignment.center,
        child: Text('register.back_to_sign_in'.tr(),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp)),
      ),
    );
  }

  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        const Expanded(
            child: Divider(thickness: 1.0, color: Color(0xFF34BDFA))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: Colors.grey.shade600),
          ),
        ),
        const Expanded(
            child: Divider(thickness: 1.0, color: Color(0xFF34BDFA))),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: LineLoginButton(onPressed: _openLineLogin),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: GoogleLoginButton(onPressed: _openGoogleLogin),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          child: AppleLoginButton(onPressed: _openAppleLogin),
        ),
      ],
    );
  }

  Widget _buildPolicyScreen() {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              "I have read and accepted the ",
              style: TextStyle(fontSize: 12.sp, color: kDark),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TermsServiceScreen()));
              },
              child: GradientTextStyle(
                "Terms of USE",
                gradient: const LinearGradient(
                    colors: [Color(0xFF9340FF), Color(0xFF34BDFA)]),
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
              ),
            ),
            Text(
              " and ",
              style: TextStyle(fontSize: 12.sp, color: kDark),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen()));
              },
              child: GradientTextStyle(
                "Private Policy.",
                gradient: const LinearGradient(
                    colors: [Color(0xFF9340FF), Color(0xFF34BDFA)]),
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
