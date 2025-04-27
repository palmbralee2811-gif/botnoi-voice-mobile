import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// Firebase Cloud Messaging Token Service
class FcmTokenService with ChangeNotifier {
  final Logger _logger = Logger();
  String? _errorMessage;

  bool _isLoading = false;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Update FCM Token by User ID (ไม่ใช้ context)
  Future<bool> updateFcmTokenByUserId(String userId, String fcmToken) async {
    _setLoading(true);
    try {
      final uri = Uri.parse('$apiUrl/db/dashboard/update_fcm_token');
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode({"user_id": userId, "fcm_token": fcmToken});

      _logger.d('Updating FCM Token: $uri');
      final response = await http.put(uri, headers: headers, body: body);
      
      _logger.d('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        _errorMessage = null;
        _logger.d('✅ FCM Token Updated Successfully');
        return true;
      } else {
        _errorMessage = '❌ Failed to update FCM Token';
        _logger.e(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Error during FCM Token update: $e';
      _logger.e(_errorMessage);
    } finally {
      _setLoading(false);
    }
    return false;
  }

  /// Delete FCM Token by User ID (ไม่ใช้ context)
  Future<bool> deleteFcmTokenByUserId(String userId) async {
    _setLoading(true);
    try {
      final uri = Uri.parse('$apiUrl/db/dashboard/update_fcm_token');
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode({"user_id": userId, "fcm_token": "null"});

      _logger.d('Deleting FCM Token: $uri');
      final response = await http.put(uri, headers: headers, body: body);
      
      _logger.d('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        _errorMessage = null;
        _logger.d('✅ FCM Token Deleted Successfully');
        return true;
      } else {
        _errorMessage = '❌ Failed to delete FCM Token';
        _logger.e(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Error during FCM Token deletion: $e';
      _logger.e(_errorMessage);
    } finally {
      _setLoading(false);
    }
    return false;
  }
}
