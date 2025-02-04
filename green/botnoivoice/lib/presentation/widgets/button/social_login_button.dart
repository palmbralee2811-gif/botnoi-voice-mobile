import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

/// ปุ่มล็อกอินสำหรับ Social Media (Apple, Google, Line, Email)
/// สามารถกำหนดสีพื้นหลัง, สีข้อความ, ไอคอน และข้อความได้ตามต้องการ
class SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String iconPath;
  final String buttonText;
  final Color? borderColor;
  final Color? iconColor; //  สีไอคอน (ใช้เฉพาะปุ่มที่ต้องเปลี่ยนสี)

  const SocialLoginButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor, // สีพื้นหลังของปุ่ม
    required this.textColor, // สีข้อความของปุ่ม
    required this.iconPath, // ไอคอนปุ่ม
    required this.buttonText, // ข้อความบนปุ่ม
    this.borderColor, // เส้นขอบ (ถ้ามี)
    this.iconColor, //  ใช้สีไอคอน (เฉพาะบางปุ่ม)
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.zero,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor, //  สีพื้นหลังของปุ่ม
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r), //  มุมโค้งของปุ่ม
              side: borderColor != null
                  ? BorderSide(color: borderColor!, width: 1.0) //  เส้นขอบ (ถ้ามี)
                  : BorderSide.none,
            ),
            padding: EdgeInsets.zero,
            minimumSize: OrientationHelper.isLandscape
                ? Size(224.w, 88.h) //  ขนาดปุ่มแนวนอน
                : Size(224.w, 48.h), //  ขนาดปุ่มแนวตั้ง
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///  เงื่อนไข: ถ้า `iconColor` ไม่เป็น `null` ให้ใช้ `ColorFiltered`
              if (iconColor != null)
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    iconColor!, // ใช้สีที่กำหนด (เฉพาะปุ่มที่ต้องเปลี่ยน)
                    BlendMode.srcIn,
                  ),
                  child: SvgPicture.asset(
                    iconPath,
                    height: OrientationHelper.isLandscape ? 32.h : 24.h,
                    width: OrientationHelper.isLandscape ? 32.w : 24.w,
                  ),
                )
              else
                SvgPicture.asset(
                  iconPath,
                  height: OrientationHelper.isLandscape ? 32.h : 24.h,
                  width: OrientationHelper.isLandscape ? 32.w : 24.w,
                ),

              SizedBox(width: OrientationHelper.isLandscape ? 12.w : 16.w),

              ///  ข้อความที่รองรับ `.tr()` สำหรับการแปลภาษา
              Text(
                buttonText.tr(),
                style: TextStyle(
                  fontSize: OrientationHelper.isLandscape ? 9.sp : 12.sp,
                  color: textColor,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
