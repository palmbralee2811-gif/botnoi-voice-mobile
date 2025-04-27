import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// LINE: Token, User Profile Data and Credentials
class LineToken extends ChangeNotifier {
  String? _userID;
  String? _jwtToken;
  String? _remainingCredits;
  String? _credentialsToken;
  String? _quotaDownload;

  bool _isSubscription = false;

  final Logger _logger = Logger(); // For debugging

  /// Getter for the user ID from Database after login
  String? get getUserID => _userID;

  /// Getter for the json web token after login
  String? get getJwtToken => _jwtToken;

  /// Getter for the remaining credits
  String? get getRemainingCredits => _remainingCredits;

  /// Getter for the credentials token
  String? get getCredentialsToken => _credentialsToken;

  /// Getter for the user daily quota
  String? get getQuotaDownload => _quotaDownload;

  // Getter for the user subscription
  bool get isSubscription => _isSubscription;

  /// Clear all the tokens
  void clearTokens() {
    _userID = null;
    _jwtToken = null;
    _remainingCredits = null;
    _credentialsToken = null;
    _quotaDownload = null;
    _isSubscription = false;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  /// Loading LINE JWT Token from API
  Future<void> loadJwtToken(BuildContext context) async {
    String? idToken = context.read<LineLogin>().getIdTokenRaw;
    if (idToken == null) {
      _logger.e("Error: Google idToken is null");
      return;
    }

    String url = '$apiUrl/api/dashboard/liff';
    Map<String, String> headers = {
      'Botnoi-Token': 'Bearer $idToken',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _logger.i("Response data: $data");
        var message = data['message'];
        var tokenIndex = message.indexOf('token=');

        // Check if the token was found
        if (tokenIndex != -1) {
          var tokenStartIndex = tokenIndex + 'token='.length;
          _jwtToken = message.substring(tokenStartIndex);
          notifyListeners();
          _logger.i('JWT Token successfully loaded.');
        } else {
          _logger.w('Token not found in response message: $message');
        }
      } else {
        _logger.e('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error fetching JWT Token: $e');
    }
  }

  /// Loading the remaining credits from API
  Future<void> loadRemainingCredits() async {
    if (_jwtToken == null) return;

    String url = '$apiUrl/api/dashboard/get_profile';
    Map<String, String> headers = {
      'Authorization': 'Bearer $_jwtToken',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        // Logging Profile Data
        var data = json.decode(response.body);
        _logger.i('Get Profile Data: $data');

        _userID = data['data']['uid'].toString();
        _remainingCredits = data['data']['credits'].toString();
        _quotaDownload = data['data']['quota_download'].toString();
        _isSubscription = data['data']['subscription']?.toString() ==
            'Pro'; // Check ว่าผู้ใช้ได้ Subscription ไหม
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

  /// Loading the credentials token from API
  Future<void> loadCredentials() async {
    if (_jwtToken == null) return;

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
