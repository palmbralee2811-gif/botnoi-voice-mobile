import 'dart:convert';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// Provider and interface to the main server
class LineTokenProvider extends ChangeNotifier {
  String? jwtToken;
  String? remainingCredits;
  String? credentialsToken;

  final Logger logger = Logger();

  /// Clear all the tokens
  void clearTokens() {
    jwtToken = null;
    remainingCredits = null;
    credentialsToken = null;
    notifyListeners();
  }

  //TODO: Refactor this function for LINE API
  Future<void> loadJwtToken(BuildContext context) async {
    String? idToken =
        await Provider.of<LineLoginProvider>(context, listen: false).getIdTokenRaw();
    if (idToken == null) return;

    String url = 'https://api-voice.botnoi.ai/api/dashboard/liff';

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
          jwtToken = message.substring(tokenStartIndex);
          notifyListeners();
          logger.i('JWT Token successfully loaded: $jwtToken');
        } else {
          logger.w('Token not found in response message: $message');
        }
      } else {
        logger.e('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching JWT Token: $e');
    }
  }

  /// Get the remaining credits using jwtToken
  Future<void> loadRemainingCredits() async {
    if (jwtToken == null) return;

    String url = 'https://api-voice.botnoi.ai/api/dashboard/get_profile';
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        remainingCredits = data['data']['credits'].toString();
        notifyListeners();
        logger.i('Remaining credits successfully loaded: $remainingCredits');
      } else {
        logger
            .e("Failed to retrieve remaining credits: ${response.statusCode}");
      }
    } catch (e) {
      logger.e('Error fetching remaining credits: $e');
    }
  }

  /// Get the credentials token using jwtToken
  Future<void> loadCredentials() async {
    if (jwtToken == null) return;

    String url = 'https://api-voice.botnoi.ai/api/service/get_token';
    Map<String, dynamic> payload = {};
    Map<String, String> headers = {
      'Authorization': 'Bearer $jwtToken',
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
        credentialsToken = data['data'][0]['token'].toString();
        notifyListeners();
        logger.i('Credentials token successfully loaded: $credentialsToken');
      } else {
        logger.e('Failed to load Credentials-Token: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching Credentials-Token: $e');
    }
  }
}
