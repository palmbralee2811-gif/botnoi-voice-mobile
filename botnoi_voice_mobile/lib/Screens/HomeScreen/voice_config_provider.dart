import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_speaker_metadata.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoiceConfigProvider extends ChangeNotifier {
  VoiceConfigProvider() {
    init();
  }

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    selectedVoiceStyles = prefs?.getStringList("selected_voice_styles") ?? [];
    selectedSpeechStyles = prefs?.getStringList("selected_speech_styles") ?? [];
    selectedLanguage = prefs?.getString("selected_language") ?? "TH";
    selectedGender = prefs?.getString("selected_gender") ?? "ช/ญ";
    selectedSpeakerId = prefs?.getString("selected_speaker_id") ??
        embeddedSpeakerMetadata.first.speakerId;
    selectedVolume = prefs?.getDouble("selected_volume") ?? 100;
    selectedSpeed = prefs?.getDouble("selected_speed") ?? 100;
    isFavouriteSelected = prefs?.getBool("is_favourite_selected") ?? false;
    favouriteSpeakerIds = prefs?.getStringList("favourite_speaker_ids") ?? [];
    notifyListeners();
  }

  SharedPreferences? prefs;

  List<String> favouriteSpeakerIds = [];
  List<String> selectedVoiceStyles = [];
  List<String> selectedSpeechStyles = [];
  String selectedLanguage = "TH";
  String selectedGender = "ช/ญ";
  String selectedSpeakerId = embeddedSpeakerMetadata.first.speakerId;
  double selectedVolume = 100;
  double selectedSpeed = 100;
  bool isFavouriteSelected = false;

  /// Change the favourite status of a speaker
  void toggleFavouriteSpeaker(String speakerId) {
    if (favouriteSpeakerIds.contains(speakerId)) {
      favouriteSpeakerIds.remove(speakerId);
    } else {
      favouriteSpeakerIds.add(speakerId);
    }
    prefs?.setStringList("favourite_speaker_ids", favouriteSpeakerIds);
    notifyListeners();
  }

  /// Select or deselect a voice style
  void toggleVoiceStyle(String voiceStyle) {
    if (selectedVoiceStyles.contains(voiceStyle)) {
      selectedVoiceStyles.remove(voiceStyle);
    } else {
      selectedVoiceStyles.add(voiceStyle);
    }
    prefs?.setStringList("selected_voice_styles", selectedVoiceStyles);
    notifyListeners();
  }

  /// Select or deselect a speech style
  void toggleSpeechStyle(String speechStyle) {
    if (selectedSpeechStyles.contains(speechStyle)) {
      selectedSpeechStyles.remove(speechStyle);
    } else {
      selectedSpeechStyles.add(speechStyle);
    }
    prefs?.setStringList("selected_speech_styles", selectedSpeechStyles);
    notifyListeners();
  }

  /// select a language
  void setLanguage(String language) {
    selectedLanguage = language;
    prefs?.setString("selected_language", selectedLanguage);
    notifyListeners();
  }

  /// select a gender
  void setGender(String gender) {
    selectedGender = gender;
    prefs?.setString("selected_gender", gender);
    notifyListeners();
  }

  /// select a speaker ID
  void setSpeakerId(String speakerId) {
    selectedSpeakerId = speakerId;
    prefs?.setString("selected_speaker_id", speakerId);
    notifyListeners();
  }

  /// Set the volume value
  void setVolume(double volume) {
    selectedVolume = volume;
    prefs?.setDouble("selected_volume", volume);
    notifyListeners();
  }

  /// Set the speed value
  void setSpeed(double speed) {
    selectedSpeed = speed;
    prefs?.setDouble("selected_speed", speed);
    notifyListeners();
  }

  /// Toggle the favourite filter
  void toggleFavouriteSelected() {
    isFavouriteSelected = !isFavouriteSelected;
    prefs?.setBool("is_favourite_selected", isFavouriteSelected);
    notifyListeners();
  }

  /// Reset all filters to default values
  void resetFilter() {
    favouriteSpeakerIds.clear();
    selectedVoiceStyles.clear();
    selectedSpeechStyles.clear();
    selectedLanguage = "TH";
    selectedGender = "ช/ญ";
    selectedSpeakerId = embeddedSpeakerMetadata.first.speakerId;
    selectedVolume = 100;
    selectedSpeed = 100;
    isFavouriteSelected = false;
    prefs?.remove("favourite_speaker_ids");
    prefs?.remove("selected_voice_styles");
    prefs?.remove("selected_speech_styles");
    prefs?.remove("selected_language");
    prefs?.remove("selected_gender");
    prefs?.remove("selected_speaker_id");
    prefs?.remove("selected_volume");
    prefs?.remove("selected_speed");
    notifyListeners();
  }
}
