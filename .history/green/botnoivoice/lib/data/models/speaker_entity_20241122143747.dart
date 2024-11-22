import 'package:flutter/widgets.dart'; // ใช้สำหรับ BuildContext

class SpeakerEntity {
  final String speakerId;
  final String speakerName;
  final String engName;
  final String thaiName;
  // ... ข้อมูลอื่นๆ

  SpeakerEntity({
    required this.speakerId,
    required this.speakerName,
    required this.engName,
    required this.thaiName,
    // ... ข้อมูลอื่นๆ
  });

  // เมธอดสำหรับดึงชื่อที่เหมาะสมกับภาษา
  String getName(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode; // ตรวจสอบ Locale
    return locale == 'th' ? thaiName : engName;
  }
}
