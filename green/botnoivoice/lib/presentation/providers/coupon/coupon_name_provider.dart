import 'dart:convert';
import 'package:botnoivoice/presentation/configurations/api_url_config.dart';
import 'package:botnoivoice/presentation/providers/user/get_jwt_token.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

class CouponNameProvider with ChangeNotifier {
  final _logger = Logger();
  String? _errorMessage;
  String? _couponName;

  /// Getter for the error message
  String? get errorMessage => _errorMessage;
  String? get getCouponName => _couponName;

  String urlGetNotification =
      '$apiUrl/api/warning/notification/get_notification';
  String urlGetNotificationDetail =
      '$apiUrl/api/warning/notification/get_notification_detail';

  /// Load coupon code
  Future<void> loadCodeName(BuildContext context) async {
    try {
      _logger.d('Starting checkCoupon');
      final jwtToken = await _fetchJwtToken(context);
      if (jwtToken == null) {
        _logger.e('ID token is null');
        return;
      }

      _logger.d('Fetched ID token: $jwtToken');

      final couponCode = await getCouponCode(context);
      if (couponCode == null) {
        _logger.e('Coupon code is null');
        return;
      }
    } catch (e) {
      _errorMessage = 'เกิดข้อผิดพลาด: $e';
      _logger.e(_errorMessage);
      notifyListeners();
    }
  }

  Future<String?> _fetchJwtToken(BuildContext context) async {
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

  Future<String?> getCouponCode(BuildContext context) async {
    // Fetch JWT token
    final jwtToken = await _fetchJwtToken(context);
    if (jwtToken == null) {
      _logger.e('ID token is null');
      return null;
    }

    // Step 1: Get notif_id from the first API response
    final response1 = await http.get(
      Uri.parse(urlGetNotification),
      headers: {
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response1.statusCode == 200) {
      final data1 = json.decode(response1.body);
      final notifId = data1['data']['notifs'][0]['notif_id'];

      // Step 2: Call the second API with notif_id to get coupon code
      final response2 = await http.get(
        Uri.parse('$urlGetNotificationDetail?notif_id=$notifId'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response2.statusCode == 200) {
        final data2 = json.decode(response2.body);
        final message = data2['data']['message'];
        _couponName = extractCouponCode(message);

        // Step 3: Extract coupon code from message in response
        return extractCouponCode(message);
      }
    }

    return null;
  }

  String? extractCouponCode(String message) {
    final regex = RegExp(r'✨\s*([A-Z]{2}\d{4})\s*✨');
    final match = regex.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }
}
