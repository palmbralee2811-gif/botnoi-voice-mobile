import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// LINE Provider and interface for authentication
class LineLoginProvider with ChangeNotifier {
  String? _userId;
  String? _displayName;
  String? _profilePictureUrl;
  String? _idTokenRaw;
  String? _lineEmail;

  final Logger _logger = Logger(); // For debugging

  // Check if the user is logged in
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  bool get isAuthenticated => _userId != null;

  /// Sign in with LINE Service
  Future<void> signInWithLine() async {
    try {
      final loginResult =
          await LineSDK.instance.login(scopes: ["profile", "openid", "email"]);

      _idTokenRaw = loginResult.accessToken.idTokenRaw;
      _lineEmail = loginResult.accessToken.email;
      _isLoggedIn = true;
      await _getProfile();
      notifyListeners(); // Notify listeners only once when login state changes
    } on PlatformException catch (e, stackTrace) {
      _logger.e('Login Error: ${e.message}', error: e, stackTrace: stackTrace);
    }
  }

  /// Sign out with LINE Service
  Future<void> signOutWithLine(BuildContext context) async {
    try {
      Provider.of<LineTokenProvider>(context, listen: false).clearTokens();
      await LineSDK.instance.logout();
      _resetUserData();
      _logger.i("User signed out successfully.");
    } on PlatformException catch (e, stackTrace) {
      _logger.e('Logout failed: ${e.message}',
          error: e, stackTrace: stackTrace);
    }
  }

  /// Reset user data and notify listeners
  void _resetUserData() {
    _userId = null;
    _displayName = null;
    _profilePictureUrl = null;
    _idTokenRaw = null;
    _lineEmail = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  /// Get LINE user profile
  Future<void> _getProfile() async {
    try {
      final profileResult = await LineSDK.instance.getProfile();
      _userId = profileResult.userId;
      _displayName = profileResult.displayName;
      _profilePictureUrl = profileResult.pictureUrl;
      notifyListeners();
    } on PlatformException catch (e, stackTrace) {
      _logger.e('getProfile failed: ${e.message}',
          error: e, stackTrace: stackTrace);
    }
  }

  /// Get LINE ID Token Raw
  String? get getIdTokenRaw => _idTokenRaw;

  /// Get LINE user id from Get Profile Function
  String? get getUserId => _userId;

  /// Get LINE user display name from Get Profile Function
  String? get getDisplayName => _displayName;

  /// Get LINE user profile picture url from Get Profile Function
  String? get getProfilePictureUrl => _profilePictureUrl;

  /// Get LINE user email from Get Profile Function
  String? get getLineEmail => _lineEmail;
}
