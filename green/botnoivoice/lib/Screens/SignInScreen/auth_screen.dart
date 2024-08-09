import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Screens/HomeScreen/home_screen.dart';
import 'package:botnoivoice/Screens/SignInScreen/gradient_text_sign_in_screen.dart';
import 'package:botnoivoice/Screens/SignInScreen/language_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: 320.w,
            height: 684.h,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(0xFFB1E9FD),
                  Color(0xFFF9D8FD),
                ])),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/AuthScreenIcon/background.png',
              width: 320.w,
              height: 684.h,
              fit: BoxFit.cover,
            ),
          ),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          _buildTop(),
          SizedBox(height: 167.h),
          _buildCenter(),
          SizedBox(height: 92.h),
          _buildLoginLineButton(),
          SizedBox(height: 10.h),
          _buildLoginGoogleButton(),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildTop() {
    return Padding(
      padding: EdgeInsets.only(left: 215.w, top: 16.h),
      child: Column(
        children: [
          Opacity(
            opacity: 0.5, // 50% opacity
            child: Container(
              width: 320.w,
              height: 10.h,
              color: Colors.transparent,
            ),
          ),
          const LanguageOptionWidget(),
        ],
      ),
    );
  }

  Widget _buildCenter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: SizedBox(
            width: 320.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    SizedBox(width: 20.w),
                    Image.asset(
                      'assets/AuthScreenIcon/waveform-icon.png',
                      width: 33.33.w,
                      height: 33.33.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, bottom: 10.h),
                      child: GradientTextSignInScreen(
                        'เปลี่ยนข้อความเป็นเสียง',
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9340FF),
                            Color(0xFF34BDFA),
                          ],
                        ),
                        style: GoogleFonts.prompt(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      bottom: 13.h,
                    ),
                    child: GradientTextSignInScreen(
                      'บอทน้อย',
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9340FF),
                          Color(0xFF34BDFA),
                        ],
                      ),
                      style: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                        fontSize: 56.sp,
                        decoration: TextDecoration.none,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      // bottom: 10.h,
                    ),
                    child: GradientTextSignInScreen(
                      'ว้อยส์',
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9340FF),
                          Color(0xFF34BDFA),
                        ],
                      ),
                      style: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                        fontSize: 48.sp,
                        decoration: TextDecoration.none,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLineButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(10.r),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3ACE01),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.zero,
                minimumSize: Size(256.w, 44.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/line.png',
                    height: 36.h,
                    width: 36.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'เข้าสู่ระบบด้วย Line',
                    style: GoogleFonts.prompt(
                      fontSize: 12.sp,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginGoogleButton() {
    final auth = Provider.of<Authentication>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(10.r),
            child: ElevatedButton(
              onPressed: () async {
                final user = await auth.signInWithGoogle(context);
                if (!mounted) return; // ตรวจสอบว่าถ้ายัง mounted อยู่หรือไม่
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to sign in. Please try again.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.zero,
                minimumSize: Size(256.w, 44.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google.png',
                    height: 36.h,
                    width: 36.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'เข้าสู่ระบบด้วย Google',
                    style: GoogleFonts.prompt(
                      fontSize: 12.sp,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
