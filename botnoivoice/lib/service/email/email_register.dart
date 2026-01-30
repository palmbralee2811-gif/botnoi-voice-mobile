import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/service/email/email_username_api.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// State Class
class EmailRegisterState {
  final String? userId;
  final String? username;
  final String? errorMessage;
  final String? resultMessage;

  EmailRegisterState({this.userId, this.username, this.errorMessage, this.resultMessage});

  EmailRegisterState copyWith({
    String? userId,
    String? username,
    String? errorMessage,
    String? resultMessage,
  }) {
    return EmailRegisterState(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      errorMessage: errorMessage, // nullify if passed explicitly
      resultMessage: resultMessage,
    );
  }
}

class EmailRegisterNotifier extends StateNotifier<EmailRegisterState> {
  final Ref _ref;
  final Logger _logger = Logger();

  EmailRegisterNotifier(this._ref) : super(EmailRegisterState());

  /// Getter สำหรับ user ID
  String? get getEmailUserId => state.userId;

  /// Getter สำหรับ username
  String? get getEmailUsername => state.username;

  /// Setter สำหรับ username
  set username(String? value) {
    state = state.copyWith(username: value);
  }

  /// Getter สำหรับ error message
  String? get errorMessage => state.errorMessage;

  /// Getter สำหรับ result message
  String? get resultMessage => state.resultMessage;

  /// ฟังก์ชันตรวจสอบว่า username ซ้ำหรือไม่
  Future<bool> checkUsernameAvailability(String usernameId) async {
    final emailApiNotifier = _ref.read(emailUsernameApiNotifierProvider.notifier);
    
    // เรียกใช้ getEmailByUsername
    await emailApiNotifier.getEmailByUsername(usernameId);
    
    final checkResult = _ref.read(emailUsernameApiNotifierProvider).result;

    if (checkResult == 'email not found') {
      state = state.copyWith(errorMessage: null);
      _logger.i('Username is available');
      return true; 
    } else {
      _setError('register_provider.username_taken'.tr());
      _logger.w('Username already taken. Please choose another one.');
      return false;
    }
  }

  /// ลงทะเบียนผู้ใช้ด้วย email และ password, ส่ง verification email
  Future<void> registerWithEmailPassword(
      String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      _setError('register_provider.passwords_do_not_match'.tr());
      _logger.w("Passwords do not match for email: $email");
      return;
    }

    if (state.username == null) {
      _setError('register_provider.username_not_set'.tr());
      return;
    }
    
    // ตรวจสอบว่า username ซ้ำหรือไม่
    if (await checkUsernameAvailability(state.username!)) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        
        state = state.copyWith(userId: userCredential.user?.uid, errorMessage: null);
        _logger.i("User registered successfully.");

        // ส่ง verification email
        try {
          await userCredential.user?.sendEmailVerification();
          state = state.copyWith(
            resultMessage: "${'register_provider.please_verify_email'.tr()} $email",
            errorMessage: null,
          );
          _logger.i("Verification email sent to: $email");

          // เรียก API เพื่อส่งข้อมูล user_id, username, email ไปยัง backend
          await _registerUserToBackend(state.userId, email);
        } catch (e) {
          _setError('register_provider.unable_to_send_verification_email'.tr());
          _logger.e("Failed to send verification email: $e");
        }
      } on FirebaseAuthException catch (e) {
        String? error;
        switch (e.code) {
          case 'email-already-in-use':
            error = 'register_provider.email_used_by_another_account'.tr();
            break;
          case 'invalid-email':
            error = 'register_provider.invalid_email_format'.tr();
            break;
          case 'weak-password':
            error = 'register_provider.password_not_strong_enough'.tr();
            break;
          case 'operation-not-allowed':
            error = 'register_provider.action_not_allowed'.tr();
            break;
          default:
            error = 'register_provider.error_registering'.tr();
            break;
        }
        _setError(error);
        _logger.e(
            "Error registering user with email: $email \nMessage: ${e.message} \nCode: ${e.code}");
      }
    }
  }

  /// ฟังก์ชันสำหรับเรียก API และส่งข้อมูลไปยัง backend
  Future<void> _registerUserToBackend(String? userId, String email) async {
    if (userId == null || state.username == null) {
      _setError('register_provider.no_uid_or_username'.tr());
      _logger.e("User ID or Username is null, cannot register to backend.");
      return;
    }

    final url = Uri.parse('$apiUrl/api/dashboard/register_mobile');
    final headers = {
      'Content-Type': 'application/json',
      'X-API-BOTNOI': 'Ym90b25vaQ',
    };
    final body = jsonEncode({
      'user_id': userId,
      'username': state.username, 
      'email': email,
    });

    try {
      _logger.i("Sending user data to backend: $body, url: $url");

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        state = state.copyWith(errorMessage: null);
        _logger.i("User successfully registered to backend.");
      } else {
        _setError('register_provider.error_registering'.tr());
        _logger.e(
            "Failed to register user to backend, Status Code: ${response.statusCode}");
      }
    } catch (e) {
      _setError('register_provider.error_connecting_server'.tr());
      _logger.e("Error during API call: $e");
    }
  }
  
  void _setError(String message) {
    state = state.copyWith(errorMessage: message, resultMessage: null);
    _logger.e(message);
  }
}

/// Riverpod provider for EmailRegisterNotifier.
final emailRegisterNotifierProvider = 
    StateNotifierProvider<EmailRegisterNotifier, EmailRegisterState>((ref) {
  return EmailRegisterNotifier(ref);
});