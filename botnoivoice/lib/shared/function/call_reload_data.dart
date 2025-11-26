// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:logger/logger.dart';

// import 'package:botnoivoice/service/login/apple_login.dart';
// import 'package:botnoivoice/service/token/apple_token.dart';
// import 'package:botnoivoice/service/login/email_login.dart';
// import 'package:botnoivoice/service/token/email_token.dart';
// import 'package:botnoivoice/service/login/google_login.dart';
// import 'package:botnoivoice/service/token/google_token.dart';
// import 'package:botnoivoice/service/login/line_login.dart';
// import 'package:botnoivoice/service/token/line_token.dart';

// final _logger = Logger();

// class CallReloadData with ChangeNotifier {
//   String? _remainingCredits;

//   // Getter สำหรับเครดิตคงเหลือ
//   String? get remainingCredits => _remainingCredits;

//   // เซ็ตค่าและ notifyListeners เพื่อให้ UI อัปเดต
//   void setRemainingCredits(String? credits) {
//     _remainingCredits = credits;
//     notifyListeners();
//   }

//   // ฟังก์ชันโหลดเครดิตหลักแบบปลอดภัย
//   Future<void> callLoadCreditsApi(BuildContext context) async {
//     // อ่าน provider ทุกตัวให้เรียบร้อยก่อน await ใดๆ
//     final appleProvider = context.read<AppleLogin>();
//     final googleProvider = context.read<GoogleLogin>();
//     final lineProvider = context.read<LineLogin>();
//     final emailProvider = context.read<EmailLogin>();

//     final appleToken = context.read<AppleToken>();
//     final googleToken = context.read<GoogleToken>();
//     final lineToken = context.read<LineToken>();
//     final emailToken = context.read<EmailToken>();

//     try {
//       // เรียกโหลดเครดิตตาม provider ที่ล็อกอินอยู่
//       if (appleProvider.isLoggedIn &&
//           appleProvider.user?.providerData[0].providerId == 'apple.com') {
//         await appleToken.loadRemainingCredits();
//       }

//       if (googleProvider.isLoggedIn &&
//           googleProvider.user?.providerData[0].providerId == 'google.com') {
//         await googleToken.loadRemainingCredits();
//       }

//       if (lineProvider.isLoggedIn) {
//         await lineToken.loadRemainingCredits();
//       }

//       if (emailProvider.isLoggedIn &&
//           emailProvider.user?.providerData[0].providerId == 'password') {
//         await emailToken.loadRemainingCredits();
//       }

//       // เรียก get ค่าเครดิตและโควต้าดาวน์โหลดแบบปลอดภัย
//       final credits = await _getRemainingCreditsFromToken(
//         appleProvider,
//         googleProvider,
//         lineProvider,
//         emailProvider,
//         appleToken,
//         googleToken,
//         lineToken,
//         emailToken,
//       );

//       // อัปเดตสถานะใน state provider นี้
//       setRemainingCredits(credits);
//     } catch (e) {
//       _logger.e('Failed to load credits: $e');
//     }
//   }

//   // ดึงเครดิตจาก provider ที่ล็อกอินอยู่
//   Future<String?> _getRemainingCreditsFromToken(
//     AppleLogin appleProvider,
//     GoogleLogin googleProvider,
//     LineLogin lineProvider,
//     EmailLogin emailProvider,
//     AppleToken appleToken,
//     GoogleToken googleToken,
//     LineToken lineToken,
//     EmailToken emailToken,
//   ) async {
//     try {
//       if (appleProvider.isLoggedIn &&
//           appleProvider.user?.providerData[0].providerId == 'apple.com') {
//         _logger.d('User logged in with Apple');
//         return appleToken.getRemainingCredits;
//       }

//       if (googleProvider.isLoggedIn &&
//           googleProvider.user?.providerData[0].providerId == 'google.com') {
//         _logger.d('User logged in with Google');
//         return googleToken.getRemainingCredits;
//       }

//       if (lineProvider.isLoggedIn) {
//         _logger.d('User logged in with LINE');
//         return lineToken.getRemainingCredits;
//       }

//       if (emailProvider.isLoggedIn &&
//           emailProvider.user?.providerData[0].providerId == 'password') {
//         _logger.d('User logged in with Email');
//         return emailToken.getRemainingCredits;
//       }

//       _logger.w('No valid login provider found');
//       return "N/A";
//     } catch (e) {
//       _logger.e('Failed to get remaining credits', error: e);
//       return "N/A";
//     }
//   }
// }

// call_reload_data.dart
import 'package:botnoivoice/service/token/user_token_state.dart';
// Remove Provider import
import 'package:logger/logger.dart';

import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/line_token.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod

final _logger = Logger();

// --- Riverpod Providers ---

// The StateNotifier for managing remaining credits (String?).
// It holds the state and the logic to update it.
class RemainingCreditsNotifier extends StateNotifier<String?> {
  // Initialize state with null or a default value.
  RemainingCreditsNotifier() : super(null);

  /// Setter for remaining credits, updating the state.
  void setRemainingCredits(String? credits) {
    state = credits;
  }
}

// Provider for the RemainingCreditsNotifier (the state manager).
final remainingCreditsNotifierProvider =
    StateNotifierProvider<RemainingCreditsNotifier, String?>((ref) {
  return RemainingCreditsNotifier();
});

// Provider for the CallReloadData service class.
final callReloadDataProvider = Provider((ref) => CallReloadData(ref));

// --- CallReloadData Class ---

// We replace 'with ChangeNotifier' with a constructor that accepts a Ref.
class CallReloadData {
  final Ref _ref;

  // Constructor accepts a Ref from Riverpod.
  CallReloadData(this._ref);

