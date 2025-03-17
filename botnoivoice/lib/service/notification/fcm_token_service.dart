import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/function/get_user_id.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// Firebase Cloud Messaging Token Service for `push_notification_service.dart`
class FcmTokenService with ChangeNotifier {
  final _logger = Logger();
  String? _errorMessage;
  bool _isLoading = false; // เช็คสถานะกำลังโหลด

  /// Getter for error message
  String? get errorMessage => _errorMessage;

  /// Getter for loading status
  bool get isLoading => _isLoading;

  /// ฟังก์ชันเซ็ตค่า `isLoading` และแจ้งให้ UI อัปเดต
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// ฟังก์ชันดึง FCM Token ตาม user_id
  Future<String?> getFcmToken(BuildContext context) async {
    _setLoading(true);
    try {
      _logger.d('Fetching User ID...');
      final userId = await getUserIdAll(context);

      if (userId.isEmpty) {
        _errorMessage = "Error: User ID is empty";
        _logger.e(_errorMessage);
        return null;
      }

      final url = Uri.parse('$apiUrl/db/dashboard/get_fcm_token/$userId');
      _logger.d('Requesting FCM Token from: $url');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        _logger.d('FCM Token Response: $data');

        return data['data']['fcm_token'];
      } else {
        _errorMessage = 'Failed to fetch FCM Token: ${response.statusCode}';
        _logger.e(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Exception occurred while fetching FCM Token: $e';
      _logger.e(_errorMessage);
    } finally {
      _setLoading(false);
    }
    return null;
  }

  /// ฟังก์ชันอัปเดต FCM Token
  Future<bool> updateFcmToken(BuildContext context, String newFcmToken) async {
    _setLoading(true);
    try {
      _logger.d('Fetching User ID...');
      final userId = await getUserIdAll(context);

      if (userId.isEmpty) {
        _errorMessage = "Error: User ID is empty";
        _logger.e(_errorMessage);
        return false;
      }

      final url = Uri.parse('$apiUrl/db/dashboard/update_fcm_token');
      _logger.d('Updating FCM Token at: $url');

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": userId,
          "fcm_token": newFcmToken,
        }),
      );

      if (response.statusCode == 200) {
        // Clear Error Message
        _errorMessage = null;
        _logger.d('FCM Token Updated Successfully');
        return true;
      } else {
        _errorMessage = 'Failed to update FCM Token: ${response.statusCode}';
        _logger.e(_errorMessage);
      }
    } catch (e) {
      _errorMessage = 'Exception occurred while updating FCM Token: $e';
      _logger.e(_errorMessage);
    } finally {
      _setLoading(false);
    }
    return false;
  }
}
