import 'package:botnoivoice/presentation/configurations/api_url_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailRegisterProvider with ChangeNotifier {
  String? _userId;
  String? _username;
  String? _errorMessage;
  String? _resultMessage;
  final Logger _logger = Logger();

  /// Getter สำหรับ user ID
  String? get getEmailUserId => _userId;

  /// Getter สำหรับ username
  String? get getEmailUsername => _username;

  /// Setter สำหรับ username
  set username(String? value) {
    _username = value;
    notifyListeners(); // แจ้ง UI ว่าข้อมูลเปลี่ยนแปลง
  }

  /// Getter สำหรับ error message
  String? get errorMessage => _errorMessage;

  /// Getter สำหรับ result message
  String? get resultMessage => _resultMessage;

  /// ฟังก์ชันตรวจสอบว่า username ซ้ำหรือไม่
  Future<bool> checkUsernameAvailability(String usernameId) async {
    String url = '$apiUrl/api/dashboard/get_email_mobile?username=$usernameId';
    Map<String, String> headers = {
      'X-API-BOTNOI': 'Ym90b25vaQ',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // ตรวจสอบว่ามี email ไม่พบในระบบ แสดงว่า username ใช้ได้
        if (data['message'] == 'success' &&
            data['data']['email'] == 'email not found') {
          _logger.i('Username is available');
          _errorMessage = null; // รีเซ็ต error message
          notifyListeners();
          return true; // username ใช้ได้
        } else {
          _errorMessage = 'register_provider.username_taken'
              .tr(); //ชื่อผู้ใช้งานถูกใช้ไปแล้ว
          _logger.w('Username already taken. Please choose another one.');
          notifyListeners();
          return false; // username ซ้ำ
        }
      } else {
        _logger.e(
            'Failed to check username availability. Status Code: ${response.statusCode}');
        _errorMessage = 'register_provider.error_checking_username'
            .tr(); //เกิดข้อผิดพลาดในการตรวจสอบชื่อผู้ใช้
        notifyListeners();
        return false;
      }
    } catch (e) {
      _logger.e('Error during username check: $e');
      _errorMessage = 'register_provider.error_connecting_server'
          .tr(); //เกิดข้อผิดพลาดในการเชื่อมต่อกับเซิร์ฟเวอร์
      notifyListeners();
      return false;
    }
  }

  /// ลงทะเบียนผู้ใช้ด้วย email และ password, ส่ง verification email
  Future<void> registerWithEmailPassword(
      String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      _errorMessage =
          'register_provider.passwords_do_not_match'.tr(); //รหัสผ่านไม่ตรงกัน
      _logger.w("Passwords do not match for email: $email");
      notifyListeners();
      return;
    }

    // ตรวจสอบว่า username ซ้ำหรือไม่
    if (await checkUsernameAvailability(_username!)) {
      try {
        // ลงทะเบียนผู้ใช้
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        _userId = userCredential.user?.uid;
        _errorMessage = null; // รีเซ็ต error message
        _logger.i("User registered successfully.");
        notifyListeners();

        // ส่ง verification email
        try {
          await userCredential.user?.sendEmailVerification();
          _resultMessage =
              "${'register_provider.please_verify_email'.tr()} $email"; //กรุณายืนยันอีเมล:
          _errorMessage = null; // รีเซ็ต error message
          _logger.i("Verification email sent to: $email");

          // เรียก API เพื่อส่งข้อมูล user_id, username, email ไปยัง backend
          await _registerUserToBackend(_userId, email);
          notifyListeners();
        } catch (e) {
          _errorMessage = 'register_provider.unable_to_send_verification_email'
              .tr(); //ไม่สามารถส่งอีเมลยืนยันได้
          _logger.e("Failed to send verification email: $e");
          notifyListeners();
        }
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'email-already-in-use':
            _errorMessage = 'register_provider.email_used_by_another_account'
                .tr(); //อีเมลถูกใช้โดยบัญชีอื่นแล้ว
            break;
          case 'invalid-email':
            _errorMessage = 'register_provider.invalid_email_format'
                .tr(); //รูปแบบอีเมลไม่ถูกต้อง
            break;
          case 'weak-password':
            _errorMessage = 'register_provider.password_not_strong_enough'
                .tr(); //รหัสผ่านไม่แข็งแรงพอ
            break;
          case 'operation-not-allowed':
            _errorMessage = 'register_provider.action_not_allowed'
                .tr(); //การดำเนินการนี้ไม่ได้รับอนุญาต
            break;
          default:
            _errorMessage = 'register_provider.error_registering'
                .tr(); //เกิดข้อผิดพลาดในการสมัครสมาชิก
            break;
        }
        _logger.e(
            "Error registering user with email: $email \nMessage: ${e.message} \nCode: ${e.code}");
        notifyListeners();
      }
    }
  }

  /// ฟังก์ชันสำหรับเรียก API และส่งข้อมูลไปยัง backend
  Future<void> _registerUserToBackend(String? userId, String email) async {
    if (userId == null || _username == null) {
      _logger.e("User ID or Username is null, cannot register to backend.");
      _errorMessage = 'register_provider.no_uid_or_username'
          .tr(); //ไม่มีรหัส UID หรือชื่อผู้ใช้งาน
      notifyListeners();
      return;
    }

    final url = Uri.parse('$apiUrl/api/dashboard/register_mobile');
    final headers = {
      'Content-Type': 'application/json',
      'X-API-BOTNOI': 'Ym90b25vaQ',
    };
    final body = jsonEncode({
      'user_id': userId,
      'username': _username, // ส่งค่า username จาก setter
      'email': email,
    });

    try {
      _logger.i("Sending user data to backend: $body, url: $url");

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        _errorMessage = null; // รีเซ็ต error message เมื่อส่งข้อมูลสำเร็จ
        _logger.i("User successfully registered to backend.");
      } else {
        _errorMessage = 'register_provider.error_registering'
            .tr(); //เกิดข้อผิดพลาดในการสมัครสมาชิก
        _logger.e(
            "Failed to register user to backend, Status Code: ${response.statusCode}");
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'register_provider.error_connecting_server'
          .tr(); //เกิดข้อผิดพลาดในเชื่อมต่อกับเซิร์ฟเวอร์
      _logger.e("Error during API call: $e");
      notifyListeners();
    }
  }
}
