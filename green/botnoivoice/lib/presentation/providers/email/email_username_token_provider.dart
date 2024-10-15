import 'dart:convert';
import 'package:botnoivoice/presentation/constants/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class EmailUsernameTokenProvider extends ChangeNotifier {
  final Logger _logger = Logger(); // For debugging
  String _result = ''; // ตัวแปรสำหรับเก็บผลลัพธ์ที่จะแสดงใน UI

  String get result => _result;

  /*
  เพิ่ม api /api/dashboard/get_email_mobile สำหรับดึง email (mobile)

  GET /api/dashboard/get_email_mobile?username=<username>
  # header
  X-API-BOTNOI : Ym90b25vaQ
  https://api-voice-staging.botnoi.ai/
  มันจะมี header ที่พี่เพิ่มเข้ามานะ
  import requests

  url = "https://api-voice-staging.botnoi.ai/api/dashboard/get_email_mobile"

  querystring = {"username":"ttest1"}

  headers = {
      "X-API-BOTNOI": "Ym90b25vaQ",
      "Content-Type": "application/json"
  }

  response = requests.request("GET", url, headers=headers, params=querystring)

  print(response.text)
  */
  Future<void> getEmailMobile() async {
    String url = '$urlDomain/api/dashboard/get_email_mobile';

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

  /*
  เพิ่ม api /api/dashboard/update_username_id ใช้เพื่ออัพเดทเอา username ตาม user_id เพื่อเก็บไว้ใน database

  POST /api/dashboard/update_username_id
  # header
  X-API-BOTNOI : Ym90b25vaQ

  # payload json 
  {
    "user_id": uid_firebase,
    "username": username_new
  }

  */
  Future<void> postUpdateUsernameByFirebaseUid(
      String? uid, String? usernameId, String? usernameNew) async {
    String url = '$urlDomain/api/dashboard/update_$usernameId';
    Map<String, dynamic> payload = {
      'user_id': '$uid',
      'username': '$usernameNew'
    };
    Map<String, String> headers = {
      'X-API-BOTNOI': 'Ym90b25vaQ',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(payload));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _result = data.toString();
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

  /*
  เพิ่ม api เพื่อรับ email จาก username /api/dashboard/get_email ใช้เพื่อเอา username 
  ออกมาโดยใช้ email ในการค้นหาข้อมูล

  GET /api/dashboard/get_username?email=<email>

  /api/dashboard/get_email?username=nah_i_win

  https://api-voice-staging.botnoi.ai/api/dashboard/get_email?username=nah_i_win

  */
  Future<void> getEmailByUsername(String? usernameId) async {
    String url =
        '$urlDomain/api/dashboard/get_email_mobile?username=$usernameId';
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
          _result = 'No email found in response data';
          _logger.e('No email found in response data');
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

  /*
  เพิ่ม api เพื่อรับ username จาก email /api/dashboard/get_username 
  ใช้เพื่อเอา username ออกมาโดยใช้ email ในการค้นหาข้อมูล

  GET /api/dashboard/get_username?email=<email>
  https://api-voice-staging.botnoi.ai/api/dashboard/get_username_id?email=porton555@gmail.com

  */
  Future<void> getUsernameByEmail(String? email) async {
    // Make the request
    String url = '$urlDomain/api/dashboard/get_username_id?email=$email';
    Map<String, String> headers = {
      'X-API-BOTNOI': 'Ym90b25vaQ',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _result = data.toString(); // เก็บผลลัพธ์ไว้ในตัวแปร
        _logger.d('Response Data: $_result');
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
}
