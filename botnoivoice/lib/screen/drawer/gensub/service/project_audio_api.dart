// // project_audio_api.dart

// import 'dart:convert';
// import 'package:botnoivoice/shared/function/get_jwt_token.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';
// // Import ที่จำเป็น
// import 'package:botnoivoice/config/api_url_config.dart'; // ต้อง import เพื่อใช้ apiUrl
// import 'api_token_helper.dart';

// final _logger = Logger();
// const String _baseUrlSuffix = "/api/genai";

// /// ---------------------- Audio Chunk Functions ----------------------

// /// 1. ตัดไฟล์เสียง (cutAudio)
// Future<dynamic> cutAudio(
//   BuildContext context,
//   {
//     required String filePath,
//     required String projectId,
//     required String projectName,
//     String cutType = "sec",
//     required String chunk,
//     required String durations,
//     required String maxDuration,
//     required String maxSilence,
//     String language = "th",
//   }
// ) async {
//   final String? token = await getJwtTokenAll(context);
//     if (token == null || token.isEmpty) {
//       return;
//     }
//   var url = Uri.parse("$apiUrl$_baseUrlSuffix/cut_audio");
//   _logger.e("print url $url");
//   var request = http.MultipartRequest("POST", url)
//     ..headers.addAll(getMultipartHeadersWithAuth(token))
//     ..fields["project_id"] = projectId
//     ..fields["project_name"] = projectName
//     ..fields["cut_type"] = cutType
//     ..fields["chunk"] = chunk
//     ..fields["durations"] = durations
//     ..fields["max_duration"] = maxDuration
//     ..fields["max_silence"] = maxSilence
//     ..fields["language"] = language
//     ..files.add(await http.MultipartFile.fromPath("audio_file", filePath));
//   _logger.e("audio duration $maxDuration");
//   _logger.e("audio silence $maxSilence");
//   _logger.e("language $language");
//   _logger.e("audio file path $filePath");
//   _logger.e("duration $durations");
//   _logger.e("chunk $chunk");
//   _logger.e("project name $projectName");
//   _logger.e("project id $projectId");
//   _logger.e("cut type $cutType");
//   _logger.i("Calling cutAudio API: $url\nFields: ${request.fields}\nFile: $filePath");

//   var response = await request.send();
//   var responseBytes = await response.stream.toBytes();
//   var responseBody = utf8.decode(responseBytes);

//   _logger.i("Response status: ${response.statusCode}");
//   _logger.d("Response body: $responseBody");

//   if (response.statusCode == 200) {
//     return jsonDecode(responseBody);
//   } else {
//     throw Exception("cutAudio failed: ${response.statusCode} $responseBody");
//   }
// }

// /// 2. อัพเดตสถานะ Audio Chunk (updateAudioApprove)
// Future<dynamic> updateAudioApprove(
//   BuildContext context,
//   {
//     required String chunkId,
//     required String userId,
//     required String approveText,
//   }
// ) async {
//   final String? token = await getJwtTokenAll(context);
//     if (token == null || token.isEmpty) {
//       return;
//     }
//   var url = Uri.parse("$apiUrl$_baseUrlSuffix/update_audio_approve");
//   var body = jsonEncode({
//     "chunk_id": chunkId,
//     "user_id": userId,
//     "approve_text": approveText,
//   });

//   _logger.i("Calling updateAudioApprove API: $url with body $body");

//   var response = await http.put(url, headers: getJsonHeadersWithAuth(token), body: body);

//   _logger.i("Response status: ${response.statusCode}");
//   // Use utf8.decode on bodyBytes to preserve encoding
//   var respBody = utf8.decode(response.bodyBytes);
//   _logger.d("Response body: $respBody");

//   if (response.statusCode == 200) {
//     return jsonDecode(respBody);
//   } else {
//     throw Exception("updateAudioApprove failed: ${response.statusCode} $respBody");
//   }
// }

// /// 3. ดึง Audio Chunks ทั้งหมด (getAllChunks)
// Future<dynamic> getAllChunks(
//   BuildContext context,
//   {
//     String? projectId,
//     double? minCer
//   }
// ) async {
//   final String? token = await getJwtTokenAll(context);
//     if (token == null || token.isEmpty) {
//       return;
//     }
//   Map<String, String> queryParams = {};
//   if (projectId != null) queryParams["project_id"] = projectId;
//   if (minCer != null) queryParams["min_cer"] = minCer.toString();

