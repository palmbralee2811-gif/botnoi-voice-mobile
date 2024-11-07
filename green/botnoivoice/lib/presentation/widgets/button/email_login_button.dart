import 'package:botnoivoice/presentation/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class EmailLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const EmailLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(left: 30.w, right: 30.w),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                padding: EdgeInsets.zero,
                minimumSize: Size(224.w, 48.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/auth_screen/email-icon.svg',
                    height: 20.h,
                    width: 20.w,
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'เข้าสู่ระบบด้วยชื่อผู้ใช้งานหรืออีเมล',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: kDark,
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