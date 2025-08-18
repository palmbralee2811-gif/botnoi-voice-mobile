import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:botnoivoice/shared/function/get_jwt_token.dart';
import 'package:botnoivoice/shared/function/call_reload_data.dart';
import 'package:provider/provider.dart';

class RewardService with ChangeNotifier {
  final _logger = Logger();
  String? _errorMessage;
  bool _isLoading = false; // ตัวแปรเช็คสถานะกำลังโหลด

  /// Getter for error message
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  /// ฟังก์ชันเซ็ตค่า `isLoading` และแจ้งให้ UI อัปเดต
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// ฟังก์ชันตรวจสอบและใช้คูปอง 100 เครดิต
  Future<void> checkCoupon100(BuildContext context) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _logger.d('Starting checkCoupon100');
      final jwtToken = await _fetchJwtToken(context);
      // ถ้า _fetchJwtToken ล้มเหลว มันจะตั้ง _errorMessage และคืน null
      if (jwtToken == null) {
        _logger.e('checkCoupon100: Failed to get JWT token.');

        return;
      }

      final couponCode = await _getCouponNameForToday();

      // --- จุดแก้ไขสำคัญ ---
      if (couponCode == null) {
        if (_errorMessage == null) {
          _errorMessage = 'reward_service.no_daily_coupon_to_redeem'
              .tr(); // <<-- ตั้งค่า Error Message เฉพาะที่นี่
          _logger.w(
              'checkCoupon100: No daily coupon code available to redeem ($_errorMessage)');
        } else {
          _logger.e(
              'checkCoupon100: Error occurred while getting coupon name: $_errorMessage');
        }
        return;
      }
      // ---------------
      _logger.d('Calling _callCheckCouponApi with couponCode: $couponCode');
      await _callCheckCouponApi(jwtToken, couponCode);
    } catch (e) {
      // ดักจับ Exception ที่อาจเกิดขึ้นนอกเหนือจากที่ handle ไปแล้ว
      _errorMessage = '${'reward_service.error_message'.tr()} $e';
      _logger.e('Exception in checkCoupon100: $_errorMessage');
    } finally {
      _setLoading(false); // โหลดเสร็จเสมอ
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
      final url = '$apiUrl/api/stripe/get_education';
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
        final creditsProvider = context.read<CallReloadData>();
        await creditsProvider.callLoadCreditsApi(context);
        _logger.d('Successfully get education subscription.');
      } else {
        // Handle errors
        if (response.statusCode == 403) {
          if (response.body.contains('already have subscription')) {
            _errorMessage = 'reward_service.already_subscribed'.tr();
          } // ถ้าเป็นสมาชิกอยู่แล้ว
          else if (response.body.contains('invalid sign in provider')) {
            _errorMessage = 'reward_service.failure_provider'.tr();
          } // ถ้าไม่ผ่านเงื่อนไข
          else if (response.body
              .contains('invalid domain adn whitelist education')) {
            _errorMessage = 'reward_service.failcase_whitelist'.tr();
          } // ถ้าไม่ได้สมัครสมาชิก

          else {
            _errorMessage = 'reward_service.failure_case'.tr();
          }
        } else {
          // สำหรับ Error อื่นๆ
          final responseBody = jsonDecode(response.body);
          _errorMessage = responseBody['detail'] ??
              '${'reward_service.failure_case'.tr()} (Code: ${response.statusCode})';
        }
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
    _setLoading(true);
    String? localErrorMessageForThisCall; // เก็บ error message เฉพาะการเรียกนี้

    try {
      _logger.d(
          'Fetching daily coupon name from $apiUrl/api/coupon/get_coupon_daily');
      final response =
          await http.get(Uri.parse('$apiUrl/api/coupon/get_coupon_daily'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String? couponName = data['coupon_name'];

        if (couponName != null && couponName.isNotEmpty) {
          _logger.i('Daily coupon name for today: $couponName');
          _errorMessage = null;
          return couponName;
        } else {
          _logger.i(
              'No daily coupon name found (API returned 200 OK but no/empty name). This is treated as "no coupon data".');
          _errorMessage = null;
          return null;
        }
      } else if (response.statusCode == 404) {
        _logger.i(
            'No daily coupon set for today (API returned 404 Not Found). This is a valid "no coupon" state.');
        _errorMessage = null;
        return null;
      } else {
        localErrorMessageForThisCall =
            'Failed to fetch daily coupon name: ${response.statusCode} - ${response.body.substring(0, (response.body.length > 150) ? 150 : response.body.length)}';
        _logger.e(localErrorMessageForThisCall);
        _errorMessage = localErrorMessageForThisCall;
        return null;
      }
    } catch (e) {
      // เกิด Exception ระหว่างการเรียก API
      localErrorMessageForThisCall = 'Exception fetching daily coupon name: $e';
      _logger.e(localErrorMessageForThisCall);
      _errorMessage =
          localErrorMessageForThisCall; // ตั้งเป็น error ของ Service
      return null;
    } finally {
      _setLoading(false);
    }
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