import 'dart:convert';
import 'package:botnoivoice/data/entities/speaker_entity.dart';
import 'package:flutter/services.dart';

class SpeakerModel {
  static List<SpeakerEntity> speakerItem = [];

  // ฟังก์ชันโหลดข้อมูล JSON และเพิ่มใน speakerItem
  static Future<void> loadSpeakers() async {
    try {
      // โหลด JSON จาก assets
      String jsonString =
          await rootBundle.loadString('assets/data/speaker_model.json');

      // แปลง JSON String -> Map
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      // เข้าถึงคีย์ "data" ซึ่งเป็น List
      List<dynamic> jsonList = jsonMap['data'];

      // แปลง JSON เป็น List<SpeakerEntity>
      speakerItem =
          jsonList.map((json) => SpeakerEntity.fromJson(json)).toList();
      print('Speakers loaded successfully: ${speakerItem.length}');
    } catch (e) {
      // จัดการข้อผิดพลาด
      print('Error loading speakers: $e');
      speakerItem = [];
    }
  }
}
