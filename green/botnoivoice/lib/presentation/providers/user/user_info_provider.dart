import 'package:botnoivoice/presentation/constants/api_url_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';

//TODO: Testing all functions in this provider!!!
/// Provider for managing user information
class UserInfoProvider with ChangeNotifier {
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  String? _errorMessage;
  bool? _isShowEmail;

  bool? get isShowEmail => _isShowEmail;
  String? get errorMessage => _errorMessage;

  /// Fetch User ID from Email Provider
  Future<String> getUserId(BuildContext context) async {
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);

    if (emailProvider.isLoggedIn &&
        emailProvider.user?.providerData[0].providerId == 'password') {
      return emailProvider.user!.uid; // Return user ID if logged in
    }

    // Handle case where user is not logged in
    _setError("User is not logged in.");
    throw Exception(_errorMessage);
  }

  /// Fetch user information
  Future<void> getUserInfoShowMail(BuildContext context) async {
    try {
      final userId = await getUserId(context);
      final response = await _dio.get(
          '$baseApiUrl/api/dashboard/get_user_info_un_auth?user_id=$userId');

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
  Future<void> updateUserInfoShowMail(BuildContext context, bool showEmail) async {
    try {
      final userId = await getUserId(context);
      final response = await _dio.get(
          '$baseApiUrl/api/dashboard/users_info_show_email?user_id=$userId&show_email=$showEmail');

      if (response.statusCode == 200) {
        _logger.i("show_email updated successfully. \nUser ID: $userId \nshow_email: $showEmail");
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
