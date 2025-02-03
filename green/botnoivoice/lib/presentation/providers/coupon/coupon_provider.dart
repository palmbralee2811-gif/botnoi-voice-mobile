import 'dart:convert';
import 'package:botnoivoice/presentation/configurations/api_url_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:botnoivoice/presentation/providers/user/get_jwt_token.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CouponProvider with ChangeNotifier {
  final _logger = Logger();
  String? _errorMessage;

  /// Getter for the error message
  String? get errorMessage => _errorMessage;

  String url = '$apiUrl/api/coupon/check_coupon';

  Future<void> checkCoupon100(BuildContext context) async {
    try {
      _logger.d('Starting checkCoupon');
      final jwtToken = await _fetchJwtToken(context);
      if (jwtToken == null) {
        _logger.e('ID token is null');
        return;
      }

      _logger.d('Fetched ID token: $jwtToken');

      //TODO: Get `coupon_name` from API
      //TODO: Call API to check `coupon_name`
      final couponCode = await _getCouponNameForToday();
      if (couponCode == null) {
        _logger.e('Coupon code is null');
        return;
      }

      _logger.d(
          'Calling _callCheckCouponApi with jwtToken: $jwtToken and couponCode: $couponCode');
      await _callCheckCouponApi(jwtToken, couponCode);
    } catch (e) {
      _errorMessage = '${'redeem_provider.error_occurred'.tr()} $e'; //เกิดข้อผิดพลาด:
      _logger.e(_errorMessage);
      notifyListeners();
    }
  }

  Future<void> checkCoupon1K(BuildContext context) async {
    try {
      _logger.d('Starting checkCoupon');
      final jwtToken = await _fetchJwtToken(context);
      if (jwtToken == null) {
        _logger.e('ID token is null');
        return;
      }

      _logger.d('Fetched ID token: $jwtToken');

      const couponCode = 'mobile1000';
      _logger.d('Calling _callCheckCouponApi with jwtToken: $jwtToken and couponCode: $couponCode');
      await _callCheckCouponApi(jwtToken, couponCode);
    } catch (e) {
      _errorMessage = '${'redeem_provider.error_occurred'.tr()} $e'; //เกิดข้อผิดพลาด:
      _logger.e(_errorMessage);
      notifyListeners();
    }
  }

  Future<String?> _fetchJwtToken(context) async {
    try {
      final jwtToken = await getJwtTokenAll(context);
      if (jwtToken == null) {
        _errorMessage = 'Failed to fetch ID token';
        _logger.e(_errorMessage);
        notifyListeners();
      }
      return jwtToken;
    } catch (e) {
      _errorMessage = 'Exception occurred while fetching ID token: $e';
      _logger.e(_errorMessage);
      notifyListeners();
      return null;
    }
  }

  Future<String?> _getCouponNameForToday() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/coupon.json');
      List<dynamic> coupons = jsonDecode(jsonString);

      // Initialize timezone data
      tz.initializeTimeZones();
      final bangkok = tz.getLocation('Asia/Bangkok');
      DateTime now = tz.TZDateTime.now(bangkok);
      String todayString = DateFormat('yyyy-MM-dd').format(now);

      _logger.d('Current date (Bangkok time): $todayString');

      for (var coupon in coupons) {
        if (coupon.containsKey('datetime') &&
            coupon.containsKey('coupon_name')) {
          if (coupon['datetime'].startsWith(todayString)) {
            _logger.d('Coupon found for today: ${coupon['coupon_name']}');
            return coupon['coupon_name'];
          }
        } else {
          _logger.w('Invalid coupon data: $coupon');
        }
      }

      _errorMessage = 'No coupon available for today';
      _logger.w(_errorMessage);
      notifyListeners();
      return null;
    } catch (e, stackTrace) {
      _errorMessage = 'Failed to load coupon codes: $e\n$stackTrace';
      _logger.e(_errorMessage);
      notifyListeners();
      return null;
    }
  }

  Future<void> _callCheckCouponApi(
      String jwtToken, String couponName) async {
    try {
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
          _errorMessage = 'redeem_provider.coupon_already_used'.tr(); //คูปองของคุณถูกใช้งานแล้ว
          _logger.e(_errorMessage);
        } else if (message == 'Incorrect Coupon') {
          _errorMessage =
              'redeem_provider.coupon_not_found'.tr(); //ไม่พบคูปองนี้ คูปองอาจจะไม่สามารถใช้งานได้แล้วหรือคูปองที่คุณเพิ่มไม่ถูกต้อง
          _logger.e(_errorMessage);
        } else {
          _errorMessage = 'redeem_provider.coupon_expired_or_not_found'.tr(); //ไม่พบคูปองในระบบ หรือคูปองหมดอายุไปแล้ว
          _logger.e(_errorMessage);
        }
      } else {
        _errorMessage = '${'redeem_provider.api_call_error'.tr()} ${response.statusCode}'; //เกิดข้อผิดพลาดในการเรียก API:
        _logger.e(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Exception occurred: $e';
      _logger.e(_errorMessage);
    }

    notifyListeners();
  }
}
