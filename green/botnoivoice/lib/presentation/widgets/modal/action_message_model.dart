import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// Action Modal for when click on button and need to Sign Out or go to Login Screen
class ActionMessageModal {
  ActionMessageModal(
      {required this.context, required this.text, required this.onPressed});

  final String text;
  final BuildContext context;
  final VoidCallback onPressed;

  void showCheckmarkModalWithAction(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false, // ป้องกันการปิดด้วยการแตะด้านนอก
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
                    SvgPicture.asset(
                      'assets/images/icon/checkmark-modal.svg',
                      height: 54.h,
                      width: 54.w,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center, // ทำให้ข้อความอยู่ตรงกลาง
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          onPressed(); // ตรวจสอบว่า widget ยังคง mounted อยู่
                        }
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.close),
                          SizedBox(width: 8),
                          Text("ปิด"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  /// show error modal and go to email login screen
  void showErrorModalWithAction(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิดโดยการแตะด้านนอก
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
                  Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                    size: 54.h,
                  ),
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
                  ElevatedButton(
                    onPressed: onPressed,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close),
                        SizedBox(width: 8),
                        Text("ปิด"),
                      ],
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
}
