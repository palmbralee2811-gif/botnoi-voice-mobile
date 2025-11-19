import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:botnoivoice/config/api_url_config.dart'; // << ใช้ apiUrl ของโปรเจกต์

class PromptService {
  final String baseUrl = apiUrl;

  // Headers แบบเดียวกับเว็บ (มี Referer)
  Map<String, String> _headers(String token) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      "Referer": "https://voice.botnoi.ai/",   // << เพิ่ม referer ตามที่เว็บใช้
    };
  }

  /// -----------------------------------------------------
  /// ✔ create_prompt_ads
  /// -----------------------------------------------------
  Future<dynamic> createPromptAds({
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    final url = Uri.parse("$baseUrl/api/marketplace/create_prompt_ads");

    final response = await http.post(
      url,
      headers: _headers(token),
      body: jsonEncode(payload),
    );

    return jsonDecode(response.body);
  }

  /// -----------------------------------------------------
  /// ✔ add_workspace_prompt
  /// -----------------------------------------------------
  Future<dynamic> addWorkspacePrompt({
    required String token,
    required Map<String, dynamic> payload,
  }) async {
    final url = Uri.parse("$baseUrl/api/marketplace/add_workspace_prompt");

    final response = await http.post(
      url,
      headers: _headers(token),
      body: jsonEncode(payload),
    );

    return jsonDecode(response.body);
  }
}