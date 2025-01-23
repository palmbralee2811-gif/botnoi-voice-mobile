///TODO: get user id from login providers


///TODO: call check coupon api

/*
https://api-voice.botnoi.ai/api/coupon/check_coupon
Method: POST
authorization:
Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3Mzc3MDUxMDEsImlhdCI6MTczNzYxODcwMSwibmJmIjoxNzM3NjE4NzAxLCJ1aWQiOiJhMmZkMjk0Ni01MWZiLTU0ZWEtODY3NC00YjkyYjNiNjNlZDUiLCJ1c2VyX2lkIjoieWJjbkhlSE5iVE5acFI2dExja0RWMmc5Q2ZOMiJ9.iQf-LYIuqb3IaUCGBKb8fK-phABKCWCJqvgoFu-j_Ic

coupon_code: XC0809

Code: 200
XC0809 เติมคูปองสำเร็จแล้ว
{"message":"Use Coupon Success","data":{"status_coupon":"Success","sum":""}}

Code:  200 
คูปองของคุณถูกใช้งานแล้ว
{"message":"already in use","data":{"status_coupon":"","sum":""}}

Code: 200
ไม่พบคูปองนี้ คูปองอาจจะไม่สามารถใช้งานได้แล้วหรือคูปองที่คุณเพิ่มไม่ถูกต้อง
{"message":"Incorrect Coupon","data":{"status_coupon":"","sum":""}}
*/


/*
code เป็น 200 นะ 
ช่ายๆอาจจะได้ดักผ่าน message Strging
มันจะมีแบบไม่มี code นี้ใน ระบบด้วย
Code:  200 (ไม่มี coupon ใน ระบบ หรือ หมดอายุไปแล้ว)
{"message":"Incorrect Coupon","data":{"status_coupon":"","sum":""}}
*/

import 'dart:convert';
import 'package:botnoivoice/presentation/configurations/api_url_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:botnoivoice/presentation/providers/user/get_user_id.dart';
import 'package:botnoivoice/presentation/providers/user/get_id_token.dart';

class CouponProvider with ChangeNotifier {
  final _logger = Logger();

  String? _successMessage;
  String? _errorMessage;

  /// Getter for the success message
  String? get successMessage => _successMessage;

  /// Getter for the error message
  String? get errorMessage => _errorMessage;

  String url = '$apiUrl/api/coupon/check_coupon';

  Future<void> checkCoupon(BuildContext context, String couponCode) async {
    try {
      final userId = await getUserIdAll(context);
      _logger.d('User ID: $userId');

      final idToken = await getIdTokenAll(context);
      if (idToken == null) {
        _errorMessage = 'Failed to fetch ID token';
        _logger.e(_errorMessage);
        notifyListeners();
        return;
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({'coupon_code': couponCode}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final message = responseBody['message'];

        if (message == 'Use Coupon Success') {
          _successMessage = 'เติมคูปองสำเร็จแล้ว';
          _logger.d(_successMessage);
        } else if (message == 'already in use') {
          _errorMessage = 'คูปองของคุณถูกใช้งานแล้ว';
          _logger.w(_errorMessage);
        } else if (message == 'Incorrect Coupon') {
          _errorMessage = 'ไม่พบคูปองนี้ คูปองอาจจะไม่สามารถใช้งานได้แล้วหรือคูปองที่คุณเพิ่มไม่ถูกต้อง';
          _logger.w(_errorMessage);
        } else {
          _errorMessage = 'ไม่พบคูปองในระบบ หรือคูปองหมดอายุไปแล้ว';
          _logger.w(_errorMessage);
        }
      } else {
        _errorMessage = 'เกิดข้อผิดพลาดในการเรียก API: ${response.statusCode}';
        _logger.e(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'เกิดข้อผิดพลาด: $e';
      _logger.e(_errorMessage);
    } finally {
      notifyListeners();
    }
  }
}