//   var url = Uri.parse("$apiUrl$_baseUrlSuffix/get_all_chunk")
//       .replace(queryParameters: queryParams);

//   _logger.i("Calling getAllChunks API: $url");

//   var response = await http.get(url, headers: getJsonHeadersWithAuth(token));

//   _logger.i("Response status: ${response.statusCode}");
//   var respBody = utf8.decode(response.bodyBytes);
//   _logger.d("Response body: $respBody");

//   if (response.statusCode == 200) {
//     return jsonDecode(respBody);
//   } else {
//     throw Exception("getAllChunks failed: ${response.statusCode} $respBody");
//   }
// }

// /// 4. ดึง Audio Chunk เดี่ยว (getChunk)
// Future<dynamic> getChunk(BuildContext context, String chunkId) async {
//   final String? token = await getJwtTokenAll(context);
//     if (token == null || token.isEmpty) {
//       return;
//     }
//   var url = Uri.parse("$apiUrl$_baseUrlSuffix/get_chunk")
//       .replace(queryParameters: {"chunk_id": chunkId});
//   _logger.i("Calling getChunk API: $url");

//   var response = await http.get(url, headers: getJsonHeadersWithAuth(token));

//   _logger.i("Response status: ${response.statusCode}");
//   var respBody = utf8.decode(response.bodyBytes);
//   _logger.d("Response body: $respBody");

//   if (response.statusCode == 200) {
//     return jsonDecode(respBody);
//   } else {
//     throw Exception("getChunk failed: ${response.statusCode} $respBody");
//   }
// }

// /// 5. ลบ Audio Chunk (deleteChunk)
// Future<dynamic> deleteChunk(BuildContext context, String chunkId) async {
//   final String? token = await getJwtTokenAll(context);
//     if (token == null || token.isEmpty) {
//       return;
//     }
//   var url = Uri.parse("$apiUrl$_baseUrlSuffix/delete_chunk")
//       .replace(queryParameters: {"chunk_id": chunkId});
//   _logger.i("Calling deleteChunk API: $url");

//   var response = await http.delete(url, headers: getJsonHeadersWithAuth(token));

//   _logger.i("Response status: ${response.statusCode}");
//   var respBody = utf8.decode(response.bodyBytes);
//   _logger.d("Response body: $respBody");

//   if (response.statusCode == 200) {
//     return jsonDecode(respBody);
//   } else {
//     throw Exception("deleteChunk failed: ${response.statusCode} $respBody");
//   }
// }
























// project_audio_api.dart
import 'dart:convert';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
// Import ที่จำเป็น
import 'package:botnoivoice/config/api_url_config.dart'; // ต้อง import เพื่อใช้ apiUrl
import 'api_token_helper.dart';

final _logger = Logger();
const String _baseUrlSuffix = "/api/genai";

/// ---------------------- Audio Chunk Functions ----------------------

/// 1. ตัดไฟล์เสียง (cutAudio)
Future<dynamic> cutAudio(
  WidgetRef ref, {
  required String filePath,
  required String projectId,
  required String projectName,
  String cutType = "sec",
  required String chunk,
  required String durations,
  required String maxDuration,
  required String maxSilence,
  String language = "th",
}) async {
  final String? token = ref.read(currentUserTokenStateProvider).jwtToken;
  if (token == null || token.isEmpty) {
    return;
  }
  var url = Uri.parse("$apiUrl$_baseUrlSuffix/cut_audio");
  _logger.e("print url $url");
  var request = http.MultipartRequest("POST", url)
    ..headers.addAll(getMultipartHeadersWithAuth(token))
    ..fields["project_id"] = projectId
    ..fields["project_name"] = projectName
    ..fields["cut_type"] = cutType
    ..fields["chunk"] = chunk
    ..fields["durations"] = durations
    ..fields["max_duration"] = maxDuration
    ..fields["max_silence"] = maxSilence
    ..fields["language"] = language
    ..files.add(await http.MultipartFile.fromPath("audio_file", filePath));
  _logger.e("audio duration $maxDuration");
  _logger.e("audio silence $maxSilence");
  _logger.e("language $language");
  _logger.e("audio file path $filePath");
  _logger.e("duration $durations");
  _logger.e("chunk $chunk");
  _logger.e("project name $projectName");
  _logger.e("project id $projectId");
  _logger.e("cut type $cutType");
  _logger.i(
      "Calling cutAudio API: $url\nFields: ${request.fields}\nFile: $filePath");

  var response = await request.send();
  var responseBytes = await response.stream.toBytes();
  var responseBody = utf8.decode(responseBytes);

  _logger.i("Response status: ${response.statusCode}");
  _logger.d("Response body: $responseBody");

  if (response.statusCode == 200) {
    return jsonDecode(responseBody);
  } else {
    throw Exception("cutAudio failed: ${response.statusCode} $responseBody");
  }
}

