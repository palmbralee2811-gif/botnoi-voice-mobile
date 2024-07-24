import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Account",
          style: GoogleFonts.prompt(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF323130)),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color(0xFF323130),
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
            print('Back');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoRow(
              title: 'Username',
              value: 'xxxxxx',
            ),
            UserInfoRow(title: 'UID', value: 'xxxxxxx'),
            UserInfoRow(title: 'Email', value: 'XXXXXX@gmail.com'),
            Row(
              children: [
                Text(
                  'Login with ',
                  style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      color: const Color(0xFF323130),
                      fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  icon: Image.asset('assets/logo/google.png',
                      width: 29.w, height: 29.h),
                  iconSize: 24,
                  onPressed: () {
                    print('Login with Google');
                  },
                ),
              ],
            ),
            const Spacer(),
            GradientButton(
              text: 'Logout',
              onPressed: () {
                print('Logout');
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  print('Delete Account');
                },
                child: Text(
                  'Delete Account',
                  style: GoogleFonts.prompt(
                      color: const Color(0xFFF87979), fontSize: 14.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final String title;
  final String value;

  UserInfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: GoogleFonts.prompt(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF323130))),
          Text(value,
              style: GoogleFonts.prompt(
                  fontSize: 14.sp, color: const Color(0xFFBBBFC4))),
        ],
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  GradientButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(text,
            style: GoogleFonts.prompt(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
