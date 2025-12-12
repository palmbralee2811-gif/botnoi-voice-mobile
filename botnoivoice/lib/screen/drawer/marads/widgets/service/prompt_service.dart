import 'dart:convert';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/models/prompt_response_model.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';

class PromptService {
  final String baseUrl = apiUrl;
  final Logger _logger = Logger();

  /// เลือก token ตาม provider ที่ user login
  String _selectToken(BuildContext context) {
    try {
      // ใช้ ProviderScope เพื่อดึงค่าจาก Riverpod ผ่าน Context
      final container = ProviderScope.containerOf(context, listen: false);
      final userState = container.read(currentUserTokenStateProvider);
      return userState.jwtToken ?? "";
    } catch (e) {
      _logger.w("Riverpod provider not found or error: $e");
      return "";
    }
  }

  Map<String, String> _headers(String token) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      "Referer": apiReferer,
    };
  }

  /// -----------------------------------------------------
  /// create_prompt_ads (Dynamic)
  /// -----------------------------------------------------
  Future<dynamic> createPromptAds({
    required BuildContext context,
    String? token,
    required Map<String, dynamic> payload,
  }) async {
    final usedToken =
        (token != null && token.isNotEmpty) ? token : _selectToken(context);
    final url = Uri.parse("$baseUrl/api/marketplace/create_prompt_ads");

    _logger.i("💡 Using Token => $usedToken");
    _logger.i("POST $url");
    _logger.i("Payload => $payload");

    final response = await http.post(
      url,
      headers: _headers(usedToken),
      body: jsonEncode(payload),
    );

    _logger.i("Status => ${response.statusCode}");
    final responseBody = utf8.decode(response.bodyBytes);
    _logger.i("Response => $responseBody");
    return jsonDecode(responseBody);
  }

  /// -----------------------------------------------------
  /// create_prompt_ads (Typed → PromptResponse)
  /// -----------------------------------------------------
  Future<PromptResponse> createPromptAdsTyped({
    required BuildContext context,
    String? token,
    required Map<String, dynamic> payload,
  }) async {
    final usedToken =
        (token != null && token.isNotEmpty) ? token : _selectToken(context);
    final url = Uri.parse("$baseUrl/api/marketplace/create_prompt_ads");

    _logger.i("[Typed] Using Token => $usedToken");
    _logger.i("[Typed] POST $url");

    final response = await http.post(
      url,
      headers: _headers(usedToken),
      body: jsonEncode(payload),
    );

    _logger.i("[Typed] Status => ${response.statusCode}");
    final responseBody = utf8.decode(response.bodyBytes);
    _logger.i("[Typed] Response => $responseBody");

    final json = jsonDecode(responseBody);
    return PromptResponse.fromJson(json);
  }

  /// -----------------------------------------------------
  /// add_workspace_prompt
  /// -----------------------------------------------------
  Future<dynamic> addWorkspacePrompt({
    required BuildContext context,
    String? token,
    required Map<String, dynamic> payload,
  }) async {
    //เช็คว่าถ้ามี token ส่งมาให้ใช้เลย ถ้าไม่มีค่อยไปหาจาก context
    final usedToken =
        (token != null && token.isNotEmpty) ? token : _selectToken(context);
    final url = Uri.parse("$baseUrl/api/marketplace/add_workspace_prompt");

    _logger.i("Using Token => $usedToken");
    _logger.i("POST $url");

    final response = await http.post(
      url,
      headers: _headers(usedToken),
      body: jsonEncode(payload),
    );

    _logger.i("Status => ${response.statusCode}");
    final responseBody = utf8.decode(response.bodyBytes);
    _logger.i("Response => $responseBody");
    return jsonDecode(responseBody);
  }
}
