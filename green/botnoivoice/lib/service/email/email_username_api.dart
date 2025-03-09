import 'dart:convert';
import 'package:botnoivoice/config/api_key_config.dart';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class EmailUsernameApi extends ChangeNotifier {
  String? _getUsername;
  final Logger _logger = Logger();
  String _result = '';

  /// Getter for Login with Email or Username
  String? get getUsername => _getUsername;

  /// Getter for result of getEmailByUsername, getUsernameByEmail
  String get result => _result;

  Future<void> postSendUsernameToDatabase(
      String? uid, String? username, String? email) async {
    String url = '$apiUrl/api/dashboard/register_mobile';

    Map<String, dynamic> payload = {
      'user_id': uid,
      'username': username,
      'email': email,
    };

    Map<String, String> headers = {
      'X-API-BOTNOI': emailUsernameApiKey,
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(Uri.parse(url),
          headers: headers, body: jsonEncode(payload));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        _result = data.toString();
        _logger.d('Response Data: $_result');
        notifyListeners();
      } else {
        _result =
            'Failed to register user. Status Code: ${response.statusCode}';
        _logger.e('Failed with status code: ${response.statusCode}');
        notifyListeners();
      }
    } catch (e) {
      _result = 'Error: $e';
      _logger.e('Error: $e');
      notifyListeners();
    }
  }

  Future<void> getEmailByUsername(String? usernameId) async {
    String url = '$apiUrl/api/dashboard/get_email_mobile?username=$usernameId';
    Map<String, String> headers = {
      'X-API-BOTNOI': emailUsernameApiKey,
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['message'] == 'success' && data['data'] != null) {
          String email = data['data']['email'];
          _result = email;
          _logger.d('Email: $email');
        } else {
          _result = 'email not found';
          _logger.e('email not found');
        }

        notifyListeners();
      } else {
        _result = 'Failed to get email. Status Code: ${response.statusCode}';
        _logger.e('Failed with status code: ${response.statusCode}');
        notifyListeners();
      }
    } catch (e) {
      _result = 'Error: $e';
      _logger.e('Error: $e');
      notifyListeners();
    }
  }

  Future<void> getUsernameByEmail(String? email) async {
    String url = '$apiUrl/api/dashboard/get_username_id?email=$email';
    Map<String, String> headers = {
      'X-API-BOTNOI': emailUsernameApiKey,
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['message'] == 'success' &&
            data['data'] != null &&
            data['data']['username'] != null) {
          String username = data['data']['username'];
          _result = username;
          _logger.d('Username: $username');
        } else {
          _result = 'No username found in response.';
          _logger.w('Response does not contain username.');
        }
        notifyListeners();
      } else {
        _result = 'Failed to get username. Status Code: ${response.statusCode}';
        _logger.e('Failed with status code: ${response.statusCode}');
        notifyListeners();
      }
    } catch (e) {
      _result = 'Error: $e';
      _logger.e('Error: $e');
      notifyListeners();
    }
  }

  /// Get username by email and call getUsernameByEmail function
  Future<void> loadGetUsername(String? email) async {
    await getUsernameByEmail(email);
    _getUsername = _result;
  }
}
