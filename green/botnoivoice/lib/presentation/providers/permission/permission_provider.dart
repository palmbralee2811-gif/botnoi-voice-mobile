import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Provider Permission For Android 6 to Android 13+.
class PermissionProvider with ChangeNotifier {
  Future<bool> requestAndroidPermission() async {
    try {
      if (Platform.isAndroid) {
        if (Platform.isAndroid && Platform.version.compareTo("13") >= 0) {
          return await _requestPermissionsForAndroid13Plus();
        } else if (Platform.isAndroid && Platform.version.compareTo("11") >= 0) {
          return await _requestPermissionsForAndroid11To12();
        } else {
          return await _requestPermissionsForOlderVersions();
        }
      }
    } catch (e) {
      debugPrint("Error requesting permissions: $e");
    }
    return false; // Permissions were not granted
  }

  /// Android 13 (API 33) and higher
  Future<bool> _requestPermissionsForAndroid13Plus() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.audio,
      Permission.notification,
    ].request();

    bool allPermissionsGranted = statuses.values.every((status) => status.isGranted);

    if (!allPermissionsGranted) {
      debugPrint("Not all permissions were granted for Android 13+");
      return false;
    }

    return true;
  }

  /// Android 11 (API 30) to Android 12 (API 32)
  Future<bool> _requestPermissionsForAndroid11To12() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();

    bool allPermissionsGranted = statuses.values.every((status) => status.isGranted);

    if (!allPermissionsGranted) {
      debugPrint("Not all permissions were granted for Android 11 to 12");
      return false;
    }

    return true;
  }

  /// Android 10 (API 29) and older
  Future<bool> _requestPermissionsForOlderVersions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    bool allPermissionsGranted = statuses.values.every((status) => status.isGranted);

    if (!allPermissionsGranted) {
      debugPrint("Not all permissions were granted for older Android versions");
      return false;
    }

    return true;
  }
}
