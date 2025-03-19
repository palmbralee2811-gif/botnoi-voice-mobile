import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/style/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RowLoginIconWidget extends StatelessWidget {
  final bool isEmailLoggedIn;
  final bool isLineLoggedIn;
  final bool isGoogleLoggedIn;
  final bool isAppleLoggedIn;

  const RowLoginIconWidget({
    super.key,
    required this.isEmailLoggedIn,
    required this.isLineLoggedIn,
    required this.isGoogleLoggedIn,
    required this.isAppleLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // จัดข้อความและไอคอนให้อยู่ในแนวเดียวกัน
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'account.login_with'.tr(), //เข้าสู่ระบบด้วย
          style: GoogleFonts.prompt(
            fontSize: ResponsiveDesignOrientation.isLandscape ? 10.sp : 14.sp,
            fontWeight: FontWeight.w600,
            color: kDark,
          ),
        ),
        SizedBox(
            width: ResponsiveDesignOrientation.isLandscape
                ? 50.w
                : 25.w), // ระยะห่างระหว่างข้อความและไอคอน
        SvgPicture.asset(
          'assets/images/auth_screen/email-icon.svg',
          width: ResponsiveDesignOrientation.isLandscape ? 40.w : 20.w,
          height: ResponsiveDesignOrientation.isLandscape ? 40.h : 20.h,
          colorFilter: isEmailLoggedIn
              ? null
              : ColorFilter.mode(
                  kLightGrey,
                  BlendMode.srcIn,
                ), // ใช้ colorFilter แทน color
        ),
        SizedBox(width: ResponsiveDesignOrientation.isLandscape ? 10.w : 10.w),
        Container(
          width: ResponsiveDesignOrientation.isLandscape ? 42.w : 32.w,
          height: ResponsiveDesignOrientation.isLandscape ? 42.h : 32.h,
          decoration: BoxDecoration(
            color: isLineLoggedIn
                ? kGreen
                : kLightGrey, // เปลี่ยนเป็นสีเทาถ้าไม่ใช่ LINE
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            // ทำให้ไอคอนอยู่ตรงกลาง
            child: SvgPicture.asset(
              'assets/images/auth_screen/line-icon.svg',
              width: ResponsiveDesignOrientation.isLandscape
                  ? 34.w
                  : 24.w, // ปรับขนาดไอคอนให้เล็กลง
              height: ResponsiveDesignOrientation.isLandscape
                  ? 34.h
                  : 24.h, // ปรับขนาดไอคอนให้เล็กลง
              fit: BoxFit.contain, // ทำให้ไอคอนถูกย่อให้พอดีกับพื้นที่ที่กำหนด
            ),
          ),
        ),
        SizedBox(width: ResponsiveDesignOrientation.isLandscape ? 10.w : 10.w),
        SvgPicture.asset(
          'assets/images/auth_screen/google-icon.svg',
          width: ResponsiveDesignOrientation.isLandscape ? 42.w : 32.w,
          height: ResponsiveDesignOrientation.isLandscape ? 42.h : 32.h,
          colorFilter: isGoogleLoggedIn
              ? null
              : ColorFilter.mode(
                  kLightGrey,
                  BlendMode.srcIn,
                ), // ใช้ colorFilter แทน color
        ),
        SizedBox(width: ResponsiveDesignOrientation.isLandscape ? 10.w : 10.w),
        SvgPicture.asset(
          'assets/images/auth_screen/apple-icon.svg',
          width: ResponsiveDesignOrientation.isLandscape ? 52.w : 32.w,
          height: ResponsiveDesignOrientation.isLandscape ? 52.h : 32.h,
          colorFilter: isAppleLoggedIn
              ? null
              : ColorFilter.mode(
                  kLightGrey,
                  BlendMode.srcIn,
                ), // ใช้ colorFilter แทน color
        ),
      ],
    );
  }
}
