import 'package:botnoi_voice_mobile/Authentication/authentication_provider.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
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
            debugPrint('Back');
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
              value:
                  '${Provider.of<Authentication>(context).user!.displayName}',
            ),
            const UserInfoRow(title: 'UID', value: ' UID'),
            UserInfoRow(
                title: 'อีเมล',
                value:
                    ' ${Provider.of<Authentication>(context).user?.email ?? ' No email found'}'),
            const Spacer(),
            GradientButton(
              text: 'ออกจากระบบ',
              onPressed: () async {
                await Provider.of<Authentication>(context).signOut(context);
              },
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  debugPrint('Delete Account');
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
          Text(
            title,
            style: GoogleFonts.prompt(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF323130),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.prompt(
              fontSize: 14.sp,
              color: const Color(0xFFBBBFC4),
            ),
          ),
        ],
      ),
    );
  }
}
