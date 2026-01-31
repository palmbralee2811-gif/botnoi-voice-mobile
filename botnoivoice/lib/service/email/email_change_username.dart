// lib/service/email/email_change_username.dart
import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart'; // ใช้ Token Provider ใหม่
import 'package:botnoivoice/service/email/email_username_api.dart'; // ใช้ Notifier ใหม่
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

// State Class
class EmailChangeUsernameState {
  final String? errorMessage;
  
  EmailChangeUsernameState({this.errorMessage});

  EmailChangeUsernameState copyWith({String? errorMessage}) {
    return EmailChangeUsernameState(
      errorMessage: errorMessage,
    );
  }
}

/// Change username for Login with Email and Password
class EmailChangeUsernameNotifier extends StateNotifier<EmailChangeUsernameState> {
  final Ref _ref;
  final Logger _logger = Logger();

  EmailChangeUsernameNotifier(this._ref) : super(EmailChangeUsernameState());

  /// Getter สำหรับ error message
  String? get errorMessage => state.errorMessage;

  /// ฟังก์ชันสำหรับเปลี่ยน username
  Future<void> postChangeUsername(String usernameNew) async {
    try {
      final emailApiNotifier = _ref.read(emailUsernameApiNotifierProvider.notifier);

      // ใช้ await เพื่อรอให้การเช็ค email เสร็จสิ้นก่อนดำเนินการต่อ
      await emailApiNotifier.getEmailByUsername(usernameNew);
      
      final checkResult = _ref.read(emailUsernameApiNotifierProvider).result;

      // ตรวจสอบผลลัพธ์จาก EmailUsernameApiProvider
      if (checkResult == 'email not found') {
        // ถ้า email ไม่พบ แสดงว่า username สามารถใช้ได้
        // ดึง JWT Token จาก Email Token Notifier
        final jwtToken = _ref.read(emailTokenNotifierProvider).jwtToken;
        if (jwtToken == null) {
          _setError("JWT Token is null. Cannot change username.");
          return;
        }

        String url = '$apiUrl/api/dashboard/edit_username_id';
        Map<String, String> headers = {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        };

        Map<String, String> body = {
          'username': usernameNew,
        };

        final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body),
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          if (data['message'] == 'success') {
            state = state.copyWith(errorMessage: null);
            _logger.d('Username updated: $usernameNew');
          } else {
            _setError('Failed to update username');
          }
        } else {
          _setError(
              'Failed to update username. Status Code: ${response.statusCode}');
        }
      } else {
        // ถ้า username ซ้ำ
        _setError('change_username_provider.username_taken'.tr()); 
      }
    } catch (e) {
      _setError('Error: $e');
    }
  }
  
  void _setError(String message) {
    state = state.copyWith(errorMessage: message);
    _logger.e(message);
  }
}

/// Riverpod provider for EmailChangeUsernameNotifier.
final emailChangeUsernameNotifierProvider = 
    StateNotifierProvider<EmailChangeUsernameNotifier, EmailChangeUsernameState>((ref) {
  return EmailChangeUsernameNotifier(ref);
});
