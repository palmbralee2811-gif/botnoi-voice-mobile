import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/get_user_email.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  User? googleUser = FirebaseAuth.instance.currentUser;
  String displayName = "Loading...";
  String userId = "Loading...";
  String email = "Loading...";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _loadUserInfo());
  }

  /// แยกฟังก์ชันสำหรับโหลดข้อมูลผู้ใช้
  Future<void> _loadUserInfo() async {
    var lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    var googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    var emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);

    if (lineProvider.isLoggedIn) {
      displayName = lineProvider.getDisplayName ?? "No Name";
      userId = lineProvider.getLineUserId ?? "No UID";
      email = lineProvider.getLineEmail ?? "No email found";
    } else if (googleProvider.isLoggedIn) {
      displayName = googleUser?.displayName ?? 'No Name';
      userId = googleUser?.uid ?? 'No UID';
      email = getUserEmail(googleUser) ?? 'No email found';
    } else if (emailProvider.isLoggedIn) {
      displayName = emailProvider.currentUser?.displayName ?? "No Name";
      userId = emailProvider.currentUser?.uid ?? "No UID";
      email = emailProvider.currentUser?.email ?? "No email found";
    }

    setState(() {}); // อัพเดต UI เมื่อข้อมูลถูกโหลดเสร็จสิ้น
  }

  /// ฟังก์ชันสำหรับการออกจากระบบ
  Future<void> _signOut(BuildContext context) async {
    var lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    var googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    var emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);

    if (lineProvider.isLoggedIn) {
      await lineProvider.signOutWithLine(context);
    }

    if (googleProvider.isLoggedIn) {
      await googleProvider.signOut(context);
    }

    if (emailProvider.isLoggedIn) {
      await emailProvider.signOut(context);
    }

    Navigator.popUntil(context, (r) => r.isFirst);
  }

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
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfoRow(title: 'ชื่อผู้ใช้', value: displayName),
            UserInfoRow(title: 'UID', value: userId),
            UserInfoRow(title: 'อีเมล', value: email),
            const Spacer(),
            GradientTextButton(
              text: 'ออกจากระบบ',
              onPressed: () async {
                await _signOut(context); // เรียกใช้ฟังก์ชันออกจากระบบ
              },
            ),
            SizedBox(height: 16.h),
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
      padding: EdgeInsets.symmetric(vertical: 8.h),
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
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.prompt(
                fontSize: 14.sp,
                color: const Color(0xFFBBBFC4),
              ),
              overflow: TextOverflow.ellipsis, // จัดการข้อความยาว
              maxLines: 1, // แสดงแค่ 1 บรรทัด
              textAlign: TextAlign.right, // จัดเรียงให้ชิดขวา
            ),
          ),
        ],
      ),
    );
  }
}
