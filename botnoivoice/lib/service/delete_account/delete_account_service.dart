// import 'package:botnoivoice/config/api_url_config.dart';
// import 'package:botnoivoice/shared/dialog/notification/notification_snack_bar.dart';
// import 'package:botnoivoice/screen/drawer/account/get_user_email.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// /// ***DO NOT DELETE THIS TEXT FOR ANY REASON***
// ///
// /// *Delete Account for Email/Password and Apple Sign-In*
// ///
// /// 3 Steps to Delete Account:
// /// 1. Verify User Password or Apple Sign-In.
// /// 2. Delete User Data from Database (MongoDB).
// /// 3. Delete User Account from Firebase.
// ///
// /// ***WARNING***
// /// - Deleting a Firebase account removes it from all environments (Staging & Production).
// class DeleteAccountService with ChangeNotifier {
//   String? _errorMessage;
//   final Logger _logger = Logger();

//   /// Getter for error message
//   String? get errorMessage => _errorMessage;

//   /// Checks if the user is logged in with a supported provider (Email/Password or Apple).
//   bool isSupportedProviderUser(User? user) {
//     return user?.providerData.any((info) =>
//             info.providerId == 'password' || info.providerId == 'apple.com') ??
//         false;
//   }

//   /// Verifies the user's credentials before account deletion.
//   Future<bool> verifyCredentials(String? password, String providerId) async {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null || !isSupportedProviderUser(user)) {
//       _setError(
//           'delete_account_provider.not_logged_in_with_supported_provider'.tr());
//       return false;
//     }

//     try {
//       if (providerId == 'password') {
//         if (password == null || password.isEmpty) {
//           _setError('delete_account_provider.password_required'
//               .tr()); // แจ้งว่าต้องใส่รหัสผ่าน
//           return false;
//         }

//         await user.reauthenticateWithCredential(
//           EmailAuthProvider.credential(email: user.email!, password: password),
//         );
//       } else if (providerId == 'apple.com') {
//         try {
//           final appleCredential = await SignInWithApple.getAppleIDCredential(
//             scopes: [
//               AppleIDAuthorizationScopes.email,
//               AppleIDAuthorizationScopes.fullName
//             ],
//           );

//           if (appleCredential.identityToken == null ||
//               appleCredential.authorizationCode.isEmpty) {
//             // แจ้งว่าการยืนยันตัวตนล้มเหลว
//             _setError('delete_account_provider.apple_auth_failed'.tr());
//             return false;
//           }

//           final credential = OAuthProvider('apple.com').credential(
//             idToken: appleCredential.identityToken,
//             accessToken: appleCredential.authorizationCode,
//           );

//           await user.reauthenticateWithCredential(credential);
//         } on SignInWithAppleAuthorizationException catch (e) {
//           if (e.code == AuthorizationErrorCode.canceled) {
//             // แจ้งว่าผู้ใช้ยกเลิกการเข้าสู่ระบบ
//             _setError('delete_account_provider.apple_signin_canceled'.tr());
//             _logger.w("User canceled Apple Sign-In.");
//             return false;
//           } else {
//             // แจ้งว่าการยืนยันตัวตนล้มเหลว
//             _setError('delete_account_provider.apple_auth_failed'.tr());
//             _logger.e("Apple Sign-In failed: ${e.message}");
//             return false;
//           }
//         }
//       } else {
//         _setError('DO NOT SUPPORT (Only Email/Password and Apple Account)');
//         return false;
//       }

//       _clearError();
//       return true;
//     } on FirebaseAuthException catch (error) {
//       _handleAuthException(error);
//       return false;
//     } catch (error) {
//       _setError(
//           '${'delete_account_provider.error_confirming_password'.tr()} $error');
//       _logger.e("Unexpected error during authentication: $error");
//       return false;
//     }
//   }

//   /// ฟังก์ชันลบข้อมูลในฐานข้อมูล
//   ///
//   /// **API to Delete User Account in Database**
//   ///
//   /// - Supports: Email/Password and Apple Sign In.**
//   /// - API Method: DELETE
//   /// - Database: Studio 3T MongoDB.
//   Future<void> deleteUserDataFromDatabase() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null || !isSupportedProviderUser(user)) {
//       _setError(
//           'delete_account_provider.not_logged_in_with_supported_provider'.tr());
//       return;
//     }

//     final url = '$apiUrl/db/dashboard/users/${user.uid}';
//     final headers = {'Content-Type': 'application/json'};

