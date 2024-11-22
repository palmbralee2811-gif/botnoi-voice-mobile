// models/speaker_entity.dart

import 'package:flutter/widgets.dart';

class SpeakerEntity {
  final String speakerId;
  final String speakerName;
  final String engName;
  final String thaiName;

  SpeakerEntity({
    required this.speakerId,
    required this.speakerName,
    required this.engName,
    required this.thaiName,
  });

  // Getter for the name based on the current locale
  String get name {
    return LocaleProvider.locale.languageCode == 'th' ? thaiName : engName;
  }
}
