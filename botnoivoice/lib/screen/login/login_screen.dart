import 'dart:io';
import 'package:botnoivoice/auth/internet_checker.dart';
import 'package:botnoivoice/shared/function/open_login_function.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/widget/button/apple_login_button.dart';
import 'package:botnoivoice/shared/widget/button/email_login_button.dart';
import 'package:botnoivoice/shared/widget/button/google_login_button.dart';
import 'package:botnoivoice/shared/widget/button/line_login_button.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final InternetChecker _internetChecker = InternetChecker();
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _internetChecker.startListeningToInternetChanges(context, (isAvailable) {
        logger.d("internet change in login : $isAvailable");
      });
    });
  }

  @override
  void dispose() {
    _internetChecker.cancelListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFB1E9FD),
                  Color(0xFFF9D8FD),
                ],
              ),
            ),
          ),
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/auth_screen/bg_new.png',
              width: MediaQuery.of(context).size.width,
              height: 684.h,
              fit: BoxFit.cover,
            ),
          ),
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // 1. ขยับตำแหน่งข้อความขึ้นไปอีกนิดนึง (ปรับจาก 340 เป็น 280)
                    SizedBox(height: ResponsiveDesignOrientation.isLandscape ? 50.h : 260.h), 
                    _buildCenter(context),
                    
                    // ใช้ Spacer เพื่อดันก้อนปุ่มด้านล่างให้อยู่เป็นกลุ่มเดียวกัน
                    const Spacer(),

                    // --- ปุ่ม Email (กล่องสีเทาดำ) ---
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: ElevatedButton(
                        onPressed: () {
                          openEmailLogin(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF262626), // สีดำเทาตามดีไซน์
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.mail_outline, color: Colors.white),
                            SizedBox(width: 12.w),
                            Text(
                              'เข้าสู่ระบบด้วยชื่อผู้ใช้และรหัสผ่าน',
                              style: GoogleFonts.prompt(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // --- แถวปุ่ม Social Login แบบไอคอนล้วน ---
                    // --- แถวปุ่ม Social Login แบบไอคอนล้วน ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 1. ปุ่ม LINE
                        SizedBox(
                          width: 68.w,
                          height: 52.h,
                          child: InkWell(
                            onTap: () { openLineLogin(ref); },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF00B900),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                // ใส่รูปโลโก้ LINE ตรงนี้ (แก้ path ให้ตรงกับไฟล์ของคุณ)
                                child: Image.asset(
                                  'assets/images/icon/line.png', // ถ้าเป็น svg ให้เปลี่ยนเป็น SvgPicture.asset('...')
                                  width: 28.w, 
                                  height: 28.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 22.w),

                        // 2. ปุ่ม Google
                        SizedBox(
                          width: 68.w,
                          height: 52.h,
                          child: InkWell(
                            onTap: () { openGoogleLogin(ref); },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                              ),
                              child: Center(
                                // ใส่รูปโลโก้ Google ตรงนี้
                                child: Image.asset(
                                  'assets/images/icon/google.png', 
                                  width: 24.w,
                                  height: 24.w,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // 3. ปุ่ม Apple (แสดงเฉพาะ iOS)
                        if (Platform.isIOS) ...[
                          SizedBox(width: 22.w),
                          SizedBox(
                            width: 68.w,
                            height: 52.h,
                            child: InkWell(
                              onTap: () { openAppleLogin(ref); },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  // ใส่รูปโลโก้ Apple ตรงนี้
                                  child: Image.asset(
                                    'assets/images/icon/apple.png', 
                                    width: 24.w,
                                    height: 24.w,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 40.h),

                    // เส้นคั่น "หรือ"
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Color(0xFFD1D1D1), thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'หรือ',
                            style: GoogleFonts.prompt(
                              color: const Color(0xFF4B5563),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Color(0xFFD1D1D1), thickness: 1)),
                      ],
                    ),
                    SizedBox(height: 30.h),

                    // ข้อความ "ยังไม่มีบัญชี ? สมัครเข้าใช้งาน"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ยังไม่มีบัญชี ? ',
                          style: GoogleFonts.prompt(
                            color: const Color(0xFF6B7280),
                            fontSize: 14.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: ใส่ฟังก์ชันเปิดหน้าสมัครสมาชิก
                          },
                          child: Text(
                            'สมัครเข้าใช้งาน',
                            style: GoogleFonts.prompt(
                              color: const Color(0xFFC084FC),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h), // ระยะขอบล่างสุด
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildCenter(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // ชิดซ้าย
        children: [
          Text(
            'สร้างสรรค์ไปกับเสียง', 
            textAlign: TextAlign.left,
            style: GoogleFonts.prompt(
              color: const Color(0xFF262626),
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          GradientTextStyle(
            'บอทน้อยว้อยส์', 
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3EC4FF),
                Color(0xFF889DFC),
                Color(0xFFEB85FC),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            style: GoogleFonts.prompt(
              fontWeight: FontWeight.w700,
              fontSize: 45.sp,
            ),
          ),
        ],
      ),
    );
  }
}