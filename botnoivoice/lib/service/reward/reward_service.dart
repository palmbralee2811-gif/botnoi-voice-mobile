import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:botnoivoice/shared/function/get_jwt_token.dart';

class RewardService with ChangeNotifier {
  final _logger = Logger();
  String? _errorMessage;
  bool _isLoading = false; // ตัวแปรเช็คสถานะกำลังโหลด

  /// Getter for error message
  String? get errorMessage => _errorMessage;

  /// Getter for loading status
  bool get isLoading => _isLoading;

  /// ฟังก์ชันเซ็ตค่า `isLoading` และแจ้งให้ UI อัปเดต
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// ฟังก์ชันตรวจสอบและใช้คูปอง 100 เครดิต
  Future<void> checkCoupon100(BuildContext context) async {
    _setLoading(true); // เริ่มโหลด
    try {
      _logger.d('Starting checkCoupon100');
      final jwtToken = await _fetchJwtToken(context);
      if (jwtToken == null) return;

      final couponCode = await _getCouponNameForToday();
      if (couponCode == null) return;

      _logger.d('Calling _callCheckCouponApi with couponCode: $couponCode');
      await _callCheckCouponApi(jwtToken, couponCode);
    } catch (e) {
      _errorMessage = '${'reward_service.error_message'.tr()} $e';
      _logger.e(_errorMessage);
    } finally {
      _setLoading(false); // โหลดเสร็จ
    }
  }

  /// ฟังก์ชันตรวจสอบและใช้คูปอง 1,000 เครดิต
  Future<void> checkCoupon1K(BuildContext context) async {
    _setLoading(true);
    try {
      _logger.d('Starting checkCoupon1K');
      final jwtToken = await _fetchJwtToken(context);
      if (jwtToken == null) return;

      // Set the coupon code to redeem
      const couponCode = 'mobile1000';
      _logger.d('Calling _callCheckCouponApi with couponCode: $couponCode');
      await _callCheckCouponApi(jwtToken, couponCode);
    } catch (e) {
      _errorMessage = '${'reward_service.error_message'.tr()} $e';
      _logger.e(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  // ADDED: education subscription
  Future<void> getEducationSubscription(BuildContext context) async {
    _setLoading(true);
    try {
      _logger.d('Starting getEducationSubscription');
      final jwtToken = await _fetchJwtToken(context);
      if (jwtToken == null) {
        _setLoading(false);
        return;
      }
      // API Endpoint for education subscription
      final url =
          'https://api-voice-staging.botnoi.ai/api/stripe/get_education';
      _logger.d('Calling GET request to $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer $jwtToken",
        },
      );

      _logger.d('Received response with status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        _errorMessage = null;
        _logger.d('Successfully get education subscription.');
      } else {
        // Handle errors
        final responseBody = jsonDecode(response.body);
        _errorMessage = responseBody['detail'] ??
            'Failed to get subscription. Status code: ${response.statusCode}';
        _logger.e(_errorMessage);
      }
    } catch (e) {
      _errorMessage = '${'reward_service.error_message'.tr()} $e';
      _logger.e(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  /// ฟังก์ชันดึง JWT Token
  Future<String?> _fetchJwtToken(BuildContext context) async {
    try {
      final jwtToken = await getJwtTokenAll(context);
      if (jwtToken == null) {
        _errorMessage = 'Failed to fetch ID token';
        _logger.e(_errorMessage);
      }
      return jwtToken;
    } catch (e) {
      _errorMessage = 'Exception occurred while fetching ID token: $e';
      _logger.e(_errorMessage);
      return null;
    }
  }

  /// ฟังก์ชันดึงชื่อคูปองที่ใช้ได้ในวันนี้
  Future<String?> _getCouponNameForToday() async {
    _setLoading(true); // เริ่มโหลด
    try {
      // เรียก API เพื่อดึงข้อมูลคูปอง
      final response =
          await http.get(Uri.parse('$apiUrl/api/coupon/get_coupon_daily'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // ดึง `coupon_name` มาใช้งานโดยตรง
        final String? couponName = data['coupon_name'];
        if (couponName != null) {
          _errorMessage = null;
          _logger.d('Coupon name: $couponName');
          return couponName;
        }
      } else {
        _errorMessage = 'Failed to fetch coupon';
        _logger.e('Failed to fetch coupon: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = 'Error fetching coupon: $e';
      _logger.e(_errorMessage);
    } finally {
      _setLoading(false); // โหลดเสร็จ
    }
    return null;
  }

  Future<void> _callCheckCouponApi(String jwtToken, String couponName) async {
    _setLoading(true);
    try {
      String url = '$apiUrl/api/coupon/check_coupon';

      _logger.d('Sending POST request to $url with couponCode: $couponName');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer $jwtToken",
        },
        body: jsonEncode({'coupon_name': couponName}),
      );

      _logger.d('Received response with status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final message = responseBody['message'];
        _logger.d('Response body: $responseBody');

        if (message == 'Use Coupon Success') {
          _errorMessage = null;
          _logger.d('Coupon redeemed successfully $couponName');
        } else if (message == 'already in use') {
          //คูปองของคุณถูกใช้งานแล้ว
          _errorMessage = 'reward_service.coupon_already_used'.tr();
          _logger.e(_errorMessage);
        } else if (message == 'Incorrect Coupon') {
          //ไม่พบคูปองนี้ คูปองอาจจะไม่สามารถใช้งานได้แล้วหรือคูปองที่คุณเพิ่มไม่ถูกต้อง
          _errorMessage = 'reward_service.coupon_not_found'.tr();
          _logger.e(_errorMessage);
        } else {
          //ไม่พบคูปองในระบบ หรือคูปองหมดอายุไปแล้ว
          _errorMessage = 'reward_service.coupon_expired_or_not_found'.tr();
          _logger.e(_errorMessage);
        }
      } else {
        //เกิดข้อผิดพลาดในการเรียก API:
        _errorMessage =
            '${'reward_service.api_call_error'.tr()} ${response.statusCode}';
        _logger.e(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Exception occurred: $e';
      _logger.e(_errorMessage);
    } finally {
      _setLoading(false);
    }
  }
}
