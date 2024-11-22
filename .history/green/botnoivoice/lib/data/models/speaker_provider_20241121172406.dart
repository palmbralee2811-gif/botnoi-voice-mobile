// providers/speaker_provider.dart

import 'package:botnoivoice/domain/entities/speaker_entity.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/models/speaker_entity.dart';

class SpeakerProvider extends ChangeNotifier {
  SpeakerEntity? speaker;

  // Set the current speaker
  void setSpeaker(SpeakerEntity speakerEntity) {
    speaker = speakerEntity;
    notifyListeners();
  }

  // Get the current speaker
  SpeakerEntity? get currentSpeaker => speaker;
}