//     try {
//       final response = await http.delete(Uri.parse(url), headers: headers);
//       if (response.statusCode == 200) {
//         _clearError();

//         _logger.d(
//             "User data deleted from Database: \nUser UID: ${user.uid}. \nEmail: ${getUserEmail(user)}");
//       } else {
//         _setError(
//             '${'delete_account_provider.unable_to_delete_account_status_code'.tr()} ${response.statusCode}');
//       }
//     } catch (error) {
//       _setError(
//           '${'delete_account_provider.error_deleting_account'.tr()} $error');
//     }
//   }

//   /// Deletes the user's Firebase account.
//   Future<void> deleteUserAccountFromFirebase(BuildContext context) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null || !isSupportedProviderUser(user)) {
//       _setError(
//           'delete_account_provider.not_logged_in_with_supported_provider'.tr());
//       return;
//     }

//     try {
//       await user.delete();
//       _clearError();
//       _logger.i("User account deleted from Firebase: ${user.uid}");
//       _showSnackBar(
//           context, 'delete_account_provider.account_deleted_successfully'.tr());
//     } catch (error) {
//       _setError(
//           '${'delete_account_provider.error_deleting_account'.tr()} $error');
//     }
//   }

//   /// Handles Firebase authentication errors.
//   void _handleAuthException(FirebaseAuthException error) {
//     switch (error.code) {
//       case 'wrong-password':
//         _setError('delete_account_provider.incorrect_password'.tr());
//         break;
//       default:
//         _setError('delete_account_provider.error_confirming_password'.tr());
//         break;
//     }
//     _logger.e(
//         "Password verification failed. Code: ${error.code}, Message: ${error.message}");
//   }

//   /// Sets an error message and notifies listeners.
//   void _setError(String message) {
//     _errorMessage = message;
//     _logger.e(message);
//     notifyListeners();
//   }

//   /// Clears the error message and notifies listeners.
//   void _clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }

//   /// Displays a snackbar notification.
//   void _showSnackBar(BuildContext context, String message) {
//     NotificationSnackBar(context: context, text: message).showSnackBar();
//   }
// }







import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_snack_bar.dart';
import 'package:botnoivoice/screen/drawer/account/get_user_email.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Provider for the DeleteAccountNotifier.
/// It exposes the current error message (String?) as its state.
final deleteAccountServiceProvider =
    NotifierProvider<DeleteAccountNotifier, String?>(
  DeleteAccountNotifier.new,
);

/// ***DO NOT DELETE THIS TEXT FOR ANY REASON***
///
/// *Delete Account for Email/Password and Apple Sign-In*
///
/// 3 Steps to Delete Account:
/// 1. Verify User Password or Apple Sign-In.
/// 2. Delete User Data from Database (MongoDB).
/// 3. Delete User Account from Firebase.
///
/// ***WARNING***
/// - Deleting a Firebase account removes it from all environments (Staging & Production).
class DeleteAccountNotifier extends Notifier<String?> {
  final Logger _logger = Logger();

  /// Builds the initial state of the Notifier, which is the error message.
  /// Initial state is null (no error).
  @override
  String? build() {
    return null;
  }

  /// Getter for the error message.
  /// It reads the current state exposed by the Notifier.
  String? get errorMessage => state;

  /// Checks if the user is logged in with a supported provider (Email/Password or Apple).
  bool isSupportedProviderUser(User? user) {
    // Checks if the user's provider data contains either 'password' or 'apple.com'
    return user?.providerData.any((info) =>
            info.providerId == 'password' || info.providerId == 'apple.com') ??
        false;
  }

  /// Verifies the user's credentials before account deletion.
  /// Accepts password for 'password' provider, or triggers Apple sign-in flow for 'apple.com'.
  Future<bool> verifyCredentials(String? password, String providerId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || !isSupportedProviderUser(user)) {
      _setError(
          'delete_account_provider.not_logged_in_with_supported_provider'.tr());
      return false;
    }

