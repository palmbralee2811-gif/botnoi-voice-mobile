import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// Email: Token, User Profile Data and Credentials
class EmailToken extends ChangeNotifier {
  String? _userID;
  String? _jwtToken;
  String? _remainingCredits;
  String? _credentialsToken;
  String? _quotaDownload;
  final Logger _logger = Logger(); // For debugging

  /// Getter for the User ID from Database after login
  String? get getUserID => _userID;

  /// Getter for the json web token after login
  String? get getJwtToken => _jwtToken;

  /// Getter for the remaining credits
  String? get getRemainingCredits => _remainingCredits;

  /// Getter for the credentials token
  String? get getCredentialsToken => _credentialsToken;

  /// Getter for the user daily quota
  String? get getQuotaDownload => _quotaDownload;

  /// Clear all the tokens
  void clearTokens() {
    _userID = null;
    _jwtToken = null;
    _remainingCredits = null;
    _credentialsToken = null;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Get the _jwtToken from Firebase
  Future<void> loadJwtToken(BuildContext context) async {
    // Get the idToken from the Authentication provider
    String? idToken = await Provider.of<EmailLogin>(context, listen: false)
        .user
        ?.getIdToken();
    if (idToken == null) {
      _logger.e("Error: Email idToken is null");
      return; // หยุดการทำงานถ้าไม่มี idToken
    }

    // Get the _jwtToken from the Firebase API
    String url = '$apiUrl/api/dashboard/sign_in';

    Map<String, String> headers = {
      'firebase-token': 'Bearer $idToken',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _logger.i('Response data: $data');

        if (data['data'] != null && data['data']['token'] != null) {
          _jwtToken = data['data']['token'];
          notifyListeners();
          _logger.i('JWT Token successfully loaded.');
        } else {
          _logger.w('Token not found in response data.');
        }
      } else {
        _logger.e('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error fetching JWT Token: $e');
    }
  }

  /// Get the remaining credits using _jwtToken
  Future<void> loadRemainingCredits() async {
    // Check if _jwtToken exists
    if (_jwtToken == null) return;

    // Make the request
    String url = '$apiUrl/api/dashboard/get_profile';
    Map<String, String> headers = {
      'Authorization': 'Bearer $_jwtToken',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _userID = data['data']['uid'].toString();
        _remainingCredits = data['data']['credits'].toString();
        _quotaDownload = data['data']['quota_download'].toString();
        notifyListeners();
        _logger.i('User ID successfully loaded: $_userID');
        _logger.i('Remaining credits successfully loaded: $_remainingCredits');
        _logger.i('Quota download successfully loaded: $_quotaDownload');
      } else {
        _logger
            .e("Failed to retrieve remaining credits: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e('Error fetching remaining credits: $e');
    }
  }

  /// Get the credentials token using _jwtToken
  Future<void> loadCredentials() async {
    // Check if _jwtToken exists
    if (_jwtToken == null) return;

    // Make the request
    String url = '$apiUrl/api/service/get_token';
    Map<String, dynamic> payload = {};
    Map<String, String> headers = {
      'Authorization': 'Bearer $_jwtToken',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _credentialsToken = data['data'][0]['token'].toString();
        notifyListeners();
        _logger.i('Credentials token successfully loaded.');
      } else {
        _logger.e('Failed to load Credentials-Token: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error fetching Credentials-Token: $e');
    }
  }
}
