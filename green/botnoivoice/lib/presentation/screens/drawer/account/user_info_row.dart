import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final VoidCallback? onIconPressed;
  final bool isValueOverflow;

  const UserInfoRow({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.onIconPressed,
    this.isValueOverflow = false,
  });

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
              fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
              fontWeight: FontWeight.w600,
              color: kDark,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 24.w),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.prompt(
                      fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
                      color: const Color(0xFFBBBFC4),
                    ),
                    overflow: isValueOverflow ? TextOverflow.ellipsis : null,
                    maxLines: value.length > 15 ? 5 : 1,
                    textAlign: TextAlign.right,
                  ),
                ),
                if (icon != null) ...[
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: Icon(icon,
                        size: OrientationHelper.isLandscape ? 12.sp : 18.sp),
                    onPressed: onIconPressed,
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}