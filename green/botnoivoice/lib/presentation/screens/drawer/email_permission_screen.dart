import 'package:botnoivoice/presentation/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailPermissionScreen extends StatefulWidget {
  const EmailPermissionScreen({super.key});

  @override
  State<EmailPermissionScreen> createState() => _EmailPermissionScreenState();
}

class _EmailPermissionScreenState extends State<EmailPermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ความปลอดภัย',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: kDark,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kDark,
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'การเข้าถึงข้อมูลอีเมล',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                color: kDark,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.h),
            Text(
              'เพื่อให้คุณสามารถใช้งานฟีเจอร์การกู้คืนรหัสผ่านและให้เราสามารถแจ้งเตือนเกี่ยวกับข้อมูลข่าวสารที่สำคัญที่เกี่ยวข้องกับการใช้งานแอปของคุณ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: kDark,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
