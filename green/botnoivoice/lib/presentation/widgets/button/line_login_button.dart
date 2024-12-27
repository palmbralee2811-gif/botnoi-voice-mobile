import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LineLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LineLoginButton({super.key, required this.onPressed});

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
            padding: EdgeInsets.zero,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.zero,
                minimumSize:
                    isLandscape ? Size(224.w, 88.h) : Size(224.w, 48.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/auth_screen/line-icon.svg',
                    height: isLandscape ? 52.h : 32.h,
                    width: isLandscape ? 32.w : 32.w,
                  ),
                  SizedBox(width: isLandscape ? 12.w : 16.w),
                  Text(
                    'auth.sign_in_with_line'.tr(),
                    style: TextStyle(
                      fontSize: isLandscape ? 9.sp : 12.sp,
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
