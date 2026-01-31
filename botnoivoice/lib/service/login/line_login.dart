import 'package:botnoivoice/service/notification/push_notification_service.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Define the state for LineLogin.
class LineLoginState {
  final String? userId;
  final String? displayName;
  final String? profilePictureUrl;
  final String? idTokenRaw;
  final String? lineEmail;
  final bool isLoggedIn;

  LineLoginState({
    this.userId,
    this.displayName,
    this.profilePictureUrl,
    this.idTokenRaw,
    this.lineEmail,
    this.isLoggedIn = false,
  });

  /// Copy method for creating a new state instance.
  LineLoginState copyWith({
    String? userId,
    String? displayName,
    String? profilePictureUrl,
    String? idTokenRaw,
    String? lineEmail,
    bool? isLoggedIn,
  }) {
    return LineLoginState(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      idTokenRaw: idTokenRaw ?? this.idTokenRaw,
      lineEmail: lineEmail ?? this.lineEmail,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

/// LINE Login and interface for authentication using Riverpod StateNotifier.
class LineLoginNotifier extends StateNotifier<LineLoginState> {
  final Logger _logger = Logger(); // For debugging

  LineLoginNotifier() : super(LineLoginState());

  /// Reset user data and state to initial values
  void _resetUserData() {
    state = LineLoginState();
  }

  /// Get LINE user profile
  Future<void> _getProfile() async {
    try {
      final profileResult = await LineSDK.instance.getProfile();
      state = state.copyWith(
        userId: profileResult.userId,
        displayName: profileResult.displayName,
        profilePictureUrl: profileResult.pictureUrl,
      );
    } on PlatformException catch (e, stackTrace) {
      _logger.e('getProfile failed: ${e.message}',
          error: e, stackTrace: stackTrace);
    }
  }

  /// Sign in with LINE Service
  Future<void> signInWithLine() async {
    try {
      final loginResult =
          await LineSDK.instance.login(scopes: ["profile", "openid", "email"]);
      
      // Update state with token and email from login result
      state = state.copyWith(
        idTokenRaw: loginResult.accessToken.idTokenRaw,
        lineEmail: loginResult.accessToken.email,
        isLoggedIn: true,
      );
      
      // Fetch and update profile data
      await _getProfile();
      
      _logger.d("LINE Account User UID: ${state.idTokenRaw}");
      _logger.i("User signed in with LINE successfully.");
    } on PlatformException catch (e, stackTrace) {
      _logger.e('Login Error: ${e.message}', error: e, stackTrace: stackTrace);
      // Ensure login state is false on error
      _resetUserData();
    }
  }

  /// Sign out with LINE Service
  Future<void> signOutWithLine(WidgetRef ref) async {
    try {
      // Clear tokens using Riverpod ref
      ref.read(lineTokenNotifierProvider.notifier).clearTokens();

      // ❌ Unsubscribe from Topic when user sign out
      await PushNotificationService.unsubscribeFromTopic("default");
      // ❌ Delete FCM Token Form Firebase Messaging and Database
      await PushNotificationService.deleteFcmToken();

      await LineSDK.instance.logout();
      _resetUserData();
      _logger.i("User signed out successfully.");
    } on PlatformException catch (e, stackTrace) {
      _logger.e('Logout failed: ${e.message}',
          error: e, stackTrace: stackTrace);
    }
  }
}

/// Riverpod provider for LineLoginNotifier.
final lineLoginNotifierProvider = StateNotifierProvider<LineLoginNotifier, LineLoginState>((ref) {
  return LineLoginNotifier();
});