import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart'; // Import Logger

/// Provider and interface for authentication
class LineLoginProvider with ChangeNotifier {
  String? userId;
  String? displayName;
  String? profilePictureUrl;

  final Logger logger = Logger(); // สร้าง Logger instance

  /// Sign in with Line and update the user
  Future<void> signIn(BuildContext context) async {
    try {
      final result = await LineSDK.instance.login();
      logger.i("Login result: $result");
      notifyListeners(); // แจ้งให้ UI ทราบว่ามีการเปลี่ยนแปลงข้อมูล
    } on PlatformException catch (e, stackTrace) {
      logger.e('Login Error: $e', error: e, stackTrace: stackTrace);
      notifyListeners();
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await LineSDK.instance.logout();
      userId = null;
      displayName = null;
      profilePictureUrl = null;
      logger.i("User signed out successfully.");
      notifyListeners();
    } on PlatformException catch (e, stackTrace) {
      logger.e('Logout failed: $e', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> getProfile() async {
    try {
      final result = await LineSDK.instance.getProfile();
      userId = result.userId;
      displayName = result.displayName;
      profilePictureUrl = result.pictureUrl;
      logger.d('userId: $userId');
      logger.d('displayName: $displayName');
      logger.d('profilePictureUrl: $profilePictureUrl');
      notifyListeners();
    } on PlatformException catch (e, stackTrace) {
      logger.e('getProfile failed: $e', error: e, stackTrace: stackTrace);
      notifyListeners();
    }
  }

  Future<String?> getAccessToken() async {
    try {
      final result = await LineSDK.instance.currentAccessToken;
      logger.d("Access Token: ${result?.value}");
      return result?.value;
    } on PlatformException catch (e, stackTrace) {
      logger.e('Error fetching access token: $e',
          error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> getVerifyAccessToken() async {
    try {
      final result = await LineSDK.instance.verifyAccessToken();
      logger.d('Token is valid: ${result.data}');
    } on PlatformException catch (e, stackTrace) {
      logger.e('Invalid Token: $e', error: e, stackTrace: stackTrace);
    }
  }
}
