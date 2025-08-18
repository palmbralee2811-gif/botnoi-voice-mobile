import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Alert Modal for displaying messages
class RedeemSuccessDialog {
  RedeemSuccessDialog({
    required this.context,
    required this.text,
    required this.couponName,
    this.onPressed, // กำหนด onPressed เป็น optional
  });

  final String text;
  final String couponName;
  final BuildContext context;
  final VoidCallback? onPressed;

  /// ฟังก์ชันที่ใช้สร้าง UI ของ modal
  void _showModal({
    required BuildContext context,
    required Widget icon,
    required bool barrierDismissible,
    VoidCallback? onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        String languageCode = Localizations.localeOf(context).languageCode;

        double dialogHeight;
        if (languageCode == 'en') {
          dialogHeight =
              ResponsiveDesignOrientation.isLandscape ? 500.h : 310.h;
        } else {
          dialogHeight =
              ResponsiveDesignOrientation.isLandscape ? 410.h : 235.h;
        }

        final parts = text.split(couponName);

        Widget content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(height: 16.h),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: ResponsiveDesignOrientation.isLandscape ? 14.sp : 16.sp,),
                children: [
                  TextSpan(
                    text: parts[0], // "Coupon ", "คูปอง ", or "Kupon "
                    style: const TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: couponName,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: parts[
                        1], // " redeemed successfully", " แลกสำเร็จ", or " berhasil ditukarkan"
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
                height: ResponsiveDesignOrientation.isLandscape ? 56.h : 16.h),
            Padding(
              padding: EdgeInsets.only(left: 30.w, right: 30.w),
              child: GradientTextButton(
                text: 'notification.close'.tr(), // Close
                onPressed: () {
                  // Close This Notification Dialog
                  context.pop();

                  // Call onPressed if provided
                  (onPressed ?? () {})();
                },
              ),
            ),
          ],
        );

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: SizedBox(
            height: dialogHeight,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(32.r),
                child: content,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Modal for success message
  void showCheckmarkModal(BuildContext context) {
    _showModal(
      context: context,
      icon: SvgPicture.asset(
        'assets/images/icon/checkmark-modal.svg',
        height: ResponsiveDesignOrientation.isLandscape ? 84.h : 54.h,
        width: 54.w,
      ),
      barrierDismissible: true,
      onPressed: onPressed,
    );
  }

  /// Modal for success message with action
  void showCheckmarkModalWithAction(BuildContext context) {
    _showModal(
      context: context,
      icon: SvgPicture.asset(
        'assets/images/icon/checkmark-modal.svg',
        height: ResponsiveDesignOrientation.isLandscape ? 84.h : 54.h,
        width: 54.w,
      ),
      barrierDismissible: false,
      onPressed: onPressed,
    );
  }
}