// project_asr_api.dart

import 'dart:convert';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:botnoivoice/config/api_url_config.dart';
import 'api_token_helper.dart';

final _logger = Logger();
const String _baseUrlSuffix = "/api/genai";

/// ---------------------- ASR Workspace Functions ----------------------

/// 1. ดึง ASR Workspaces ทั้งหมด (getAllWorkspaces)
Future<dynamic> getAllWorkspaces(WidgetRef ref) async {
  final String? token = ref.read(currentUserTokenStateProvider).jwtToken;
  if (token == null || token.isEmpty) {
    return;
  }
  var url = Uri.parse("$apiUrl$_baseUrlSuffix/get_all_asr_workspace");
  _logger.i("Calling getAllWorkspaces API: $url");

  var response = await http.get(url, headers: getJsonHeadersWithAuth(token));

  _logger.i("Response status: ${response.statusCode}");
  var respBody = utf8.decode(response.bodyBytes);
  _logger.d("Response body: $respBody");

  if (response.statusCode == 200) {
    return jsonDecode(respBody);
  } else {
    throw Exception(
        "getAllWorkspaces failed: ${response.statusCode} $respBody");
  }
}

/// 2. ดึง ASR Workspace เดี่ยว (getAsrWorkspace)
Future<dynamic> getAsrWorkspace(
  WidgetRef ref,
  String userId,
  String projectId,
) async {
  final String? token = ref.read(currentUserTokenStateProvider).jwtToken;
  if (token == null || token.isEmpty) {
    return;
  }
  var url = Uri.parse("$apiUrl$_baseUrlSuffix/get_asr_workspace")
      .replace(queryParameters: {"user_id": userId, "project_id": projectId});
  _logger.i("Calling getAsrWorkspace API: $url");

  var response = await http.get(url, headers: getJsonHeadersWithAuth(token));

  _logger.i("Response status: ${response.statusCode}");
  var respBody = utf8.decode(response.bodyBytes);
  _logger.d("Response body: $respBody");

  if (response.statusCode == 200) {
    return jsonDecode(respBody);
  } else {
    throw Exception("getAsrWorkspace failed: ${response.statusCode} $respBody");
  }
}

/// 3. สร้าง ASR Workspace ใหม่ (insertAsrWorkspace)
Future<dynamic> insertAsrWorkspace({
  required WidgetRef ref,
  required String projectName,
  required double cer,
  required int pointAdd,
  required int totalPoint,
  required String duration,
}) async {
  final String? token = ref.read(currentUserTokenStateProvider).jwtToken;
  if (token == null || token.isEmpty) {
    return;
  }
  final url = Uri.parse("$apiUrl$_baseUrlSuffix/insert_asr_workspace");

  final body = jsonEncode({
    "project_name": projectName,
    "cer": cer,
    "point_add": pointAdd,
    "total_point": totalPoint,
    "duration": duration,
  });

  _logger.i("Calling insertAsrWorkspace API: $url with body $body");

  // แก้ไข headers ให้ใช้ getJsonHeadersWithAuth(token) แทน
  final response = await http.post(
    url,
    headers: getJsonHeadersWithAuth(token),
    body: body,
  );

  _logger.i("Response status: ${response.statusCode}");
  var respBody = utf8.decode(response.bodyBytes);
  _logger.d("Response body: $respBody");

  if (response.statusCode == 200) {
    return jsonDecode(respBody);
  } else {
    throw Exception(
        "insertAsrWorkspace failed: ${response.statusCode} $respBody");
  }
}

/// 4. อัพเดต ASR Workspace (updateAsrWorkspace)
Future<dynamic> updateAsrWorkspace({
  required WidgetRef ref,
  required String projectId,
  required String userId,
  String? projectName,
}) async {
  final String? token = ref.read(currentUserTokenStateProvider).jwtToken;
  if (token == null || token.isEmpty) {
    return;
  }
  var url = Uri.parse("$apiUrl$_baseUrlSuffix/update_asr_workspace");
  var body = jsonEncode({
    "project_id": projectId,
    "user_id": userId,
    if (projectName != null) "project_name": projectName,
  });

  _logger.i("Calling updateAsrWorkspace API: $url with body $body");

  var response =
      await http.put(url, headers: getJsonHeadersWithAuth(token), body: body);

  _logger.i("Response status: ${response.statusCode}");
  var respBody = utf8.decode(response.bodyBytes);
  _logger.d("Response body: $respBody");

  if (response.statusCode == 200) {
    return jsonDecode(respBody);
  } else {
    throw Exception(
        "updateAsrWorkspace failed: ${response.statusCode} $respBody");
  }
}

/// 5. ลบ ASR Workspace (deleteAsrWorkspace)
Future<dynamic> deleteAsrWorkspace(
  WidgetRef ref,
  String projectId,
  String userId,
) async {
  final String? token = ref.read(currentUserTokenStateProvider).jwtToken;
  if (token == null || token.isEmpty) {
    return;
  }
  var url = Uri.parse("$apiUrl$_baseUrlSuffix/delete_asr_workspace")
      .replace(queryParameters: {"project_id": projectId, "user_id": userId});
  _logger.i("Calling deleteAsrWorkspace API: $url");

  var response = await http.delete(url, headers: getJsonHeadersWithAuth(token));

  _logger.i("Response status: ${response.statusCode}");
  var respBody = utf8.decode(response.bodyBytes);
  _logger.d("Response body: $respBody");

  if (response.statusCode == 200) {
    return jsonDecode(respBody);
  } else {
    throw Exception(
        "deleteAsrWorkspace failed: ${response.statusCode} $respBody");
  }
}

/// 6. อัพเดตสถานะ ASR Approve (updateAsrApprove)
Future<dynamic> updateAsrApprove({
  required WidgetRef ref,
  required String projectId,
  required String userId,
  required double cer,
  String? duration,
}) async {
  final String? token = ref.read(currentUserTokenStateProvider).jwtToken;
  if (token == null || token.isEmpty) {
    return;
  }
  final url = Uri.parse("$apiUrl$_baseUrlSuffix/update_asr_approve");

  final bodyMap = {
    "project_id": projectId,
    "user_id": userId,
    "cer": cer,
    if (duration != null) "duration": duration,
  };

  final body = jsonEncode(bodyMap);

  _logger.i("Calling updateAsrApprove API: $url with body $body");

  try {
    final response = await http.put(
      url,
      headers: getJsonHeadersWithAuth(token),
      body: body,
    );

    _logger.i("Response status: ${response.statusCode}");
    var respBody = utf8.decode(response.bodyBytes);
    _logger.d("Response body: $respBody");

    if (response.statusCode == 200) {
      return jsonDecode(respBody);
    } else {
      throw Exception(
        "Failed to update ASR approve: ${response.statusCode} ${response.reasonPhrase}",
      );
    }
  } catch (e) {
    _logger.e("Error calling updateAsrApprove: $e");
    rethrow;
  }
}