  /// Getter for remaining credits, watching the StateNotifier's state.
  String? get remainingCredits => _ref.watch(remainingCreditsNotifierProvider);

  /// Function to set the remaining credits and update the UI.
  // This function is now directly on the Notifier.
  void _setRemainingCredits(String? credits) {
    // Access the Notifier to call its public method or directly set its state.
    _ref
        .read(remainingCreditsNotifierProvider.notifier)
        .setRemainingCredits(credits);
  }

  /// Main function to safely load remaining credits.
  // Note: The original still uses `context.read<XLogin>()` and `context.read<XToken>()`
  // for *other* providers which are assumed to be NOT Riverpod yet.
  // If these were Riverpod providers, we would use `_ref.read(XLoginProvider)` etc.
  Future<void> callLoadCreditsApi() async {
    // Reading other Providers that are assumed to still be using the Provider package
    // (requires BuildContext). This is a temporary necessity during migration.
    // In a fully Riverpod environment, use `_ref.read`.
    // We will assume the other providers (`XLogin`, `XToken`) have also been converted
    // to Riverpod Providers for a cleaner transition, and modify the code accordingly.
    // For this example, let's assume `XLogin` and `XToken` are now available via Riverpod Providers.

    // --- ASSUMPTION: The following Providers are now available via Riverpod ---
    // final appleProvider = _ref.read(appleLoginProvider);
    // final googleProvider = _ref.read(googleLoginProvider);
    // ...
    // BUT since the original code uses `context.read`, we'll keep the `context`
    // usage here for the external providers for now, assuming they are still Provider/BuildContext-based.
    // If they were Riverpod, they would be accessed via `_ref`.

    // Read all providers needed (assuming they are still Provider/BuildContext based for the moment)
    final appleProvider = _ref.watch(appleLoginNotifierProvider);
    final googleProvider = _ref.watch(googleLoginNotifierProvider);
    final lineProvider = _ref.watch(lineLoginNotifierProvider);
    final emailProvider = _ref.watch(emailLoginNotifierProvider);

    final appleToken = _ref.read(appleTokenNotifierProvider.notifier);
    final googleToken = _ref.read(googleTokenNotifierProvider.notifier);
    final lineToken = _ref.read(lineTokenNotifierProvider.notifier);
    final emailToken = _ref.read(emailTokenNotifierProvider.notifier);

    final userTokenState = _ref.read(userTokenProvider);

    try {
      // Call credit loading based on the logged-in provider.
      if (appleProvider.isLoggedIn &&
          appleProvider.user?.providerData[0].providerId == 'apple.com') {
        await appleToken.loadRemainingCredits();
      }

      if (googleProvider.isLoggedIn &&
          googleProvider.user?.providerData[0].providerId == 'google.com') {
        await googleToken.loadRemainingCredits();
      }

      // Assuming LineLogin doesn't expose providerId in the same way, based on original logic.
      if (lineProvider.isLoggedIn) {
        await lineToken.loadRemainingCredits();
      }

      if (emailProvider.isLoggedIn &&
          emailProvider.user?.providerData[0].providerId == 'password') {
        await emailToken.loadRemainingCredits();
      }

      // Safely get the remaining credits and download quota.
      final credits = await _getRemainingCreditsFromToken(
        appleProvider,
        googleProvider,
        lineProvider,
        emailProvider,
        appleToken,
        googleToken,
        lineToken,
        emailToken,
        userTokenState,
      );

      // Update the state in this Riverpod provider.
      _setRemainingCredits(credits);
    } catch (e) {
      _logger.e('Failed to load credits: $e');
    }
  }

// ใน class CallReloadData
// การประกาศพารามิเตอร์ต้องระบุประเภทให้ถูกต้อง (XTokenNotifier)
  Future<String?> _getRemainingCreditsFromToken(
    // ... (Login Providers เหมือนเดิม)
    AppleLoginState appleProvider,
    GoogleLoginState googleProvider,
    LineLoginState lineProvider,
    EmailLoginState emailProvider,
    AppleTokenNotifier appleToken, // เปลี่ยนเป็น Notifier Class
    GoogleTokenNotifier googleToken, // เปลี่ยนเป็น Notifier Class
    LineTokenNotifier lineToken, // เปลี่ยนเป็น Notifier Class
    EmailTokenNotifier emailToken, // เปลี่ยนเป็น Notifier Class
    UserTokenState userTokenState,
  ) async {
    try {
      if (appleProvider.isLoggedIn &&
          appleProvider.user?.providerData[0].providerId == 'apple.com') {
        _logger.d('User logged in with Apple');
        // 🚨 แก้ไขตรงนี้: เข้าถึง state.remainingCredits
        return userTokenState.remainingCredits;
      }

      if (googleProvider.isLoggedIn &&
          googleProvider.user?.providerData[0].providerId == 'google.com') {
        _logger.d('User logged in with Google');
        // 🚨 แก้ไขตรงนี้: เข้าถึง state.remainingCredits
        return userTokenState.remainingCredits;
      }

      if (lineProvider.isLoggedIn) {
        _logger.d('User logged in with LINE');
        // 🚨 แก้ไขตรงนี้: เข้าถึง state.remainingCredits
        return userTokenState.remainingCredits;
      }

      if (emailProvider.isLoggedIn &&
          emailProvider.user?.providerData[0].providerId == 'password') {
        _logger.d('User logged in with Email');
        // 🚨 แก้ไขตรงนี้: เข้าถึง state.remainingCredits
        return userTokenState.remainingCredits;
      }

      _logger.w('No valid login provider found');
      return "N/A";
    } catch (e) {
      _logger.e('Failed to get remaining credits', error: e);
      return "N/A";
    }
  }
}
