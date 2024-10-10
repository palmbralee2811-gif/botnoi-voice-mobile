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
  เพิ่ม api เพื่อรับ email จาก username /api/dashboard/get_email ใช้เพื่อเอา username 
  ออกมาโดยใช้ email ในการค้นหาข้อมูล

  GET /api/dashboard/get_username?email=<email>

  /api/dashboard/get_email?username=nah_i_win

  */
  Future<void> getEmailByUsername(String? username) async {
    // Make the request
    String url = '$urlDomain/api/dashboard/get_email?username=$username';
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

  */
  Future<void> getUsernameByEmail(String? email) async {
    // Make the request
    String url = '$urlDomain/api/dashboard/get_username?email=$email';
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
