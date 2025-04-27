import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

/// Android Open App Settings Dialog
class OpenAppSettingsDialog {
  OpenAppSettingsDialog({
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
          'android_permission.permission_denied'.tr(), //สิทธิ์ถูกปฏิเสธ
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'android_permission.go_to_settings_to_enable_permission'
              .tr(), //กรุณาไปที่การตั้งค่าเพื่อเปิดสิทธิ์การเข้าถึงไฟล์.
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: TextButton(
              onPressed: () {
                // Redirect to app settings
                openAppSettings();
              },
              child: Text(
                'android_permission.go_to_settings_page'.tr(), //ไปหน้าตั้งค่า
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: TextButton(
              onPressed: () {
                // Close Android Open App Settings Dialog
                context.pop();
              },
              child: Text(
                'android_permission.cancel'.tr(), //ยกเลิก
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
