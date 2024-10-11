import 'package:botnoivoice/presentation/constants/url.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailRegisterProvider with ChangeNotifier {
  String? _userId;
  String? _username; // ตัวแปรสำหรับเก็บค่า username
  String? _errorMessage;
  final Logger _logger = Logger();

  /// Getter สำหรับ user ID
  String? get userId => _userId;

  /// Getter สำหรับ username
  String? get username => _username;

  /// Setter สำหรับ username
  set username(String? value) {
    _username = value;
    notifyListeners(); // แจ้ง UI ว่าข้อมูลเปลี่ยนแปลง
  }

  /// Getter สำหรับ error message
  String? get errorMessage => _errorMessage;

  /// ฟังก์ชันตรวจสอบว่า username ซ้ำหรือไม่
  Future<bool> checkUsernameAvailability(String usernameId) async {
    String url = '$urlDomain/api/dashboard/get_email_mobile?username=$usernameId';
    Map<String, String> headers = {
      'X-API-BOTNOI': 'Ym90b25vaQ',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // ตรวจสอบว่ามี email ไม่พบในระบบ แสดงว่า username ใช้ได้
        if (data['message'] == 'success' && data['data']['email'] == 'email not found') {
          _logger.i('Username is available');
          return true; // username ใช้ได้
        } else {
          _errorMessage = 'Username already taken. Please choose another one.';
          _logger.w('Username is already taken');
          notifyListeners();
          return false; // username ซ้ำ
        }
      } else {
        _errorMessage = 'Failed to check username availability. Status Code: ${response.statusCode}';
        _logger.e('Failed to check username availability, Status Code: ${response.statusCode}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _logger.e('Error during username check: $e');
      notifyListeners();
      return false;
    }
  }

  /// ลงทะเบียนผู้ใช้ด้วย email และ password, ส่ง verification email
  Future<void> registerWithEmailPassword(
      String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      _errorMessage = "Passwords do not match.";
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
        _errorMessage = null;
        _userId = userCredential.user?.uid;
        _logger.i(
            "User registered successfully with email: $email, User ID: $_userId");

        // ส่ง verification email
        try {
          await userCredential.user?.sendEmailVerification();
          _errorMessage = "Verification email sent to: $email";
          _logger.i("Verification email sent to: $email");

          // เรียก API เพื่อส่งข้อมูล user_id, username, email ไปยัง backend
          await _registerUserToBackend(_userId, email);

        } catch (e) {
          _logger.e("Failed to send verification email: $e");
        }

        notifyListeners();
      } on FirebaseAuthException catch (e) {
        _errorMessage = e.message;
        _logger
            .e("Error registering user with email: $email, Error: ${e.message}");
        notifyListeners();
      }
    } else {
      _logger.w("Username is already taken. Please choose another one.");
    }
  }

  /// ฟังก์ชันสำหรับเรียก API และส่งข้อมูลไปยัง backend
  Future<void> _registerUserToBackend(String? userId, String email) async {
    if (userId == null || _username == null) {
      _logger.e("User ID or Username is null, cannot register to backend.");
      return;
    }

    final url = Uri.parse('$urlDomain/api/dashboard/register_mobile');
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
        _logger.i("User successfully registered to backend.");
      } else {
        _logger.e("Failed to register user to backend, Status Code: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e("Error during API call: $e");
    }
  }
}
