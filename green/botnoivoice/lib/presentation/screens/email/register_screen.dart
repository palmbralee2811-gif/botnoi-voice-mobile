import 'package:botnoivoice/domain/repositories/auth_checker.dart';
import 'package:botnoivoice/presentation/providers/email/email_register_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/widgets/button/google_login_button.dart';
import 'package:botnoivoice/presentation/widgets/button/line_login_button.dart';
import 'package:botnoivoice/presentation/widgets/dialog/alert_notification_dialog.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_style.dart';
import 'package:botnoivoice/presentation/widgets/modal/alert_message_modal.dart';
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

  /// ตรวจสอบชื่อผู้ใช้ว่าถูกต้องหรือไม่
  bool isValidUsername(String username) {
    if (username.length < 3) return false;
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    return usernameRegex.hasMatch(username);
  }

  /// แสดง dialog ยืนยันการสมัคร
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('ยืนยันการสมัครสมาชิก'),
          content: const Text('คุณต้องการสมัครสมาชิกใช่หรือไม่?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _registerUser();
              },
            ),
          ],
        );
      },
    );
  }

  /// ฟังก์ชันสมัครสมาชิก
  void _registerUser() {
    final emailRegisterProvider =
        Provider.of<EmailRegisterProvider>(context, listen: false);

    if (!isValidUsername(_usernameController.text.trim())) {
      AlertNotificationDialog(
        context: context,
        text:
            "ชื่อผู้ใช้ไม่ถูกต้อง กรุณาใช้ตัวอักษร a-z, A-Z, ตัวเลข และเครื่องหมาย _ หรือ -",
      ).showAsError();
      return;
    }

    if (_formKey.currentState!.validate()) {
      emailRegisterProvider.username = _usernameController.text.trim();
      emailRegisterProvider
          .registerWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _confirmPasswordController.text.trim(),
      )
          .then((_) {
        final errorMessage = emailRegisterProvider.errorMessage;
        if (errorMessage != null && errorMessage.isNotEmpty) {
          AlertMessageModal(
            context: context,
            text: errorMessage,
          ).showErrorModalWithLogin(context);
        }
      });
    }
  }

  /// แสดงหน้าจอ Google Login
  void _openGoogleLogin() async {
    await Provider.of<GoogleLoginProvider>(context, listen: false)
        .signInWithGoogle()
        .whenComplete(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthChecker()));
    });
  }

  /// แสดงหน้าจอ Line Login
  void _openLineLogin() async {
    await Provider.of<LineLoginProvider>(context, listen: false)
        .signInWithLine()
        .whenComplete(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AuthChecker()));
    });
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
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGradientText('สมัครใช้งาน'),
                    SizedBox(height: 40.h),
                    _buildTextFormField(_emailController, 'อีเมล', Icons.email),
                    SizedBox(height: 16.h),
                    _buildTextFormField(
                        _usernameController, 'ชื่อผู้ใช้', Icons.person),
                    SizedBox(height: 16.h),
                    _buildPasswordField(_passwordController, 'รหัสผ่าน'),
                    SizedBox(height: 16.h),
                    _buildPasswordField(
                      _confirmPasswordController,
                      'ยืนยันรหัสผ่าน',
                      isConfirmPassword: true,
                    ),
                    SizedBox(height: 16.h),
                    GradientTextButton(
                      text: 'สมัครใช้งาน',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _showConfirmationDialog(context);
                        }
                      },
                    ),
                    SizedBox(height: 16.h),
                    _buildBackToLoginButton(),
                    SizedBox(height: 16.h),
                    _buildDividerWithText('หรือ'),
                    SizedBox(height: 16.h),
                    _buildSocialButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 24.w),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'โปรดใส่$labelของคุณ';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label, {
    bool isConfirmPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock, size: 24.w),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
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
          return 'โปรดใส่รหัสผ่านของคุณ';
        } else if (value.length < 6) {
          return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
        } else if (isConfirmPassword && value != _passwordController.text) {
          return 'รหัสผ่านไม่ตรงกัน';
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
        child: Text('กลับไปที่เข้าสู่ระบบ',
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
          child: Text(text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: Colors.grey.shade600)),
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
      ],
    );
  }
}
