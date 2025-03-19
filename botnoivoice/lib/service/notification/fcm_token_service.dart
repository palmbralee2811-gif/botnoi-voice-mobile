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

  /// Loading status
  bool _isLoading = false;

  /// Getter for error message
  String? get errorMessage => _errorMessage;

  /// Getter for loading status
  bool get isLoading => _isLoading;

  /// Set `isLoading` and notify UI
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Fetch User ID
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

  /// Update FCM Token with PUT Method Request to Database
  /// Set FCM Token when user login
  Future<bool> updateFcmToken(BuildContext context, String fcmToken) async {
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

  /// Delete FCM Token with PUT Method Request to Database
  /// Set FCM Token to `null` when user logout
  Future<bool> deleteFcmToken(BuildContext context) async {
    _setLoading(true);
    try {
      final userId = await _fetchUserId(context);
      if (userId == null) return false;

      final uri = Uri.parse('$apiUrl/db/dashboard/update_fcm_token');
      final headers = {"Content-Type": "application/json"};

      /// Set FCM Token to `null` when user logout
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
