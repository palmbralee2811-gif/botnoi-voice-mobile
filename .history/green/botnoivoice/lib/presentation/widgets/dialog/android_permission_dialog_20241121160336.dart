import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class AndroidPermissionDialog {
  AndroidPermissionDialog({
    required this.context,
    required this.text,
  });

  final String text;
  final BuildContext context;

  /// Show permission denied dialog
  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'app_drawer.permission_denied'.tr(), //สิทธิ์ถูกปฏิเสธ
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'app_drawer.go_to_settings_to_enable_permission'.tr(), //กรุณาไปที่การตั้งค่าเพื่อเปิดสิทธิ์การเข้าถึงไฟล์.
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: TextButton(
              onPressed: () {
                openAppSettings(); // Redirect to app settings
                Navigator.of(context).pop();
              },
              child: Text(
                'app_drawer.go_to_settings_page'.tr(), //ไปหน้าตั้งค่า
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "ยกเลิก", //ยกเลิก
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
