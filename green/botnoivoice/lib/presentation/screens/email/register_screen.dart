import 'package:botnoivoice/domain/repositories/auth_checker.dart';
import 'package:botnoivoice/presentation/providers/email/email_register_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/screens/email/email_login_screen.dart';
import 'package:botnoivoice/presentation/widgets/button/google_login_button.dart';
import 'package:botnoivoice/presentation/widgets/button/line_login_button.dart';
import 'package:botnoivoice/presentation/widgets/dialog/alert_notification_dialog.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;

  //TODO: ใช้งานยังไง
  //TODO: Check if username is valid when registering
  bool isValidUsername(String username) {
    // ตรวจสอบความยาวของ username อย่างน้อย 3 ตัวอักษร
    if (username.length < 3) {
      return false;
    }

    // ตรวจสอบว่าประกอบไปด้วยตัวอักษรภาษาอังกฤษ a-z, A-Z, ตัวเลข 0-9, เครื่องหมาย _ และ -
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');

    return usernameRegex.hasMatch(username);
  }

  // Function to show confirmation dialog
  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('ยืนยันการสมัครสมาชิก'),
          content: const Text('คุณต้องการสมัครสมาชิกใช่หรือไม่?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                _registerUser(); // Call the function to register the user
              },
            ),
          ],
        );
      },
    );
  }

  // Function to handle user registration
  void _registerUser() {
    final emailLoginProvider =
        Provider.of<EmailRegisterProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      emailLoginProvider
          .registerWithEmailPassword(
              _emailController.text.trim(),
              _passwordController.text.trim(),
              //TODO: ตั้งเงื่อนไข การสร้างรหัสผ่าน ตอนสมัครสมาชิก
              _confirmPasswordController.text.trim())
          .then((_) {
        //TODO: Open Email App on Deveice when need to verify email after registration
        //TODO: Alert Notification display for 10 seconds
        //TODO: When registration is successful, clear vlue input form and Navigate to EmailLoginScreen
        //TODO: Loading animation when processing registration

        final errorMessage =
            Provider.of<EmailLoginProvider>(context, listen: false)
                .errorMessage;

        if (errorMessage != null && errorMessage.isNotEmpty) {
          // ถ้ามี error ให้แสดง AlertNotificationDialog
          AlertNotificationDialog(
            context: context,
            text: errorMessage,
          ).showAsError();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmailLoginScreen()),
          );
        }
      }).catchError((error) {
        // กรณีที่เกิดข้อผิดพลาดในขั้นตอนการสมัคร
        AlertNotificationDialog(
          context: context,
          text: "เกิดข้อผิดพลาด! กรุณาลองใหม่อีกครั้ง",
        ).showAsError();
      });
    }
  }

  /// Open Google Login and Close Register Screen
  void _openGoogleLogin() async {
    await Provider.of<GoogleLoginProvider>(context, listen: false)
        .signInWithGoogle()
        .whenComplete(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthChecker(),
        ),
      );
    });
  }

  /// Open Line Login and Close Register Screen
  void _openLineLogin() async {
    await Provider.of<LineLoginProvider>(context, listen: false)
        .signInWithLine()
        .whenComplete(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthChecker(),
        ),
      );
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
            Navigator.pop(context); // กลับไปที่หน้าจอก่อนหน้า
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GradientTextStyle(
                        'สมัครใช้งาน',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'อีเมล',
                        prefixIcon: Icon(Icons.email, size: 24.w),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value!.isEmpty ? 'โปรดใส่อีเมลของคุณ' : null,
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
                        prefixIcon: Icon(Icons.lock, size: 24.w),
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
                      validator: (value) =>
                          value!.isEmpty ? 'โปรดใส่รหัสผ่านของคุณ' : null,
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'ยืนยันรหัสผ่าน',
                        prefixIcon: Icon(Icons.lock, size: 24.w),
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
                      validator: (value) => value != _passwordController.text
                          ? 'รหัสผ่านไม่ตรงกัน'
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    GradientTextButton(
                      text: 'สมัครใช้งาน',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Show confirmation dialog before registering
                          _showConfirmationDialog(context);
                        }
                      },
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'กลับไปที่เข้าสู่ระบบ',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 14.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
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
                          child: Text('หรือ',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600)),
                        ),
                        const Expanded(
                          child: Divider(
                            thickness: 1.0,
                            color: Color(0xFF34BDFA),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w, right: 15.w),
                      child: LineLoginButton(onPressed: () {
                        _openLineLogin();
                      }),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w, right: 15.w),
                      child: GoogleLoginButton(onPressed: () {
                        _openGoogleLogin();
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
