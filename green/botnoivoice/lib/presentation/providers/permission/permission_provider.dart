import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider with ChangeNotifier {
  Future<bool> requestAndroidPermission() async {
    try {
      if (Platform.isAndroid) {
        // ตรวจสอบเวอร์ชันของ Android
        if (Platform.isAndroid && Platform.version.compareTo("13") >= 0) {
          // Android 13 (API 33) และสูงกว่า
          return await _requestPermissionsForAndroid13Plus();
        } else if (Platform.isAndroid && Platform.version.compareTo("11") >= 0) {
          // Android 11 (API 30) ถึง 12 (API 32)
          return await _requestPermissionsForAndroid11To12();
        } else {
          // Android เวอร์ชัน 10 (API 29) และต่ำกว่า
          return await _requestPermissionsForOlderVersions();
        }
      }
    } catch (e) {
      debugPrint("Error requesting permissions: $e");
    }
    return false; // Permissions were not granted
  }

  // สำหรับ Android 13 (API 33) และสูงกว่า
  Future<bool> _requestPermissionsForAndroid13Plus() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.audio, // สำหรับ Android 13+
      Permission.notification, // สำหรับ Android 13+
    ].request();

    bool allPermissionsGranted = statuses.values.every((status) => status.isGranted);

    if (!allPermissionsGranted) {
      debugPrint("Not all permissions were granted for Android 13+");
      return false;
    }

    return true;
  }

  // สำหรับ Android 11 (API 30) ถึง Android 12 (API 32)
  Future<bool> _requestPermissionsForAndroid11To12() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage, // สำหรับการเข้าถึงไฟล์
      Permission.manageExternalStorage, // Android 11+ requires MANAGE_EXTERNAL_STORAGE
    ].request();

    bool allPermissionsGranted = statuses.values.every((status) => status.isGranted);

    if (!allPermissionsGranted) {
      debugPrint("Not all permissions were granted for Android 11 to 12");
      return false;
    }

    return true;
  }

  // สำหรับ Android 10 (API 29) และต่ำกว่า
  Future<bool> _requestPermissionsForOlderVersions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage, // สำหรับการเข้าถึงไฟล์ใน Android 10 และต่ำกว่า
    ].request();

    bool allPermissionsGranted = statuses.values.every((status) => status.isGranted);

    if (!allPermissionsGranted) {
      debugPrint("Not all permissions were granted for older Android versions");
      return false;
    }

    return true;
  }
}
