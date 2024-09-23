import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Repository for Speaker operations
class SpeakerRepositoryImpl with ChangeNotifier {
  final Logger logger = Logger(); // Logger for Debugging mode

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
    logger.d("SpeakerProvider -> setSpeakerId: $speakerId");
    notifyListeners();
  }

  void setSpeakerName(String name) {
    _speakerName = name;
    logger.d("SpeakerProvider -> setSpeakerName: $speakerName");
    notifyListeners();
  }

  void setSpeakerAudio(String audio) {
    _speakerAudio = audio;
    logger.d("SpeakerProvider -> setSpeakerAudio: $speakerAudio");
    notifyListeners();
  }

  void setSpeakerImagePath(String path) {
    _speakerImagePath = path;
    logger.d("SpeakerProvider -> setSpeakerImagePath: $speakerImagePath");
    notifyListeners();
  }

  void setNationalFlagName(String name) {
    _nationalFlagName = name;
    logger.d("SpeakerProvider -> setNationalFlagName: $nationalFlagName");
    notifyListeners();
  }

  void setNationalFlagPath(String path) {
    _nationalFlagPath = path;
    logger.d("SpeakerProvider -> setNationalFlagPath: $nationalFlagPath");
    notifyListeners();
  }

  void setLanguage(String language) {
    _language = language;
    logger.d("SpeakerProvider -> setLanguage: $language");
    notifyListeners();
  }
}
