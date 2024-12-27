import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class EmailLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const EmailLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final orientation =
        MediaQuery.of(context).orientation; // ตรวจสอบ orientation
    final isLandscape = orientation == Orientation.landscape;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(
                left: isLandscape ? 65.w : 30.w,
                right: isLandscape ? 65.w : 30.w),
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
                minimumSize:
                    isLandscape ? Size(224.w, 88.h) : Size(224.w, 48.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/auth_screen/email-icon.svg',
                    height: isLandscape ? 35.h : 20.h,
                    width: isLandscape ? 20.w : 20.w,
                  ),
                  SizedBox(width: isLandscape ? 12.w : 16.w),
                  Text(
                    'auth.sign_in_with_username_email'.tr(),
                    style: TextStyle(
                      fontSize: isLandscape ? 9.sp : 12.sp,
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
