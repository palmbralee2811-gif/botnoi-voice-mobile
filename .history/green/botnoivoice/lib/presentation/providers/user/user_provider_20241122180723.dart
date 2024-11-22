import 'package:botnoivoice/presentation/services/line_service.dart';
import 'package:botnoivoice/core/revenuecat_config.dart';
import 'package:botnoivoice/presentation/constants/api_url_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Provider for User Information 
class UserProvider with ChangeNotifier {
  final Dio _dio = Dio();
  final Logger _logger = Logger();
  String? _errorMessage;
  bool? _isShowEmail;

  bool? get isShowEmail => _isShowEmail;
  String? get errorMessage => _errorMessage;

  /// Get Email Permission is TRUE or FALSE in ['show_mail']
  Future<void> getUserInfo() async {
    
    final String url = '$baseApiUrl/db/dashboard/users_info/$userId';
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null && data.containsKey('show_mail')) {
          _isShowEmail = data['show_mail'];
          _logger.i("show_mail: $_isShowEmail");
        }
      } else {
        _errorMessage =
            'Failed to fetch user info. Status code: ${response.statusCode}';
        _logger.e(_errorMessage);
      }
    } catch (error) {
      _errorMessage = 'Error occurred while fetching user info: $error';
      _logger.e(_errorMessage);
    } finally {
      notifyListeners();
    }
  }

  //TODO: How to use this function?
  //TODO: Testing this APIs with Backend Team 
  /// Update Email Permission to TRUE or FALSE in ['show_email']
  Future<void> updateShowEmail(bool value) async {
    
    final String url = '$baseApiUrl/db/dashboard/users_info_show_email/$userId';
    try {
      final response = await _dio.post(url, data: {'show_email': value});
      if (response.statusCode == 200) {
        _isShowEmail = value;
        _logger.i("show_email updated successfully to $value");
        _errorMessage = null;
      } else {
        _errorMessage =
            'Failed to update show_email. Status code: ${response.statusCode}';
        _logger.e(_errorMessage);
      }
    } catch (error) {
      _errorMessage = 'Error occurred while updating show_email: $error';
      _logger.e(_errorMessage);
    } finally {
      notifyListeners();
    }
  }
}