/// 2. อัพเดตสถานะ Audio Chunk (updateAudioApprove)
Future<dynamic> updateAudioApprove(
  WidgetRef ref, {
  required String chunkId,
  required String userId,
  required String approveText,
}) async {
  final String? token = ref.read(currentUserTokenStateProvider).jwtToken;
  if (token == null || token.isEmpty) {
    return;
  }
  var url = Uri.parse("$apiUrl$_baseUrlSuffix/update_audio_approve");
  var body = jsonEncode({
    "chunk_id": chunkId,
    "user_id": userId,
    "approve_text": approveText,
  });

  _logger.i("Calling updateAudioApprove API: $url with body $body");

  var response =
      await http.put(url, headers: getJsonHeadersWithAuth(token), body: body);

  _logger.i("Response status: ${response.statusCode}");
  // Use utf8.decode on bodyBytes to preserve encoding
  var respBody = utf8.decode(response.bodyBytes);
  _logger.d("Response body: $respBody");

  if (response.statusCode == 200) {
    return jsonDecode(respBody);
  } else {
    throw Exception(
        "updateAudioApprove failed: ${response.statusCode} $respBody");
  }
}

/// 3. ดึง Audio Chunks ทั้งหมด (getAllChunks)
Future<dynamic> getAllChunks(
  WidgetRef ref, {
  String? projectId,
  double? minCer,
}) async {
  final String? token = ref.read(currentUserTokenStateProvider).jwtToken;
  if (token == null || token.isEmpty) {
    return;
  }
  Map<String, String> queryParams = {};
  if (projectId != null) queryParams["project_id"] = projectId;
  if (minCer != null) queryParams["min_cer"] = minCer.toString();

  var url = Uri.parse("$apiUrl$_baseUrlSuffix/get_all_chunk")
      .replace(queryParameters: queryParams);

  _logger.i("Calling getAllChunks API: $url");

  var response = await http.get(url, headers: getJsonHeadersWithAuth(token));

  _logger.i("Response status: ${response.statusCode}");
  var respBody = utf8.decode(response.bodyBytes);
  _logger.d("Response body: $respBody");

  if (response.statusCode == 200) {
    return jsonDecode(respBody);
  } else {
    throw Exception("getAllChunks failed: ${response.statusCode} $respBody");
  }
}

/// 4. ดึง Audio Chunk เดี่ยว (getChunk)
Future<dynamic> getChunk(
  WidgetRef ref,
  String chunkId,
) async {
  final String? token = ref.read(currentUserTokenStateProvider).jwtToken;
  if (token == null || token.isEmpty) {
    return;
  }
  var url = Uri.parse("$apiUrl$_baseUrlSuffix/get_chunk")
      .replace(queryParameters: {"chunk_id": chunkId});
  _logger.i("Calling getChunk API: $url");

  var response = await http.get(url, headers: getJsonHeadersWithAuth(token));

  _logger.i("Response status: ${response.statusCode}");
  var respBody = utf8.decode(response.bodyBytes);
  _logger.d("Response body: $respBody");

  if (response.statusCode == 200) {
    return jsonDecode(respBody);
  } else {
    throw Exception("getChunk failed: ${response.statusCode} $respBody");
  }
}

/// 5. ลบ Audio Chunk (deleteChunk)
Future<dynamic> deleteChunk(
  WidgetRef ref,
  String chunkId,
) async {
  final String? token = ref.read(currentUserTokenStateProvider).jwtToken;
  if (token == null || token.isEmpty) {
    return;
  }
  var url = Uri.parse("$apiUrl$_baseUrlSuffix/delete_chunk")
      .replace(queryParameters: {"chunk_id": chunkId});
  _logger.i("Calling deleteChunk API: $url");

  var response = await http.delete(url, headers: getJsonHeadersWithAuth(token));

  _logger.i("Response status: ${response.statusCode}");
  var respBody = utf8.decode(response.bodyBytes);
  _logger.d("Response body: $respBody");

  if (response.statusCode == 200) {
    return jsonDecode(respBody);
  } else {
    throw Exception("deleteChunk failed: ${response.statusCode} $respBody");
  }
}
