import 'package:flutter/material.dart';

class SpeakerProvider with ChangeNotifier {
  String? _speakerId;

  String? get speakerId => _speakerId;

  void setSpeakerId(String id) {
    _speakerId = id;
    debugPrint("setSpeakerId -> speakerId: $speakerId");
    notifyListeners();
  }
}
