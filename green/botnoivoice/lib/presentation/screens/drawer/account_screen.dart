import 'package:botnoivoice/data/repositories/auth_repository_impl.dart';
import 'package:botnoivoice/presentation/screens/login/auth_screen.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_button.dart';
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
    final user = Provider.of<AuthenticationRepositoryImpl>(context).user;

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
            UserInfoRow(
              title: 'ชื่อผู้ใช้',
              value: user?.displayName ?? 'No Name',
            ),
            const UserInfoRow(title: 'UID', value: ' UID'),
            UserInfoRow(
                title: 'อีเมล',
                value: Provider.of<AuthenticationRepositoryImpl>(context)
                        .getUserEmail(user) ??
                    'No email found'),
            const Spacer(),
            GradientButton(
              text: 'ออกจากระบบ',
              onPressed: () async {
                await Provider.of<AuthenticationRepositoryImpl>(context,
                        listen: false)
                    .signOut()
                    .whenComplete(() {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthScreen(),
                    ),
                    (route) => false,
                  );
                });
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