    try {
      if (providerId == 'password') {
        if (password == null || password.isEmpty) {
          _setError('delete_account_provider.password_required'.tr()); // Notifies that the password is required.
          return false;
        }

        // Reauthenticate with Email and Password credentials
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: user.email!, password: password),
        );
      } else if (providerId == 'apple.com') {
        try {
          // Trigger the native Apple Sign-In flow for reauthentication
          final appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName
            ],
          );

          if (appleCredential.identityToken == null ||
              appleCredential.authorizationCode.isEmpty) {
            _setError('delete_account_provider.apple_auth_failed'.tr()); // Notifies that Apple authentication failed.
            return false;
          }

          // Create Firebase credential from Apple tokens
          final credential = OAuthProvider('apple.com').credential(
            idToken: appleCredential.identityToken,
            accessToken: appleCredential.authorizationCode,
          );

          await user.reauthenticateWithCredential(credential);
        } on SignInWithAppleAuthorizationException catch (e) {
          if (e.code == AuthorizationErrorCode.canceled) {
            _setError('delete_account_provider.apple_signin_canceled'.tr()); // Notifies that the user canceled the sign-in.
            _logger.w("User canceled Apple Sign-In.");
            return false;
          } else {
            _setError('delete_account_provider.apple_auth_failed'.tr()); // Notifies that Apple authentication failed.
            _logger.e("Apple Sign-In failed: ${e.message}");
            return false;
          }
        }
      } else {
        _setError('DO NOT SUPPORT (Only Email/Password and Apple Account)');
        return false;
      }

      _clearError();
      return true;
    } on FirebaseAuthException catch (error) {
      _handleAuthException(error);
      return false;
    } catch (error) {
      _setError(
          '${'delete_account_provider.error_confirming_password'.tr()} $error');
      _logger.e("Unexpected error during authentication: $error");
      return false;
    }
  }

  /// Deletes user data from the application database (MongoDB via API).
  ///
  /// **API to Delete User Account in Database**
  ///
  /// - Supports: Email/Password and Apple Sign In.**
  /// - API Method: DELETE
  /// - Database: Studio 3T MongoDB.
  Future<void> deleteUserDataFromDatabase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || !isSupportedProviderUser(user)) {
      _setError(
          'delete_account_provider.not_logged_in_with_supported_provider'.tr());
      return;
    }

    // Construct the API URL using user's UID
    final url = '$apiUrl/db/dashboard/users/${user.uid}';
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        _clearError();

        _logger.d(
            "User data deleted from Database: \nUser UID: ${user.uid}. \nEmail: ${getUserEmail(user)}");
      } else {
        // Handle API errors based on status code
        _setError(
            '${'delete_account_provider.unable_to_delete_account_status_code'.tr()} ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or connection errors
      _setError(
          '${'delete_account_provider.error_deleting_account'.tr()} $error');
    }
  }

  /// Deletes the user's Firebase account.
  /// Note: Requires BuildContext for showing UI feedback (SnackBar).
  Future<void> deleteUserAccountFromFirebase(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || !isSupportedProviderUser(user)) {
      _setError(
          'delete_account_provider.not_logged_in_with_supported_provider'.tr());
      return;
    }

    try {
      await user.delete();
      _clearError();
      _logger.i("User account deleted from Firebase: ${user.uid}");
      // Show success notification to the user
      _showSnackBar(
          context, 'delete_account_provider.account_deleted_successfully'.tr());
    } on FirebaseAuthException catch (error) {
      // Catch specific errors during Firebase account deletion
      _setError(
          '${'delete_account_provider.error_deleting_account'.tr()} ${error.message}');
      _logger.e("Firebase account deletion failed: ${error.code} - ${error.message}");
    } catch (error) {
      // Catch general errors
      _setError(
          '${'delete_account_provider.error_deleting_account'.tr()} $error');
    }
  }

  /// Handles Firebase authentication errors during reauthentication.
  void _handleAuthException(FirebaseAuthException error) {
    switch (error.code) {
      case 'wrong-password':
      case 'invalid-credential': // Sometimes used for generic reauth failures
        _setError('delete_account_provider.incorrect_password'.tr());
        break;
      default:
        _setError('delete_account_provider.error_confirming_password'.tr());
        break;
    }
    _logger.e(
        "Credential verification failed. Code: ${error.code}, Message: ${error.message}");
  }

  /// Sets an error message and updates the Notifier's state.
  void _setError(String message) {
    // Update the state, notifying all listeners (replacing notifyListeners())
    state = message;
    _logger.e(message);
  }

  /// Clears the error message and updates the Notifier's state.
  void _clearError() {
    // Set state to null, clearing the error
    state = null;
  }

  /// Displays a snackbar notification (requires BuildContext).
  void _showSnackBar(BuildContext context, String message) {
    NotificationSnackBar(context: context, text: message).showSnackBar();
  }
}