import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:botnoivoice/presentation/screens/login/google_login_button.dart';
import 'package:botnoivoice/presentation/screens/login/line_login_button.dart';

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

  // State variable for showing/hiding the password for both fields
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    // ตั้งค่า Status Bar ให้เป็นสีโปร่งใส
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true, // ทำให้ AppBar ขยายตัวไปอยู่ด้านบนสุด
      appBar: AppBar(
        backgroundColor: Colors.transparent, // โปร่งใส
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // กลับไปที่หน้าจอก่อนหน้า
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB1E9FD),
              Color(0xFFF9D8FD)
            ], // สีพื้นหลังแบบ gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.all(24.w), // ใช้ screenutil เพื่อปรับขนาดตามหน้าจอ
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //TODO: Change This Text
                    Text(
                      'สมัครใช้งาน',
                      style: TextStyle(
                        fontSize: 24.sp, // ขนาดฟอนต์ที่ปรับให้รองรับทุกหน้าจอ
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00796B),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    //TODO: Change This Text
                    Text(
                      'กรุณากรอกข้อมูลของคุณเพื่อสมัครใช้งาน',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    // Email input field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'อีเมล',
                        prefixIcon: Icon(Icons.email,
                            size: 24.w), // ขนาดไอคอนที่ปรับตามหน้าจอ
                        filled: true,
                        fillColor: Colors.white, // ปรับสีพื้นหลังเป็นสีขาว
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
                    // Password input field
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
                        prefixIcon: Icon(Icons.lock, size: 24.w),
                        filled: true,
                        fillColor: Colors.white, // ปรับสีพื้นหลังเป็นสีขาว
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
                    SizedBox(height: 16.h),
                    // Confirm password input field
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'ยืนยันรหัสผ่าน',
                        prefixIcon: Icon(Icons.lock, size: 24.w),
                        filled: true,
                        fillColor: Colors.white, // ปรับสีพื้นหลังเป็นสีขาว
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
                      validator: (value) => value != _passwordController.text
                          ? 'รหัสผ่านไม่ตรงกัน'
                          : null,
                    ),
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
                          // TODO: Implement register logic
                        }
                      },
                      child: Text(
                        'สมัครใช้งาน',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // กลับไปที่หน้าจอเข้าสู่ระบบ
                      },
                      child: Text(
                        'กลับไปที่เข้าสู่ระบบ',
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
