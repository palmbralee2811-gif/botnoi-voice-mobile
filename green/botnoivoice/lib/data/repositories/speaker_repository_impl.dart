import 'package:flutter/material.dart';

class SpeakerRepositoryImpl with ChangeNotifier {
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
    debugPrint("SpeakerProvider -> setSpeakerId: $speakerId");
    notifyListeners();
  }

  void setSpeakerName(String name) {
    _speakerName = name;
    debugPrint("SpeakerProvider -> setSpeakerName: $speakerName");
    notifyListeners();
  }

  void setSpeakerAudio(String audio) {
    _speakerAudio = audio;
    debugPrint("SpeakerProvider -> setSpeakerAudio: $speakerAudio");
    notifyListeners();
  }

  void setSpeakerImagePath(String path) {
    _speakerImagePath = path;
    debugPrint("SpeakerProvider -> setSpeakerImagePath: $speakerImagePath");
    notifyListeners();
  }

  void setNationalFlagName(String name) {
    _nationalFlagName = name;
    debugPrint("SpeakerProvider -> setNationalFlagName: $nationalFlagName");
    notifyListeners();
  }

  void setNationalFlagPath(String path) {
    _nationalFlagPath = path;
    debugPrint("SpeakerProvider -> setNationalFlagPath: $nationalFlagPath");
    notifyListeners();
  }

  void setLanguage(String language) {
    _language = language;
    debugPrint("SpeakerProvider -> setLanguage: $language");
    notifyListeners();
  }
}
