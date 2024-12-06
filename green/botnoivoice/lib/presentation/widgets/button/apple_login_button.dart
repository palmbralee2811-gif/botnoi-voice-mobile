import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppleLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AppleLoginButton({super.key, required this.onPressed});

  @override  
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.zero,
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
                    Image.asset(
                    'assets/images/auth_screen/apple-icon.png',
                    height: 32.h,
                    width: 32.w,
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'เข้าสู่ระบบด้วย Apple',
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