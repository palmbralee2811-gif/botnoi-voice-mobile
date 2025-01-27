import 'dart:convert';
import 'package:botnoivoice/presentation/configurations/api_url_config.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// Provider and interface to the main server
class LineTokenProvider extends ChangeNotifier {
  String? _userID;
  String? _jwtToken;
  String? _remainingCredits;
  String? _credentialsToken;
  final Logger _logger = Logger(); // For debugging

  /// Getter for the user ID from Database after login
  String? get getUserID => _userID;

  /// Getter for the json web token after login
  String? get getJwtToken => _jwtToken;

  /// Getter for the remaining credits
  String? get getRemainingCredits => _remainingCredits;

  /// Getter for the credentials token
  String? get getCredentialsToken => _credentialsToken;

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

  /// Loading LINE JWT Token from API
  Future<void> loadJwtToken(BuildContext context) async {
    String? idToken =
        Provider.of<LineLoginProvider>(context, listen: false).getIdTokenRaw;
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
        var data = json.decode(response.body);
        _userID = data['data']['uid'].toString();
        _remainingCredits = data['data']['credits'].toString();
        //TODO: get user daily quota to generate voice.
        notifyListeners();
        _logger.i('User ID successfully loaded: $_userID');
        _logger.i('Remaining credits successfully loaded: $_remainingCredits');
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
