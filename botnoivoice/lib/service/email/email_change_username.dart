// import 'dart:convert';
// import 'package:botnoivoice/config/api_url_config.dart';
// import 'package:botnoivoice/service/token/email_token.dart';
// import 'package:botnoivoice/service/email/email_username_api.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';
// import 'package:provider/provider.dart';

// /// Change username for Login with Email and Password
// class EmailChangeUsername extends ChangeNotifier {
//   String? _errorMessage;
//   final Logger _logger = Logger(); // สำหรับ debug

//   /// Getter สำหรับ error message
//   String? get errorMessage => _errorMessage;

//   /// ฟังก์ชันสำหรับเปลี่ยน username โดยใช้ async/await
//   Future<void> postChangeUsername(
//       BuildContext context, String usernameNew) async {
//     try {
//       // เรียกใช้ getEmailByUsername เพื่อเช็คว่า username มีอยู่หรือไม่
//       final emailApiProvider = context.read<EmailUsernameApi>();

//       // ใช้ await เพื่อรอให้การเช็ค email เสร็จสิ้นก่อนดำเนินการต่อ
//       await emailApiProvider.getEmailByUsername(usernameNew);

//       // ตรวจสอบผลลัพธ์จาก EmailUsernameApiProvider
//       if (emailApiProvider.result == 'email not found') {
//         // ถ้า email ไม่พบ แสดงว่า username สามารถใช้ได้
//         final jwtToken = context.read<EmailTokenNotifier>().getJwtToken;
//         String url = '$apiUrl/api/dashboard/edit_username_id';
//         Map<String, String> headers = {
//           'Authorization': 'Bearer $jwtToken',
//           'Content-Type': 'application/json'
//         };

//         Map<String, String> body = {
//           'username': usernameNew,
//         };

//         // ใช้ await เพื่อให้แน่ใจว่า post request ดำเนินการเสร็จสิ้นก่อน
//         final response = await http.post(
//           Uri.parse(url),
//           headers: headers,
//           body: json.encode(body),
//         );

//         // ตรวจสอบผลลัพธ์ของการเปลี่ยน username
//         if (response.statusCode == 200) {
//           var data = json.decode(response.body);

//           if (data['message'] == 'success') {
//             _errorMessage = null;
//             notifyListeners();
//             _logger.d('Username updated: $usernameNew');
//           } else {
//             _errorMessage = 'Failed to update username';
//             _logger.e('Failed to update username');
//           }
//         } else {
//           _errorMessage =
//               'Failed to update username. Status Code: ${response.statusCode}';
//           _logger.e('Failed with status code: ${response.statusCode}');
//         }
//       } else {
//         // ถ้า email ไม่เป็น 'email not found' แสดงว่า username ซ้ำ
//         _errorMessage = 'change_username_provider.username_taken'
//             .tr(); //ชื่อผู้ใช้งานซ้ำกับบัญชีอื่น
//         _logger.e('Cannot change username. Username already exists.');
//       }
//     } catch (e) {
//       _errorMessage = 'Error: $e';
//       _logger.e('Error: $e');
//     }

//     notifyListeners();
//   }
// }

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
