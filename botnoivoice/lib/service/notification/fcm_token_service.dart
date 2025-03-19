import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/function/get_user_id.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// DO NOT REMOVE THIS COMMENT
///
/// How to get FCM Token:
///
/// 1. Get all: 
/// - Staging: https://api-voice-staging.botnoi.ai/db/dashboard/get_all_fcm_token
/// - Production: https://api-voice.botnoi.ai/db/dashboard/get_all_fcm_token
///
/// 2. Get by ID:  
/// - userId: User ID from Firebase
/// - Staging: https://api-voice-staging.botnoi.ai/db/dashboard/get_fcm_token/$userId
/// - Production: https://api-voice.botnoi.ai/db/dashboard/get_fcm_token/$userId

/// Firebase Cloud Messaging Token Service for `push_notification_service.dart`
class FcmTokenService with ChangeNotifier {
  final Logger _logger = Logger();
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

  /// ฟังก์ชันดึง userId
  Future<String?> _fetchUserId(BuildContext context) async {
    try {
      _logger.d('Fetching User ID...');
      final userId = await getUserIdAll(context);
      if (userId.isEmpty) {
        _errorMessage = "Error: User ID is empty";
        _logger.e(_errorMessage);
        return null;
      }
      return userId;
    } catch (e) {
      _errorMessage = 'Error fetching user ID: $e';
      _logger.e(_errorMessage);
      return null;
    }
  }

  /// ฟังก์ชันอัปเดต FCM Token
  Future<bool> updateFcmToken(BuildContext context, String newFcmToken) async {
    return await _updateFcmTokenRequest(context, newFcmToken);
  }

  /// ฟังก์ชันลบ FCM Token
  Future<bool> deleteFcmToken(BuildContext context) async {
    return await _deleteFcmTokenRequest(context);
  }

  /// ฟังก์ชันส่ง Request อัปเดต FCM Token
  Future<bool> _updateFcmTokenRequest(BuildContext context, String fcmToken) async {
    _setLoading(true);
    try {
      final userId = await _fetchUserId(context);
      if (userId == null) return false;

      final uri = Uri.parse('$apiUrl/db/dashboard/update_fcm_token');
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode({"user_id": userId, "fcm_token": fcmToken});

      _logger.d('Updating FCM Token: $uri');
      final response = await http.put(uri, headers: headers, body: body);
      
      _logger.d('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        _errorMessage = null;
        _logger.d('FCM Token Updated Successfully');
        return true;
      } else {
        _errorMessage = 'Failed to update FCM Token';
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

  /// ฟังก์ชันส่ง Request ลบ FCM Token
  Future<bool> _deleteFcmTokenRequest(BuildContext context) async {
    _setLoading(true);
    try {
      final userId = await _fetchUserId(context);
      if (userId == null) return false;

      final uri = Uri.parse('$apiUrl/db/dashboard/update_fcm_token');
      final headers = {"Content-Type": "application/json"};
      final body = jsonEncode({"user_id": userId, "fcm_token": "null"});

      _logger.d('Deleting FCM Token: $uri');
      final response = await http.put(uri, headers: headers, body: body);
      
      _logger.d('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        _errorMessage = null;
        _logger.d('FCM Token Deleted Successfully');
        return true;
      } else {
        _errorMessage = 'Failed to delete FCM Token';
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
