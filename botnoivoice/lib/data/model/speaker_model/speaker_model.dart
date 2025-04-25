import 'dart:convert';
import 'package:botnoivoice/data/entities/speaker_entity.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

class SpeakerModel {
  static List<SpeakerEntity> speakerItem = [];
  static final Logger _logger = Logger();

  /// ฟังก์ชันโหลดข้อมูล JSON และเพิ่มใน speakerItem
  static Future<void> loadSpeakers({required bool isSubscribed}) async {
    try {
      // โหลด JSON จาก assets
      final url = Uri.parse('https://api-voice.botnoi.ai/api/marketplace/get_all_marketplace_demo');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode != 200) {
        throw Exception("Failed to load speakers: ${response.statusCode}");
      }

      // แปลง JSON String -> Map
      Map<String, dynamic> jsonMap = json.decode(response.body);

      // เข้าถึงคีย์ "data" ซึ่งเป็น List
      if (jsonMap['data'] == null || jsonMap['data'] is! List) {
        throw Exception("Invalid or missing 'data' field in JSON");
      }

      // แปลง JSON เป็น List<SpeakerEntity>
      List<dynamic> jsonList = jsonMap['data'];

      // ใช้ isSubscribed กรอง speakers ถ้า sub อยู่จะให้แสดงทั้งหมด ถ้าไม่จะแสดงแค่ Free
      speakerItem =
          jsonList.map((json) => SpeakerEntity.fromJson(json)).where((speaker) {
        final tier = speaker.tier;
        // ให้ผ่าน speaker ถ้าเป็นสมาชิก หรือ speaker เป็น Free
        return isSubscribed || tier == 'Free';
      }).toList();

      // แสดงข้อมูล Speaker ที่โหลดได้
      _logger.d('Speakers loaded successfully: ${speakerItem.length}');
    } catch (e) {
      // จัดการข้อผิดพลาด
      _logger.e('Error loading speakers: $e');
      speakerItem = [];
    }
  }
}
