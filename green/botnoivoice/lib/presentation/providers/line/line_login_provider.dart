import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// LINE Provider and interface for authentication
class LineLoginProvider with ChangeNotifier {
  String? userId;
  String? displayName;
  String? profilePictureUrl;
  String? idTokenRaw;

  final Logger logger = Logger();

  bool get isAuthenticated {
    return userId != null;
  }

  /// Sign in with LINE Provider
  Future<void> signInWithLine() async {
    try {
      final result =
          await LineSDK.instance.login(scopes: ["profile", "openid", "email"]);

      final accessToken = result.accessToken.value;
      idTokenRaw = result.accessToken.idTokenRaw;
      logger.i("Access Token: $accessToken");
      logger.i("ID Token Raw: $idTokenRaw");

      await getProfile();
      notifyListeners(); // แจ้งให้ UI ทราบว่ามีการเปลี่ยนแปลงข้อมูล
    } on PlatformException catch (e, stackTrace) {
      logger.e('Login Error: $e', error: e, stackTrace: stackTrace);
      notifyListeners();
    }
  }

  /// LINE Get ID Token Raw
  Future<String?> getIdTokenRaw() async {
    if (idTokenRaw == null) return null;
    return idTokenRaw;
  }

  /// LINE Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      Provider.of<LineTokenProvider>(context, listen: false).clearTokens();
      await LineSDK.instance.logout();
      userId = null;
      displayName = null;
      profilePictureUrl = null;
      idTokenRaw = null;
      logger.i("User signed out successfully.");
      notifyListeners();
    } on PlatformException catch (e, stackTrace) {
      logger.e('Logout failed: $e', error: e, stackTrace: stackTrace);
    }
  }

  /// LINE Get user profile
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

  /// LINE Get access token and verify
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
}
