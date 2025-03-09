import 'package:botnoivoice/ui/style/style.dart';
import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// Alert Modal for displaying messages
class EnableEmailPermissionDialog extends StatelessWidget {
  const EnableEmailPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: SizedBox(
        width: 288.w,
        height: ResponsiveDesignOrientation.isLandscape ? 500.h : 250.h,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/icon/chat-text.svg',
                  width: ResponsiveDesignOrientation.isLandscape ? 74.w : 54.w,
                  height: ResponsiveDesignOrientation.isLandscape ? 74.h : 54.h,
                ),
                SizedBox(height: 16.h),
                Text(
                  'enable_email_permission.email_used'
                      .tr(), //เราได้ใช้อีเมลเดิมที่คุณเคยให้ไว้หากต้องการเปลี่ยนแปลงอีเมลกรุณาไปที่บัญชีของฉัน
                  style: GoogleFonts.prompt(
                    fontSize:
                        ResponsiveDesignOrientation.isLandscape ? 12.sp : 16.sp,
                    fontWeight: FontWeight.w600,
                    color: kDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 34.h : 24.h),
                GradientTextButton(
                  text: 'enable_email_permission.understood'.tr(), //เข้าใจแล้ว
                  onPressed: () async {
                    await Provider.of<CheckUserIsShowEmail>(context,
                            listen: false)
                        .updateUserInfoShowMail(context, true);
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
