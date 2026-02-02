import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:botnoivoice/config/api_url_config.dart';
import 'api_token_helper.dart'; 

final _logger = Logger();
const String _baseUrlSuffix = "/api/genai";

/// ---------------------- Gensub Upload & Transcribe Functions ----------------------

/// 1. อัพโหลดไฟล์เสียงไป Gensub (uploadAudioToGensub)
Future<Map<String, String?>> uploadAudioToGensub(
  WidgetRef ref, // รับ BuildContext
  {
    required File file,
    int maxDuration = 10,
    double maxSilence = 0.3,
    String srt = "no",
    String language = "en",
}) async {
  // ดึง token มาใช้เป็นทั้ง Authorization: Bearer และ Botnoi-Token
  final token = getSelectedBotnoiToken(ref); 

  var url = Uri.parse("$apiUrl$_baseUrlSuffix/gensub_upload");

  final ext = file.path.split('.').last.toLowerCase();
  MediaType contentType;
  switch (ext) {
    case 'wav':
      contentType = MediaType('audio', 'wav');
      break;
    case 'aac':
      contentType = MediaType('audio', 'aac');
      break;
    case 'mp3':
    default:
      contentType = MediaType('audio', 'mpeg');
  }

  // ใช้ Headers Helper และเพิ่ม 'Botnoi-Token' เข้าไป
  var headers = getMultipartHeadersWithAuth(token);
  headers['accept'] = 'application/json';
  headers['Botnoi-Token'] = token; // ใช้ Token เดียวกันสำหรับ Botnoi-Token

  var request = http.MultipartRequest("POST", url)
  ..headers.addAll(headers)
  ..fields['max_duration'] = maxDuration.toString()
  ..fields['max_silence'] = maxSilence.toString()
  ..fields['srt'] = srt
  ..fields['language'] = language // 🚀 เพิ่ม field 'language' เข้ามาที่นี่
  ..files.add(await http.MultipartFile.fromPath(
    'audio_file',
    file.path,
    contentType: contentType,
  ));

  _logger.i("Calling uploadAudioToGensub API: $url with file ${file.path}");
  _logger.d("Headers: ${request.headers}");
  _logger.d("Fields: ${request.fields}");

  var response = await request.send();
  // Read raw bytes then decode with utf8 to preserve non-ASCII (e.g., Thai)
  var responseBytes = await response.stream.toBytes();
  var responseBody = utf8.decode(responseBytes);

  _logger.i("Response status: ${response.statusCode}");
  _logger.d("Response body: $responseBody");

  return {
    "status": response.statusCode.toString(),
    "body": responseBody,
  };
}

/// 2. ถอดเสียงจากไฟล์ (transcribeAudioFile)
Future<Map<String, String?>> transcribeAudioFile(
  WidgetRef ref, // รับ BuildContext
  {
    required File file,
    int maxDuration = 10,
    double maxSilence = 0.3,
    String language = "en",
  }
) async {
  // เรียกใช้ uploadAudioToGensub
  final result = await uploadAudioToGensub(
    ref, 
    file: file,
    maxDuration: maxDuration,
    maxSilence: maxSilence,
    srt: "no",
    language: language,
  );

  String? textResult;

  try {
    String? body = result['body'];
    if (body != null && body.isNotEmpty) {
      body = body.replaceFirst('Response body: ', '');
    }
    
    if (body != null && body.isNotEmpty) {
      final jsonMap = json.decode(body);
      textResult = jsonMap['data']?['text']?.toString();
      if (textResult == null || textResult.isEmpty) {
        textResult = 'ไม่พบข้อความถอดเสียงในผลลัพธ์';
      }
    }
  } catch (e) {
    textResult = 'Error: $e';
  }

  return {
    'status': result['status'],
    'text': textResult,
  };
}