import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class SpeakerModel {
  static List<SpeakerEntity> speakerItem = [];
  static final Logger _logger = Logger();

  /// ฟังก์ชันโหลดข้อมูล JSON และเพิ่มใน speakerItem
  static Future<void> loadSpeakers({
    required bool isSubscribed,
    required String jwtToken,
  }) async {
    try {
      // โหลด JSON จาก assets
      final urlV2 = Uri.parse('$apiUrl/api/marketplace/get_all_marketplace_v2');
      final urlV1 = Uri.parse('$apiUrl/api/marketplace/get_all_marketplace');

      // ยิงทั้งสอง endpoint พร้อมกัน
      final responses = await Future.wait([
        http.get(urlV2, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        }),
        http.get(urlV1, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwtToken',
        }),
      ]);

      // v2 ไม่ต้องกรอง
      final responseV2 = responses[0];
      if (responseV2.statusCode != 200) {
        throw Exception("Failed to load speakers v2: ${responseV2.statusCode}");
      }

      // แปลง JSON String -> Map
      Map<String, dynamic> jsonMapV2 =
          json.decode(utf8.decode(responseV2.bodyBytes));

      // เข้าถึงคีย์ "data" ซึ่งเป็น List
      if (jsonMapV2['data'] == null || jsonMapV2['data'] is! List) {
        throw Exception("Invalid or missing 'data' field in JSON v2");
      }

      List<SpeakerEntity> speakersV2 = (jsonMapV2['data'] as List)
          .map((json) => SpeakerEntity.fromJson(json))
          .toList();

      // v1 กรองตาม isSubscribed
      final responseV1 = responses[1];
      if (responseV1.statusCode != 200) {
        throw Exception("Failed to load speakers v1: ${responseV1.statusCode}");
      }

      // แปลง JSON String -> Map
      Map<String, dynamic> jsonMapV1 =
          json.decode(utf8.decode(responseV1.bodyBytes));

      // เข้าถึงคีย์ "data" ซึ่งเป็น List
      if (jsonMapV1['data'] == null || jsonMapV1['data'] is! List) {
        throw Exception("Invalid or missing 'data' field in JSON v1");
      }
      
      List<SpeakerEntity> speakersV1 = (jsonMapV1['data'] as List)
          .map((json) => SpeakerEntity.fromJson(json))
          .where((speaker) {
        final tier = speaker.tier;
        return isSubscribed || tier == 'Free';
      }).toList();

      // รวมลิสต์ทั้ง V1 และ V2
      speakerItem = [...speakersV2, ...speakersV1];

      _logger.d('Speakers loaded successfully: ${speakerItem.length}');
    } catch (e) {
      // จัดการข้อผิดพลาด
      _logger.e('Error loading speakers: $e');
      speakerItem = [];
    }
  }
}
