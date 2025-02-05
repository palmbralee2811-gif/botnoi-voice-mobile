import 'package:botnoivoice/data/entities/speaker_entity.dart';
import 'package:botnoivoice/data/models/speaker_model/speaker_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Repository for Speaker operations
class SpeakerRepositoryImpl with ChangeNotifier {
  final Logger _logger = Logger(); // Logger for Debugging mode
  SpeakerEntity? currentSpeaker; // ตัวแปรเก็บ Speaker ปัจจุบัน

  String? _speakerId;
  String? _speakerName;
  String? _speakerAudio;
  String? _speakerImagePath;
  String? _nationalFlagName;
  String? _nationalFlagPath;
  String? _language;

  String? get speakerId => _speakerId;
  String? get speakerName => _speakerName;
  String? get speakerAudio => _speakerAudio;
  String? get speakerImagePath => _speakerImagePath;
  String? get nationalFlagName => _nationalFlagName;
  String? get nationalFlagPath => _nationalFlagPath;
  String? get language => _language;

  void setSpeakerId(String id) {
    _speakerId = id;
    _logger.d("SpeakerProvider -> setSpeakerId: $speakerId");
    notifyListeners();
  }

  void setSpeakerName(String name) {
    _speakerName = name;
    _logger.d("SpeakerProvider -> setSpeakerName: $speakerName");
    notifyListeners();
  }

  void setSpeakerAudio(String audio) {
    _speakerAudio = audio;
    _logger.d("SpeakerProvider -> setSpeakerAudio: $speakerAudio");
    notifyListeners();
  }

  void setSpeakerImagePath(String path) {
    _speakerImagePath = path;
    _logger.d("SpeakerProvider -> setSpeakerImagePath: $speakerImagePath");
    notifyListeners();
  }

  void setNationalFlagName(String name) {
    _nationalFlagName = name;
    _logger.d("SpeakerProvider -> setNationalFlagName: $nationalFlagName");
    notifyListeners();
  }

  void setNationalFlagPath(String path) {
    _nationalFlagPath = path;
    _logger.d("SpeakerProvider -> setNationalFlagPath: $nationalFlagPath");
    notifyListeners();
  }

  void setLanguage(String language) {
    _language = language;
    _logger.d("SpeakerProvider -> setLanguage: $language");
    notifyListeners();
  }

  SpeakerRepositoryImpl() {
    // ตั้งค่า Speaker คนแรกเป็นค่าเริ่มต้น
    currentSpeaker = SpeakerModel.speakerItem[0];
  }

  // ฟังก์ชันที่ตั้งค่า currentSpeaker
  void setSpeaker(SpeakerEntity speaker) {
    currentSpeaker = speaker;
    notifyListeners(); // แจ้งให้ widget รีเฟรชเมื่อข้อมูลเปลี่ยนแปลง
  }

  String getName(BuildContext context) {
    // ตรวจสอบว่า currentSpeaker มีค่าไม่เป็น null
    if (currentSpeaker == null) {
      _logger.e("Current Speaker: No speaker selected");
      return 'Default Name'; // ถ้าไม่มี speaker ให้ใช้ Default Name
    }

    // ถ้ามี speaker ให้แสดงชื่อของ speaker คนปัจจุบัน
    _logger.d(
        "Current Speaker: ${currentSpeaker!.thaiName}"); // หรือ engName ก็ได้ตามต้องการ

    String locale = Localizations.localeOf(context).languageCode;
    return locale == 'th' ? currentSpeaker!.thaiName : currentSpeaker!.engName;
  }
}
