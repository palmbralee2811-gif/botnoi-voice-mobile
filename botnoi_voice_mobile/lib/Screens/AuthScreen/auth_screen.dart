import 'package:botnoi_voice_mobile/Authentication/authentication_provider.dart';
import 'package:botnoi_voice_mobile/Screens/AcceptScreen/privacy_policy_screen.dart';
import 'package:botnoi_voice_mobile/Screens/AcceptScreen/terms_service_screen.dart';
import 'package:botnoi_voice_mobile/Screens/AuthScreen/gradient_text.dart';
import 'package:flutter/gestures.dart';
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
  late Size mediaSize;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Rectangle10094.png',
              width: screenWidth,
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
          SizedBox(
            height: 50.h,
          ),
          _buildTop(context),
          SizedBox(height: 50.h),
          _buildCenter(),
          SizedBox(height: 10.h),
          _buildLoginLineButton(mediaSize),
          SizedBox(height: 10.h),
          _buildLoginGoogleButton(),
          SizedBox(height: 30.h),
          _buildAccept(),
        ],
      ),
    );
  }

  Widget _buildTop(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: SizedBox(
            width: mediaSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 20.w, bottom: 10.h),
                    child: GradientText(
                      'ยินดีต้อนรับ',
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9340FF),
                          Color(0xFF34BDFA),
                        ],
                      ),
                      style: GoogleFonts.prompt(
                        fontSize: 14.sp,
                        decoration: TextDecoration.none,
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 20.w, bottom: 10.h),
                    child: GradientText(
                      'BOTNOI Voice',
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9340FF),
                          Color(0xFF34BDFA),
                        ],
                      ),
                      style: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        decoration: TextDecoration.none,
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, bottom: 0.5.h),
                  child: Text(
                    'เปลี่ยนข้อความเป็นเสียงในทันที!\nไม่ว่าคุณจะต้องการพากษ์บทความ ฟังหนังสือ\nหรือสร้างเสียงบรรยายสำหรับวิดีโอ',
                    style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCenter() {
    return Center(
      child: Container(
        width: 200.w,
        height: 200.h,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/image559.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLineButton(Size mediaSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3ACE01),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.zero,
                minimumSize: Size(mediaSize.width * 0.2, 50.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/line.png',
                    height: 60.h,
                    width: 60.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'เข้าสู่ระบบด้วย Line',
                    style: GoogleFonts.prompt(
                      fontSize: 16.sp,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: ElevatedButton(
              onPressed: () async {
                await Provider.of<Authentication>(context)
                    .signInWithGoogle(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.zero,
                minimumSize: Size(mediaSize.width * 0.8, 60.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google.png',
                    height: 40.h,
                    width: 40.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'เข้าสู่ระบบด้วย Google',
                    style: GoogleFonts.prompt(
                      fontSize: 16.sp,
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

  Widget _buildAccept() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    // text: 'I agree that I have read and accepted the ',
                    text:
                        'By continuing, you are indicating that you accept our ',
                    style: GoogleFonts.prompt(
                        fontSize: 14.sp, color: const Color(0xFF605E5C)),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Terms of Service',
                        style: GoogleFonts.prompt(
                          fontSize: 14.sp,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TermsServiceScreen(),
                              ),
                            );
                          },
                      ),
                      TextSpan(
                        text: ' and ',
                        style: GoogleFonts.prompt(
                            fontSize: 14.sp, color: const Color(0xFF605E5C)),
                      ),
                      TextSpan(
                        text: 'Private Policy',
                        style: GoogleFonts.prompt(
                          fontSize: 14.sp,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPolicyScreen(),
                              ),
                            );
                          },
                      ),
                      TextSpan(
                        text: '.',
                        style: GoogleFonts.prompt(
                            fontSize: 14.sp, color: const Color(0xFF605E5C)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
