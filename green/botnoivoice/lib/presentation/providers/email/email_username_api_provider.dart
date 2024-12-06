import 'dart:convert';
import 'package:botnoivoice/presentation/configurations/api_url_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class EmailUsernameApiProvider extends ChangeNotifier {
  String? _getUsername; // Username for Login with Email or Username
  final Logger _logger = Logger(); // For debugging
  String _result = ''; // ตัวแปรสำหรับเก็บผลลัพธ์ที่จะแสดงใน UI

  /// Getter for Login with Email or Username
  String? get getUsername => _getUsername;

  /// Getter for result of getEmailByUsername, getUsernameByEmail
  String get result => _result;

  /// /*
  /// เพิ่ม api /api/dashboard/get_email_mobile สำหรับดึง email (mobile)
  /// GET /api/dashboard/get_email_mobile?username=<username>
  /// # header
  /// X-API-BOTNOI : Ym90b25vaQ
  /// https://api-voice-staging.botnoi.ai/
  /// มันจะมี header ที่พี่เพิ่มเข้ามานะ
  /// import requests
  /// url = "https://api-voice-staging.botnoi.ai/api/dashboard/get_email_mobile"
  /// querystring = {"username":"ttest1"}
  /// headers = {
  ///     "X-API-BOTNOI": "Ym90b25vaQ",
  ///     "Content-Type": "application/json"
  /// }
  /// response = requests.request("GET", url, headers=headers, params=querystring)
  /// print(response.text)
  /// */
  Future<void> getEmailMobile() async {
    String url = '$apiUrl/api/dashboard/get_email_mobile';

    // สร้าง query parameters หลายตัว
    Map<String, String> queryParams = {
      'username': 'ttest',
      'username2': 'ttest2',
      'username3': 'ttest3'
    };

    // สร้าง Uri โดยการเพิ่ม query parameters เข้าไปใน Uri
    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    Map<String, String> headers = {
      'X-API-BOTNOI': 'Ym90b25vaQ',
      'Content-Type': 'application/json'
    };

    try {
      // ทำการส่งคำขอ GET พร้อม Uri ที่มี query string
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _result = data.toString(); // เก็บผลลัพธ์ไว้ในตัวแปร
        _logger.d('Response Data: $_result');
        notifyListeners();
      } else {
        _result = 'Failed to get email. Status Code: ${response.statusCode}';
        _logger.e('Failed with status code: ${response.statusCode}');
        notifyListeners();
      }
    } catch (e) {
      _result = 'Error: $e';
      _logger.e('Error: $e');
      notifyListeners();
    }
  }

  /// /*
  /// เพิ่ม api /api/dashboard/update_username_id ใช้เพื่ออัพเดทเอา username ตาม user_id เพื่อเก็บไว้ใน database
  /// POST /api/dashboard/update_username_id
  /// # header
  /// X-API-BOTNOI : Ym90b25vaQ
  /// # payload json
  /// {
  ///   "user_id": uid_firebase,
  ///   "username": username_new
  /// }
  /// */
  Future<void> postSendUsernameToDatabase(
      String? uid, String? username, String? email) async {
    // API endpoint สำหรับ register user
    String url = '$apiUrl/api/dashboard/register_mobile';

    // สร้าง payload ที่ต้องส่งไปใน body ของคำขอ
    Map<String, dynamic> payload = {
      'user_id': uid,
      'username': username,
      'email': email,
    };

    // สร้าง header ที่ต้องใช้ในการส่งคำขอ
    Map<String, String> headers = {
      'X-API-BOTNOI': 'Ym90b25vaQ',
      'Content-Type': 'application/json'
    };

    try {
      // ส่งคำขอ POST ไปยัง API
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(payload));

      // ตรวจสอบสถานะการตอบสนองของ API
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _result = data.toString(); // เก็บผลลัพธ์ในตัวแปร
        _logger.d('Response Data: $_result');
        notifyListeners(); // แจ้งให้ UI ทราบว่ามีการอัปเดตข้อมูล
      } else {
        _result =
            'Failed to register user. Status Code: ${response.statusCode}';
        _logger.e('Failed with status code: ${response.statusCode}');
        notifyListeners();
      }
    } catch (e) {
      // จับข้อผิดพลาดในกรณีที่มีปัญหาในการส่งคำขอ
      _result = 'Error: $e';
      _logger.e('Error: $e');
      notifyListeners();
    }
  }

  /// /*
  /// เพิ่ม api เพื่อรับ email จาก username /api/dashboard/get_email ใช้เพื่อเอา username
  /// ออกมาโดยใช้ email ในการค้นหาข้อมูล
  /// GET /api/dashboard/get_username?email=<email>
  /// /api/dashboard/get_email?username=nah_i_win
  /// https://api-voice-staging.botnoi.ai/api/dashboard/get_email?username=nah_i_win
  /// */
  Future<void> getEmailByUsername(String? usernameId) async {
    String url = '$apiUrl/api/dashboard/get_email_mobile?username=$usernameId';
    Map<String, String> headers = {
      'X-API-BOTNOI': 'Ym90b25vaQ',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // ตรวจสอบว่า response ประกอบด้วยข้อมูล email หรือไม่
        if (data['message'] == 'success' && data['data'] != null) {
          // ดึงค่า email จาก data
          String email = data['data']['email'];
          _result = email; // เก็บเฉพาะ email ไว้ในตัวแปร _result
          _logger.d('Email: $email');
        } else {
          _result = 'email not found';
          _logger.e('email not found');
        }

        notifyListeners();
      } else {
        _result = 'Failed to get email. Status Code: ${response.statusCode}';
        _logger.e('Failed with status code: ${response.statusCode}');
        notifyListeners();
      }
    } catch (e) {
      _result = 'Error: $e';
      _logger.e('Error: $e');
      notifyListeners();
    }
  }

  /// /*
  /// เพิ่ม api เพื่อรับ username จาก email /api/dashboard/get_username
  /// ใช้เพื่อเอา username ออกมาโดยใช้ email ในการค้นหาข้อมูล
  /// GET /api/dashboard/get_username?email=<email>
  /// https://api-voice-staging.botnoi.ai/api/dashboard/get_username_id?email=porton555@gmail.com
  /// */
  Future<void> getUsernameByEmail(String? email) async {
    String url = '$apiUrl/api/dashboard/get_username_id?email=$email';
    Map<String, String> headers = {
      'X-API-BOTNOI': 'Ym90b25vaQ',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // ตรวจสอบว่ามี data และ username อยู่ใน response
        if (data['message'] == 'success' &&
            data['data'] != null &&
            data['data']['username'] != null) {
          String username = data['data']['username'];
          _result = username; // เก็บแค่ username
          _logger.d('Username: $username');
        } else {
          _result = 'No username found in response.';
          _logger.w('Response does not contain username.');
        }
        notifyListeners();
      } else {
        _result = 'Failed to get username. Status Code: ${response.statusCode}';
        _logger.e('Failed with status code: ${response.statusCode}');
        notifyListeners();
      }
    } catch (e) {
      _result = 'Error: $e';
      _logger.e('Error: $e');
      notifyListeners();
    }
  }

  /// ดึง username จาก email และเรียกใช้ฟังก์ชัน get username by email
  Future<void> loadGetUsername(String? email) async {
    await getUsernameByEmail(email);
    _getUsername = _result;
  }
}
