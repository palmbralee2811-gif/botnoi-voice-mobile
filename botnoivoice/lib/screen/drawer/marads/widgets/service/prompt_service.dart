import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/models/prompt_response_model.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/service/token/line_token.dart';
class PromptService {
  final String baseUrl = apiUrl;
  final Logger _logger = Logger();

  /// เลือก token ตาม provider ที่ user login
  String _selectToken(BuildContext context) {
    final apple = context.read<AppleToken>().getCredentialsToken;
    final google = context.read<GoogleToken>().getCredentialsToken;
    final line = context.read<LineToken>().getCredentialsToken;
    final email = context.read<EmailToken>().getCredentialsToken;

    if (context.read<LineLogin>().isLoggedIn && line != null && line.isNotEmpty) {
      return line;
    }
    if (apple != null && apple.isNotEmpty) return apple;
    if (google != null && google.isNotEmpty) return google;
    if (email != null && email.isNotEmpty) return email;

    return "";
  }

  Map<String, String> _headers(String token) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      "Referer": "https://voice.botnoi.ai/",
    };
  }

  /// -----------------------------------------------------
  /// create_prompt_ads (Dynamic)
  /// -----------------------------------------------------
  Future<dynamic> createPromptAds({
    required BuildContext context,
    required Map<String, dynamic> payload,
  }) async {
    final token = _selectToken(context);
    final url = Uri.parse("$baseUrl/api/marketplace/create_prompt_ads");

    _logger.i("💡 Using Token => $token");
    _logger.i("POST $url");
    _logger.i("Payload => $payload");

    final response = await http.post(
      url,
      headers: _headers(token),
      body: jsonEncode(payload),
    );

    _logger.i("Status => ${response.statusCode}");
    _logger.i("Response => ${response.body}");

    return jsonDecode(response.body);
  }

  /// -----------------------------------------------------
  /// create_prompt_ads (Typed → PromptResponse)
  /// -----------------------------------------------------
  Future<PromptResponse> createPromptAdsTyped({
    required BuildContext context,
    required Map<String, dynamic> payload,
  }) async {
    final token = _selectToken(context);
    final url = Uri.parse("$baseUrl/api/marketplace/create_prompt_ads");

    _logger.i("[Typed] Using Token => $token");
    _logger.i("[Typed] POST $url");

    final response = await http.post(
      url,
      headers: _headers(token),
      body: jsonEncode(payload),
    );

    _logger.i("[Typed] Status => ${response.statusCode}");
    _logger.i("[Typed] Response => ${response.body}");

    final json = jsonDecode(response.body);
    return PromptResponse.fromJson(json);
  }

  /// -----------------------------------------------------
  /// add_workspace_prompt
  /// -----------------------------------------------------
  Future<dynamic> addWorkspacePrompt({
    required BuildContext context,
    required Map<String, dynamic> payload,
  }) async {
    final token = _selectToken(context);
    final url = Uri.parse("$baseUrl/api/marketplace/add_workspace_prompt");

    _logger.i("Using Token => $token");
    _logger.i("POST $url");

    final response = await http.post(
      url,
      headers: _headers(token),
      body: jsonEncode(payload),
    );

    _logger.i("Status => ${response.statusCode}");
    _logger.i("Response => ${response.body}");

    return jsonDecode(response.body);
  }
}
