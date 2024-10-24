import 'package:botnoivoice/presentation/screens/email/email_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

/// Alert Modal for error message
class AlertMessageModal {
  AlertMessageModal({required this.context, required this.text});

  final String text;
  final BuildContext context;

  /// Error Modal for failed
  void showErrorModal(BuildContext context) {
    showDialog(
        context: context,
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
                      textAlign: TextAlign.center, // ทำให้ข้อความอยู่ตรงกลาง
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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

  /// Checkmark Modal for successfully
  void showCheckmarkModal(BuildContext context) {
    showDialog(
        context: context,
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
                        Navigator.of(context).pop(); // ปิด Dialog
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

  /// show checkmark modal and go to email login screen
  void showCheckmarkModalWithLogin(BuildContext context) {
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
                        Navigator.of(context).pop(); // ปิด Dialog
                        _navigateToEmailLoginScreen(context); // ไปหน้า Login
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
  void showErrorModalWithLogin(BuildContext context) {
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
                    onPressed: () {
                      Navigator.of(context).pop(); // ปิด Dialog
                      _navigateToEmailLoginScreen(context); // ไปหน้า Login
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
      },
    );
  }

  /// Navigate to email login screen
  void _navigateToEmailLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EmailLoginScreen()),
    );
  }
}
