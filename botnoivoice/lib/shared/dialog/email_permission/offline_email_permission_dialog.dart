import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Alert Modal for displaying messages
class OfflineEmailPermissionDialog extends StatelessWidget {
  const OfflineEmailPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SizedBox(
        width: 288.w,
        height: ResponsiveDesignOrientation.isLandscape ? 500.h : 320.h,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/icon/chat-text.svg',
                  width: 54.w,
                  height: ResponsiveDesignOrientation.isLandscape ? 84.h : 54.h,
                ),
                SizedBox(height: 16.h),
                Text(
                  'offline_email_permission.unable_to_change_password'
                      .tr(), //ไม่สามารถแก้ไขรหัสผ่านได้ เนื่องจาก การเข้าถึงอีเมลของคุณถูกปิด กรุณา เปิดการอนุญาตให้เข้าถึงอีเมลที่เมนู ความปลอดภัย เพื่อดำเนินการต่อ
                  style: GoogleFonts.prompt(
                    fontSize:
                        ResponsiveDesignOrientation.isLandscape ? 12.sp : 16.sp,
                    fontWeight: FontWeight.w600,
                    color: kDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                GradientTextButton(
                  text: 'offline_email_permission.understood'.tr(), //เข้าใจแล้ว
                  onPressed: () {
                    // Close Offline Email Permission Dialog
                    context.pop();
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
