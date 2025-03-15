import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Android Permission
class AndroidPermission with ChangeNotifier {
  final Logger _logger = Logger();

  Future<bool> requestAndroidPermission() async {
    try {
      if (Platform.isAndroid) {
        // Get Android OS Version Info
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        int androidVersion = androidInfo.version.sdkInt; // Check API level

        _logger.d("Android version: $androidVersion");

        if (androidVersion >= 33) {
          // Android 13 is API level 33
          _logger.d("Requesting permissions for Android 13+");
          return await _requestPermissionsForAndroid13Plus();
        } else {
          _logger.d("Requesting permissions for older Android versions");
          return await _requestPermissionsForOlderVersions();
        }
      }
    } catch (e, stackTrace) {
      _logger.e("Error requesting permissions",
          error: e, stackTrace: stackTrace);
    }
    return false; // Permissions were not granted
  }

  /// Android 13 (API 33) and higher
  Future<bool> _requestPermissionsForAndroid13Plus() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.audio,
      Permission.notification,
    ].request();

    bool allPermissionsGranted =
        statuses.values.every((status) => status.isGranted);

    if (!allPermissionsGranted) {
      _logger.w("Not all permissions were granted for Android 13+");
      return false;
    }

    _logger.i("All permissions granted for Android 13+");
    return true;
  }

  /// Below Android 13 (API 33)
  Future<bool> _requestPermissionsForOlderVersions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    bool allPermissionsGranted =
        statuses.values.every((status) => status.isGranted);

    if (!allPermissionsGranted) {
      _logger.w("Not all permissions were granted for older Android versions");
      return false;
    }

    _logger.i("All permissions granted for older Android versions");
    return true;
  }
}
