import 'package:botnoivoice/domain/repositories/auth_checker.dart';
import 'package:botnoivoice/presentation/widgets/dialog/alert_notification_dialog.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_align.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/screens/email/register_screen.dart';
import 'package:botnoivoice/presentation/screens/email/button/google_login_button.dart';
import 'package:botnoivoice/presentation/screens/email/button/line_login_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _loginUser() async {
    final emailLoginProvider = Provider.of<EmailLoginProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await emailLoginProvider.loginWithEmailPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        final errorMessage = emailLoginProvider.errorMessage;

        if (errorMessage != null && errorMessage.isNotEmpty) {
          AlertNotificationDialog(
            context: context,
            text: errorMessage,
          ).showAsError();
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AuthChecker(),
            ),
          );
        }
      } catch (e) {
        AlertNotificationDialog(
          context: context,
          text: 'An unexpected error occurred. Please try again.',
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
                    GradientTextAlign(
                      'เข้าสู่ระบบ',
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9340FF),
                          Color(0xFF34BDFA),
                        ],
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8.h),
                    GradientTextAlign(
                      'สวัสดี, Botnoi Voice ยินดีต้อนรับ',
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9340FF),
                          Color(0xFF34BDFA),
                        ],
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 32.h),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'อีเมล',
                        prefixIcon: Icon(Icons.email, size: 24.w),
                        fillColor: Colors.white,
                        filled: true,
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
                        fillColor: Colors.white,
                        filled: true,
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
                    _isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator()) // แสดงสถานะการโหลด
                        : GradientTextButton(
                            text: 'เข้าสู่ระบบ',
                            onPressed: _loginUser,
                          ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'สมัครใช้งาน',
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
                          child: Text(
                            'หรือ',
                            style: TextStyle(
                                fontSize: 14.sp,
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
                    SizedBox(height: 16.h),
                    const LineLoginButton(),
                    SizedBox(height: 16.h),
                    const GoogleLoginButton(),
                    SizedBox(height: 16.h),
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
