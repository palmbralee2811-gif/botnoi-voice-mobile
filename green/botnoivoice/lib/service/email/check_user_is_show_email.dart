import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/config/get_user_id.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Class to check user show email
class CheckUserIsShowEmail with ChangeNotifier {
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  String? _errorMessage;
  bool _isShowEmail = false;

  bool get isShowEmail => _isShowEmail;
  String? get errorMessage => _errorMessage;

  /// Fetch user information
  Future<void> getUserInfoShowMail(BuildContext context) async {
    try {
      final userId = await getUserIdEmail(context);
      final response = await _dio
          .get('$apiUrl/api/dashboard/get_user_info_un_auth?user_id=$userId');

      if (response.statusCode == 200) {
        _isShowEmail = response.data['data']?['show_mail'];
        _logger.i("show_mail: $_isShowEmail");
        _clearError();
      } else {
        throw Exception(
            "Failed to fetch user info. Status code: ${response.statusCode}");
      }
    } catch (error) {
      _setError("Error fetching user info: $error");
    }
  }

  /// Update Email Permission
  Future<void> updateUserInfoShowMail(
      BuildContext context, bool showEmail) async {
    try {
      final userId = await getUserIdEmail(context);
      // DO NOT CHANGE THIS METHOD, GET IS CORRECT!!!
      final response = await _dio.get(
          '$apiUrl/api/dashboard/users_info_show_email?user_id=$userId&show_email=$showEmail');

      if (response.statusCode == 200) {
        _isShowEmail = showEmail; // Update the value
        _logger.i(
            "show_email updated successfully. \nUser ID: $userId \nshow_email: $showEmail");
        notifyListeners(); // Notify the listeners to update the UI
        _clearError();
      } else {
        throw Exception(
            "Failed to update show_email. Status code: ${response.statusCode}");
      }
    } catch (error) {
      _setError("Error updating show_email: $error");
    }
  }

  /// Set error message and notify listeners
  void _setError(String message) {
    _errorMessage = message;
    _logger.e(message);
    notifyListeners();
  }

  /// Clear error message and notify listeners
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
