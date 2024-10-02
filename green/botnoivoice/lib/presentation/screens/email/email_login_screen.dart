import 'package:botnoivoice/presentation/widgets/checkbox/custom_checkbox_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/screens/email/register_screen.dart';
import 'package:botnoivoice/presentation/screens/email/reset_password_screen.dart';
import 'package:botnoivoice/presentation/screens/login/google_login_button.dart';
import 'package:botnoivoice/presentation/screens/login/line_login_button.dart';
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

  @override
  Widget build(BuildContext context) {
    final emailLoginProvider = Provider.of<EmailLoginProvider>(context);

    // ทำให้แถบสถานะเป็นสีโปร่งใส
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // โปร่งใส
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true, // ทำให้ AppBar เป็นส่วนของหน้าจอทั้งหมด
      appBar: AppBar(
        backgroundColor: Colors.transparent, // โปร่งใส
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //TODO: Change This Text
                    Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00796B),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    //TODO: Change This Text
                    Text(
                      'สวัสดี, Botnoi Voice ยินดีต้อนรับ',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'อีเมล',
                        prefixIcon: Icon(Icons.email, size: 24.w),
                        fillColor: Colors.white, // พื้นหลังสีขาว
                        filled: true, // เปิดการเติมสีพื้นหลัง
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none, // ไม่แสดงเส้นขอบ
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
                        fillColor: Colors.white, // พื้นหลังสีขาว
                        filled: true, // เปิดการเติมสีพื้นหลัง
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none, // ไม่แสดงเส้นขอบ
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
                    SizedBox(height: 8.h),
                    const CustomCheckboxWidget(),
                    SizedBox(height: 16.h),
                    //TODO: Change This Button UI
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 60.w, vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          emailLoginProvider
                              .loginWithEmailPassword(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          )
                              .then((_) {
                            if (emailLoginProvider.currentUser != null) {
                              // TODO: Navigate to home screen or auth checker
                            }
                          });
                        }
                      },
                      child: Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPasswordScreen()),
                        );
                      },
                      child: Text(
                        'ลืมรหัสผ่าน?',
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            thickness: 1.0,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child:
                              Text('หรือ', style: TextStyle(fontSize: 14.sp)),
                        ),
                        const Expanded(
                          child: Divider(
                            thickness: 1.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    const LineLoginButton(),
                    SizedBox(height: 16.h),
                    const GoogleLoginButton(),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: Text('สมัครใช้งาน',
                          style: TextStyle(fontSize: 14.sp)),
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
