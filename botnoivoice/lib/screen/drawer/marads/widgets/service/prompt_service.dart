import 'dart:convert';
import 'package:botnoivoice/screen/drawer/marads/widgets/models/mar_ads_history_model.dart';
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
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Referer': refererUrl,
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

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(responseBody);
    } else {
      // พยายามดึง message จาก server ถ้ามี
      String errorMsg = "Server Error (${response.statusCode})";
      try {
        final jsonErr = jsonDecode(responseBody);
        if (jsonErr['message'] != null) {
          errorMsg = jsonErr['message'];
        } else if (jsonErr['error'] != null) {
          errorMsg = jsonErr['error'];
        }
      } catch (_) {}

      throw Exception(errorMsg);
    }
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

    final response = await http.put(
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

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(responseBody);
    } else {
      throw Exception(
          "Add History Failed: ${response.statusCode} - $responseBody");
    }
  }

  /// -----------------------------------------------------
  /// get_prompt_user_id (History)
  /// -----------------------------------------------------
  Future<List<MarAdsHistoryModel>> getPromptHistory({
    required BuildContext context,
    required String userId,
  }) async {
    final token = _selectToken(context);

    // URL ตามที่คุณให้มา
    final url = Uri.parse(
        "$baseUrl/api/marketplace/get_prompt_user_id?user_id=$userId");

    _logger.i("GET History => $url");

    try {
      final response = await http.get(
        url,
        headers: _headers(token),
      );

      _logger.i("History Status => ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes);
        final json = jsonDecode(responseBody);

        if (json['data'] != null && json['data']['prompt_list'] != null) {
          final List<dynamic> list = json['data']['prompt_list'];
          return list.map((e) => MarAdsHistoryModel.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      _logger.e("Error fetching prompt history: $e");
      return [];
    }
  }

  /// -----------------------------------------------------
  /// delete_prompt (Delete History)
  /// -----------------------------------------------------
  Future<bool> deletePrompt({
    required BuildContext context,
    required String promptId,
  }) async {
    final token = _selectToken(context);

    final url =
        Uri.parse("$baseUrl/api/marketplace/delete_prompt?prompt_id=$promptId");

    _logger.i("DELETE Prompt => $url");

    try {
      final response = await http.delete(
        url,
        headers: _headers(token),
      );

      _logger.i("Delete Status => ${response.statusCode}");

      if (response.statusCode == 200) {
        return true;
      } else {
        // ลอง decode ดู error message
        _logger.e("Delete Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      _logger.e("Error deleting prompt: $e");
      return false;
    }
  }

  /// -----------------------------------------------------
  /// update_prompt_audio (Save Audio to History)
  /// -----------------------------------------------------
  Future<bool> updatePromptHistory({
    required BuildContext context,
    required String promptId,
    required String audioUrl,
    required String speakerId,
    required bool isV2,
    required String language,
    required String text,
    required String contentStyle,
    String? title,
    String? category,
  }) async {
    final token = _selectToken(context);

    final url = Uri.parse(
        "$baseUrl/api/marketplace/update_prompt_history?prompt_id=$promptId");

    // Helper สำหรับแปลง Style ไทยเป็นอังกฤษ แก้ตอนส่งข้อมูลเข้า History
    String getStyleEn(String style) {
      const map = {
        'จูงใจให้ใช้': 'Persuasive',
        'ตลก': 'Funny',
        'จริงจัง': 'Serious',
        'ออดอ้อน': 'Begging',
        'เรียกความสงสาร': 'Sympathy',
        'รีวิวสินค้า': 'Product Review'
      };
      return map[style] ?? style;
    }

    //  สร้าง Payload ตามที่ API ต้องการ
    final payload = {
      "prompt_id": promptId,
      "audio": audioUrl,
      "isgenerate": true,
      "is_download": true,
      "speaker": speakerId,
      "speaker_v2": isV2,
      "language": {"value": language},
      "text": text,
      "volume": "100",
      "speed": "1",
      "prompt_style": {
        "TH_label": contentStyle,
        "EN_label": getStyleEn(contentStyle), // [เพิ่ม] ส่ง EN_label ลง DB
        "value": contentStyle
      },
      if (title != null) "title": title,
      if (category != null) "category": category,
    };

    _logger.i("PUT Update History => $url");
    _logger.i("Payload => $payload");

    try {
      final response = await http.put(
        url,
        headers: _headers(token),
        body: jsonEncode(payload),
      );

      _logger.i("Update Status => ${response.statusCode}");

      if (response.statusCode == 200) {
        return true;
      } else {
        _logger.e("Update Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      _logger.e("Error updating prompt audio: $e");
      return false;
    }
  }
}
