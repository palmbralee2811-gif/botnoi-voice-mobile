import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// StatelessWidget = HTML + CSS
/// StatefulWidget = HTML + CSS + JS
/// Animation = CSS + JS
class GoogleLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GoogleLoginButton({super.key, required this.onPressed});

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
                minimumSize:
                    OrientationHelper.isLandscape ? Size(224.w, 88.h) : Size(224.w, 48.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/auth_screen/google-icon.svg',
                    height: OrientationHelper.isLandscape ? 52.h : 32.h,
                    width: OrientationHelper.isLandscape ? 32.w : 32.w,
                  ),
                  SizedBox(width: OrientationHelper.isLandscape ? 12.w : 16.w),
                  Text(
                    'auth.sign_in_with_google'.tr(),
                    style: TextStyle(
                      fontSize: OrientationHelper.isLandscape ? 9.sp : 12.sp,
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
