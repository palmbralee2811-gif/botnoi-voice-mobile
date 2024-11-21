import 'package:botnoivoice/presentation/constants/color.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
        height: 250.h,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/icon/chat-text.svg',
                  width: 54.w,
                  height: 54.h,
                ),
                SizedBox(height: 16.h),
                Text(
                  'เราได้ใช้อีเมลเดิมที่คุณเคยให้ไว้หากต้องการเปลี่ยนแปลงอีเมลกรุณาไปที่บัญชีของฉัน', //
                  style: GoogleFonts.prompt(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: kDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                GradientTextButton(
                  text: 'เข้าใจแล้ว',
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
