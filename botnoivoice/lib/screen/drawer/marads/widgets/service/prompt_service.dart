import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/models/prompt_response_model.dart';
import 'package:logger/logger.dart';

class PromptService {
  final String baseUrl = apiUrl;

  /// Logger สำหรับ debug
  final Logger _logger = Logger();

  // Headers แบบเดียวกับเว็บ (มี Referer)
  Map<String, String> _headers(String token) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      "Referer": "https://voice.botnoi.ai/",
    };
  }

  /// -----------------------------------------------------
  /// create_prompt_ads (แบบเดิม: dynamic)
  /// -----------------------------------------------------
  Future<dynamic> createPromptAds({
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    final url = Uri.parse("$baseUrl/api/marketplace/create_prompt_ads");

    _logger.i("POST $url");
    _logger.i("Headers: ${_headers(token)}");
    _logger.i("Payload: $payload");

    final response = await http.post(
      url,
      headers: _headers(token),
      body: jsonEncode(payload),
    );

    _logger.i("Status: ${response.statusCode}");
    _logger.i("Response body: ${response.body}");

    return jsonDecode(response.body);
  }

  /// -----------------------------------------------------
  /// create_prompt_ads (แบบ Typed -> PromptResponse)
  /// -----------------------------------------------------
  Future<PromptResponse> createPromptAdsTyped({
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    final url = Uri.parse("$baseUrl/api/marketplace/create_prompt_ads");

    _logger.i("[Typed] POST $url");
    _logger.i("[Typed] Headers: ${_headers(token)}");
    _logger.i("[Typed] Payload: $payload");

    final response = await http.post(
      url,
      headers: _headers(token),
      body: jsonEncode(payload),
    );

    _logger.i("[Typed] Status: ${response.statusCode}");
    _logger.i("[Typed] Response body: ${response.body}");

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PromptResponse.fromJson(json);
  }

  /// -----------------------------------------------------
  /// add_workspace_prompt (แบบเดิม: dynamic)
  /// -----------------------------------------------------
  Future<dynamic> addWorkspacePrompt({
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    final url = Uri.parse("$baseUrl/api/marketplace/add_workspace_prompt");

    _logger.i("POST $url");
    _logger.i("Headers: ${_headers(token)}");
    _logger.i("Payload: $payload");

    final response = await http.post(
      url,
      headers: _headers(token),
      body: jsonEncode(payload),
    );

    _logger.i("Status: ${response.statusCode}");
    _logger.i("Response body: ${response.body}");

    return jsonDecode(response.body);
  }

  /// -----------------------------------------------------
  /// add_workspace_prompt (แบบใช้ model)
  /// -----------------------------------------------------
  Future<dynamic> addWorkspacePromptModel({
    required String token,
    required AddWorkspacePromptRequest request,
  }) async {
    final url = Uri.parse("$baseUrl/api/marketplace/add_workspace_prompt");
    final payload = request.toJson();

    _logger.i("[Model] POST $url");
    _logger.i("[Model] Headers: ${_headers(token)}");
    _logger.i("[Model] Payload: $payload");

    final response = await http.post(
      url,
      headers: _headers(token),
      body: jsonEncode(payload),
    );

    _logger.i("[Model] Status: ${response.statusCode}");
    _logger.i("[Model] Response body: ${response.body}");

    return jsonDecode(response.body);
  }
}
