import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Alert Modal for displaying messages
class NotificationDialog {
  NotificationDialog({
    required this.context,
    required this.text,
    this.onPressed, // กำหนด onPressed เป็น optional
  });

  final String text;
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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(32.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  SizedBox(height: 16.h),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w, right: 30.w),
                    child: GradientTextButton(
                      text: 'notification.close'.tr(), //ปิด
                      onPressed: () {
                        Navigator.of(context).pop(); // ปิด dialog
                        (onPressed ??
                            () {})(); // เรียก onPressed หากมีค่า ไม่เช่นนั้นไม่ทำอะไร
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Modal for error message
  void showErrorModal(BuildContext context) {
    _showModal(
      context: context,
      icon: Icon(
        Icons.error_outline_rounded,
        color: Colors.red,
        size: 54.h,
      ),
      barrierDismissible: true,
      onPressed: onPressed,
    );
  }

  /// Modal for error message with action
  void showErrorModalWithAction(BuildContext context) {
    _showModal(
      context: context,
      icon: Icon(
        Icons.error_outline_rounded,
        color: Colors.red,
        size: 54.h,
      ),
      barrierDismissible: false,
      onPressed: onPressed,
    );
  }

  /// Modal for success message
  void showCheckmarkModal(BuildContext context) {
    _showModal(
      context: context,
      icon: SvgPicture.asset(
        'assets/images/icon/checkmark-modal.svg',
        height: 54.h,
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
        height: 54.h,
        width: 54.w,
      ),
      barrierDismissible: false,
      onPressed: onPressed,
    );
  }

  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 10),
      ),
    );
  }

  void showSnackBarWithAction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Dowload File Successfully'),
        action: SnackBarAction(
          label: 'OPEN',
          onPressed: onPressed ?? () {},
        ),
        duration: const Duration(seconds: 15),
      ),
    );
  }
}
