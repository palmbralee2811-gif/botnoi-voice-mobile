import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_close_button.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Alert Modal for displaying messages
class DisableEmailPermissionDialog extends StatelessWidget {
  const DisableEmailPermissionDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SizedBox(
        width: 288.w,
        height: ResponsiveDesignOrientation.isLandscape ? 600.h : 400.h,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/icon/question-mark.svg',
                  width: ResponsiveDesignOrientation.isLandscape ? 74.w : 54.w,
                  height: ResponsiveDesignOrientation.isLandscape ? 74.h : 54.h,
                ),
                SizedBox(height: 16.h),
                Text(
                  'disable_email_permission.disable_email_access'
                      .tr(), //ปิดใช้งานการเข้าถึงข้อมูลอีเมล
                  style: GoogleFonts.prompt(
                    fontSize:
                        ResponsiveDesignOrientation.isLandscape ? 12.sp : 16.sp,
                    fontWeight: FontWeight.w600,
                    color: kDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  'disable_email_permission.email_access_disabled_warning'
                      .tr(), //หากปิดใช้งานการเข้าถึงข้อมูลอีเมลอาจทำให้ไม่สามารถใช้งานฟีเจอร์การกู้คืนรหัสผ่านหรือรับการแจ้งเตือนข้อมูลข่าวสารที่สำคัญที่เกี่ยวข้องกับการใช้งานแอปของคุณได้
                  style: GoogleFonts.prompt(
                    fontSize:
                        ResponsiveDesignOrientation.isLandscape ? 8.sp : 14.sp,
                    fontWeight: FontWeight.w400,
                    color: kDarkGray,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 12.h),
                Text(
                  'disable_email_permission.do_you_want_to_disable'
                      .tr(), //คุณต้องการที่จะปิดใช้งานหรือไม่
                  style: GoogleFonts.prompt(
                    fontSize:
                        ResponsiveDesignOrientation.isLandscape ? 8.sp : 14.sp,
                    fontWeight: FontWeight.w400,
                    color: kDark,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 24.h),
                GradientTextButton(
                  text: 'disable_email_permission.yes'.tr(), //ต้องการ
                  onPressed: () {
                    // Close Disable Email Permission Dialog
                    context.pop();
                    onConfirm();
                  },
                ),
                SizedBox(
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 22.h : 12.h),
                GradientCloseButton(
                  text: 'disable_email_permission.no'.tr(), //ไม่ต้องการ
                  onPressed: () {
                    // Close Disable Email Permission Dialog
                    context.pop();
                    onCancel();
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
