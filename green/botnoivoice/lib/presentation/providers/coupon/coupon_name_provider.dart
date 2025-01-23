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

  /*
    //TODO: 12:47 reponse ไม่มีข้อมูล คือต้องเฉพาะเวลา 08:00 AM. ของทุกวันใช่ไหม???

    {
      "message": "success",
      "data": {
          "user_id": "ybcnHeHNbTNZpR6tLckDV2g9CfN2",
          "notifs": [],
          "start_date": "2025-01-24T00:51:04.375645618Z"
      }
    }
  */


  String urlGetNotificationDetail =
      '$apiUrl/api/warning/notification/get_notification_detail';

  /// Load coupon code
  Future<void> loadCodeName(BuildContext context) async {
    try {
      final notifId = await _getNotifId(context);
      if (notifId != null) {
        final couponCode = await _getCouponCode(context, notifId);
        if (couponCode != null) {
          _couponName = couponCode;
          notifyListeners();
        } else {
          _errorMessage = 'Failed to extract coupon code';
        }
      } else {
        _errorMessage = 'Failed to get notification ID';
      }
    } catch (e) {
      _logger.e('Error loading coupon code: $e');
      _errorMessage = 'Error loading coupon code';
    }
  }

  /// Get notification ID from the first API response
  Future<String?> _getNotifId(BuildContext context) async {
    final jwtToken = await getJwtTokenAll(context);
    if (jwtToken == null) {
      _logger.e('Failed to get JWT token');
      return null;
    }

    final response = await http.get(
      Uri.parse(urlGetNotification),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _logger.d('API Response Data: $data');
      final notifs = data['data']['notifs'];
      if (notifs.isNotEmpty) {
        final notifId = notifs[0]['notif_id'];
        _logger.d('Notification ID: $notifId');
        return notifId;
      } else {
        _logger.e('No notifications found');
        return null;
      }
    } else {
      _logger.e('Failed to fetch notifications');
      return null;
    }
  }

  /// Get coupon code from the second API response
  Future<String?> _getCouponCode(BuildContext context, String notifId) async {
    final jwtToken = await getJwtTokenAll(context);
    if (jwtToken == null) {
      _logger.e('Failed to get JWT token');
      return null;
    }

    final response = await http.get(
      Uri.parse('$urlGetNotificationDetail?notif_id=$notifId'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final message = data['data']['message'];

      _logger.d('Message before using RegExp: $message');
      final couponCode = extractCouponCode(message);
      _logger.d('Extracted Coupon Code: $couponCode');
      return couponCode;
    } else {
      _logger.e('Failed to fetch notification detail');
      return null;
    }
  }

  /// Extract coupon code from message
  String? extractCouponCode(String message) {
    final regex = RegExp(r'✨\s*([A-Z]{2}\d{4})\s*✨');
    final match = regex.firstMatch(message);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }
}
