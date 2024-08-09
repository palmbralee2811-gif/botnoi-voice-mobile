import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_button.dart';
import 'package:botnoivoice/Screens/SignInScreen/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyAccountWidget extends StatefulWidget {
  const MyAccountWidget({super.key});

  @override
  State<MyAccountWidget> createState() => _MyAccountWidgetState();
}

class _MyAccountWidgetState extends State<MyAccountWidget> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: false);
    // แสดง email ผู้ใช้งาน ปัจจุบัน
    User? user = FirebaseAuth.instance.currentUser;
    String? email = auth.getUserEmail(user);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ข้อมูลส่วนตัว",
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
              title: 'ชื่อผู้ใช้',
              value: '${auth.user!.displayName}',
            ),
            UserInfoRow(title: 'UID', value: ' UID'),
            UserInfoRow(
                title: 'อีเมล', value: ' ${email ?? ' No email found'}'),
            Row(
              children: [
                Text(
                  'เข้าสู่ระบบด้วย',
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
              text: 'ออกจากระบบ',
              onPressed: () async {
                await auth.signOut();
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  print('Delete Account');
                },
                child: Text(
                  'ลบบัญชี',
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

  const UserInfoRow({super.key, required this.title, required this.value});

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
