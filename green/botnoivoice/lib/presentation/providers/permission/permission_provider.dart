import 'dart:io';
import 'package:botnoivoice/presentation/providers/logger/logger_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Provider Permission For Android
class PermissionProvider with ChangeNotifier {
  Future<bool> requestAndroidPermission(BuildContext context) async {
    final logger = Provider.of<LoggerProvider>(context, listen: false).logger;

    try {
      if (Platform.isAndroid) {
        // Get Android OS Version Info
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        int androidVersion = androidInfo.version.sdkInt; // Check API level

        logger.d("Android version: $androidVersion");

        if (androidVersion >= 33) { // Android 13 is API level 33
          logger.d("Requesting permissions for Android 13+");
          return await _requestPermissionsForAndroid13Plus(context);
        } else {
          logger.d("Requesting permissions for older Android versions");
          return await _requestPermissionsForOlderVersions(context);
        }
      }
    } catch (e, stackTrace) {
      logger.e("Error requesting permissions", error: e, stackTrace: stackTrace);
    }
    return false; // Permissions were not granted
  }

  /// Android 13 (API 33) and higher
  Future<bool> _requestPermissionsForAndroid13Plus(BuildContext context) async {
    final logger = Provider.of<LoggerProvider>(context, listen: false).logger;

    Map<Permission, PermissionStatus> statuses = await [
      Permission.audio,
      Permission.notification,
    ].request();

    bool allPermissionsGranted = statuses.values.every((status) => status.isGranted);

    if (!allPermissionsGranted) {
      logger.w("Not all permissions were granted for Android 13+");
      return false;
    }

    logger.i("All permissions granted for Android 13+");
    return true;
  }

  /// Below Android 13 (API 33)
  Future<bool> _requestPermissionsForOlderVersions(BuildContext context) async {
    final logger = Provider.of<LoggerProvider>(context, listen: false).logger;

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    bool allPermissionsGranted = statuses.values.every((status) => status.isGranted);

    if (!allPermissionsGranted) {
      logger.w("Not all permissions were granted for older Android versions");
      return false;
    }

    logger.i("All permissions granted for older Android versions");
    return true;
  }
}
