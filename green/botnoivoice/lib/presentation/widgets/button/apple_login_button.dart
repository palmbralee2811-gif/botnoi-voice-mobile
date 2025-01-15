import 'package:easy_localization/easy_localization.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                padding: EdgeInsets.zero,
                minimumSize: OrientationHelper.isLandscape
                    ? Size(224.w, 88.h)
                    : Size(224.w, 48.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/auth_screen/apple-icon.svg',
                      height: OrientationHelper.isLandscape ? 52.h : 32.h,
                      width: OrientationHelper.isLandscape ? 32.w : 32.w,
                    ),
                  ),
                  SizedBox(width: OrientationHelper.isLandscape ? 12.w : 16.w),
                  Text(
                    // 'เข้าสู่ระบบด้วย Apple',
                    'auth.sign_in_with_apple'.tr(),
                    style: TextStyle(
                      fontSize: OrientationHelper.isLandscape ? 9.sp : 12.sp,
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
}
