import 'dart:convert';
import 'package:botnoivoice/presentation/configurations/api_url_config.dart';
import 'package:botnoivoice/presentation/providers/coupon/get_coupon_name.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:botnoivoice/presentation/providers/user/get_jwt_token.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

class CouponProvider with ChangeNotifier {
  final _logger = Logger();
  String? _errorMessage;

  /// Getter for the error message
  String? get errorMessage => _errorMessage;

  String url = '$apiUrl/api/coupon/check_coupon';

  Future<void> checkCoupon(BuildContext context) async {
    try {
      _logger.d('Starting checkCoupon');
      final jwtToken = await _fetchJwtToken(context);
      if (jwtToken == null) {
        _logger.e('ID token is null');
        return;
      }

      _logger.d('Fetched ID token: $jwtToken');

      // final couponCode = await _getCouponCodeForToday();
      // if (couponCode == null) {
      //   _logger.e('Coupon code is null');
      //   return;
      // }

      String? couponCode = Provider.of<CouponNameProvider>(context, listen: false).getCouponName;

      _logger.d(
          'Calling _callCheckCouponApi with jwtToken: $jwtToken and couponCode: $couponCode');
      await _callCheckCouponApi(jwtToken, couponCode!);
    } catch (e) {
      _errorMessage = 'เกิดข้อผิดพลาด: $e';
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

  Future<String?> _getCouponCodeForToday() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/data/coupon.json');
      List<dynamic> coupons = jsonDecode(jsonString);

      DateTime now = DateTime.now()
          .toUtc()
          .add(const Duration(hours: 7)); // Convert to Bangkok time
      String todayString = now.toIso8601String().split('T')[0];

      _logger.d('Current date (Bangkok time): $todayString');

      for (var coupon in coupons) {
        if (coupon['datetime'].startsWith(todayString)) {
          _logger.d('Coupon found for today: ${coupon['coupon_name']}');
          return coupon['coupon_name'];
        }
      }

      _errorMessage = 'No coupon available for today';
      _logger.w(_errorMessage);
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'Failed to load coupon codes: $e';
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
          _errorMessage = 'คูปองของคุณถูกใช้งานแล้ว $couponName';
          _logger.e(_errorMessage);
        } else if (message == 'Incorrect Coupon') {
          _errorMessage =
              'ไม่พบคูปองนี้ คูปองอาจจะไม่สามารถใช้งานได้แล้วหรือคูปองที่คุณเพิ่มไม่ถูกต้อง $couponName';
          _logger.e(_errorMessage);
        } else {
          _errorMessage = 'ไม่พบคูปองในระบบ หรือคูปองหมดอายุไปแล้ว $couponName';
          _logger.e(_errorMessage);
        }
      } else {
        _errorMessage = 'เกิดข้อผิดพลาดในการเรียก API: ${response.statusCode}';
        _logger.e(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Exception occurred: $e';
      _logger.e(_errorMessage);
    }

    notifyListeners();
  }
}
