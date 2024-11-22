import 'dart:convert';
import 'package:botnoivoice/presentation/constants/url.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// Change username for Login with Email and Password
class EmailChangeUsernameProvider extends ChangeNotifier {
  String? _errorMessage;
  final Logger _logger = Logger(); // สำหรับ debug

  /// Getter สำหรับ error message
  String? get errorMessage => _errorMessage;

  /// ฟังก์ชันสำหรับเปลี่ยน username โดยใช้ async/await
  Future<void> postChangeUsername(BuildContext context, String usernameNew) async {
    try {
      // เรียกใช้ getEmailByUsername เพื่อเช็คว่า username มีอยู่หรือไม่
      final emailApiProvider = Provider.of<EmailUsernameApiProvider>(context, listen: false);
      
      // ใช้ await เพื่อรอให้การเช็ค email เสร็จสิ้นก่อนดำเนินการต่อ
      await emailApiProvider.getEmailByUsername(usernameNew);

      // ตรวจสอบผลลัพธ์จาก EmailUsernameApiProvider
      if (emailApiProvider.result == 'email not found') {
        // ถ้า email ไม่พบ แสดงว่า username สามารถใช้ได้
        final jwtToken = Provider.of<EmailTokenProvider>(context, listen: false).getJwtToken;
        String url = '$urlDomain/api/dashboard/edit_username_id';
        Map<String, String> headers = {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json'
        };

        Map<String, String> body = {
          'username': usernameNew,
        };

        // ใช้ await เพื่อให้แน่ใจว่า post request ดำเนินการเสร็จสิ้นก่อน
        final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(body),
        );

        // ตรวจสอบผลลัพธ์ของการเปลี่ยน username
        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          if (data['message'] == 'success') {
            _errorMessage = null;
            notifyListeners();
            _logger.d('Username updated: $usernameNew');
          } else {
            _errorMessage = 'Failed to update username';
            _logger.e('Failed to update username');
          }
        } else {
          _errorMessage = 'Failed to update username. Status Code: ${response.statusCode}';
          _logger.e('Failed with status code: ${response.statusCode}');
        }
      } else {
        // ถ้า email ไม่เป็น 'email not found' แสดงว่า username ซ้ำ
        _errorMessage = 'app_drawer.username_taken'.tr();
        _logger.e('Cannot change username. Username already exists.');
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _logger.e('Error: $e');
    }

    notifyListeners();
  }
}
