import 'package:botnoivoice/presentation/constants/color.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_close_button.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Alert Modal for displaying messages
class EmailPermissionDialog extends StatelessWidget {
  const EmailPermissionDialog({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SizedBox(
        width: 288.w,
        height: 510.h,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/icon/shield-check.svg',
                  width: 54.w,
                  height: 54.h,
                ),
                SizedBox(height: 16.h),
                Text(
                  'app_drawer.request_email_permission'.tr(), //ขออนุญาตในการเก็บข้อมูลอีเมล
                  style: GoogleFonts.prompt(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: kDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  'app_drawer.email_permission_info'.tr(), //เพื่อให้คุณสามารถใช้งานฟีเจอร์การกู้คืนรหัสผ่านและให้เราสามารถแจ้งเตือนเกี่ยวกับข้อมูลข่าวสารที่สำคัญที่เกี่ยวข้องกับการใช้งานแอปของคุณตามเงื่อนไขการเก็บข้อมูลอีเมลของคุณ โดยข้อมูลนี้จะถูกเก็บรักษาอย่างปลอดภัยและไม่ใช้เพื่อวัตถุประสงค์ทางโฆษณาโดยไม่ได้รับความยินยอม
                  style: GoogleFonts.prompt(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: kGray,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 12.h),
                Text(
                  'app_drawer.revoke_permission_later'.tr(), //คุณสามารถยกเลิกการอนุญาตได้ในภายหลัง
                  style: GoogleFonts.prompt(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: kDark,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 24.h),
                GradientTextButton(
                  text: 'app_drawer.agree'.tr(), //ยินยอม
                  onPressed: () {
                    Navigator.of(context).pop();
                    onPressed();
                  },
                ),
                SizedBox(height: 12.h),
                GradientCloseButton(
                  text: 'ไม่ยินยอม', //ไม่ยินยอม
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
