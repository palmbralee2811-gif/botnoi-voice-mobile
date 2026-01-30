// Path: lib/screen/main/home_speaker_data_management.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class HomeSpeakerDataState {
  final String? speakerId;
  final String? speakerName;
  final String? speakerAudio;
  final String? speakerImagePath;
  final String? nationalFlagName;
  final String? nationalFlagPath;
  final String? language;
  final bool isV2;

  HomeSpeakerDataState({
    this.speakerId,
    this.speakerName,
    this.speakerAudio,
    this.speakerImagePath,
    this.nationalFlagName,
    this.nationalFlagPath,
    this.language,
    this.isV2 = false,
  });

  // ใช้ `copyWith` สำหรับการอัปเดตสถานะแบบ Immutable
  HomeSpeakerDataState copyWith({
    String? speakerId,
    String? speakerName,
    String? speakerAudio,
    String? speakerImagePath,
    String? nationalFlagName,
    String? nationalFlagPath,
    String? language,
    bool? isV2,
  }) {
    return HomeSpeakerDataState(
      speakerId: speakerId ?? this.speakerId,
      speakerName: speakerName ?? this.speakerName,
      speakerAudio: speakerAudio ?? this.speakerAudio,
      speakerImagePath: speakerImagePath ?? this.speakerImagePath,
      nationalFlagName: nationalFlagName ?? this.nationalFlagName,
      nationalFlagPath: nationalFlagPath ?? this.nationalFlagPath,
      language: language ?? this.language,
      isV2: isV2 ?? this.isV2,
    );
  }
}


// HomeSpeakerDataState คือคลาสสถานะที่เรากำหนดไว้ข้างต้น
// HomeSpeakerDataManagementStateNotifier คือชื่อ Notifier ใหม่ที่ควรใช้
// แต่เราจะใช้ชื่อเดิมตามคำขอ (HomeSpeakerDataManagement)

/// Home Screen and Speaker Screen Data Management (Riverpod StateNotifier)
class HomeSpeakerDataManagement extends StateNotifier<HomeSpeakerDataState> {
  final Logger _logger = Logger();

  HomeSpeakerDataManagement() : super(HomeSpeakerDataState());

  // ใช้ getter ผ่าน state.propertyName แทน
  String? get speakerId => state.speakerId;
  String? get speakerName => state.speakerName;
  String? get speakerAudio => state.speakerAudio;
  String? get speakerImagePath => state.speakerImagePath;
  String? get nationalFlagName => state.nationalFlagName;
  String? get nationalFlagPath => state.nationalFlagPath;
  String? get language => state.language;
  bool get isV2 => state.isV2;

  // **รักษาชื่อฟังก์ชันเดิมไว้**
  void setSpeakerId(String id) {
    // อัปเดตสถานะโดยสร้าง State ใหม่ด้วย copyWith
    state = state.copyWith(speakerId: id);
    _logger.d("SpeakerProvider -> setSpeakerId: $speakerId");
    // ไม่ต้องเรียก notifyListeners()
  }

  void setSpeakerName(String name) {
    state = state.copyWith(speakerName: name);
    _logger.d("SpeakerProvider -> setSpeakerName: $speakerName");
  }

  void setSpeakerAudio(String audio) {
    state = state.copyWith(speakerAudio: audio);
    _logger.d("SpeakerProvider -> setSpeakerAudio: $speakerAudio");
  }

  void setSpeakerImagePath(String path) {
    state = state.copyWith(speakerImagePath: path);
    _logger.d("SpeakerProvider -> setSpeakerImagePath: $speakerImagePath");
  }

  void setNationalFlagName(String name) {
    state = state.copyWith(nationalFlagName: name);
    _logger.d("SpeakerProvider -> setNationalFlagName: $nationalFlagName");
  }

  void setNationalFlagPath(String path) {
    state = state.copyWith(nationalFlagPath: path);
    _logger.d("SpeakerProvider -> setNationalFlagPath: $nationalFlagPath");
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
    _logger.d("SpeakerProvider -> setLanguage: $language");
  }
  
  void setIsV2(bool isV2) {
    state = state.copyWith(isV2: isV2);
    _logger.d("SpeakerProvider -> setIsV2: $isV2");
  }
}


// provider_definitions.dart
final homeSpeakerDataProvider = 
    StateNotifierProvider<HomeSpeakerDataManagement, HomeSpeakerDataState>(
        (ref) {
  return HomeSpeakerDataManagement();
});