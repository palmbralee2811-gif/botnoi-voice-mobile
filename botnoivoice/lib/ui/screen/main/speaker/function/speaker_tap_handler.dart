import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/data/entities/speaker_entity.dart';
import 'package:botnoivoice/ui/screen/main/home_speaker_data_management.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<void> handleSpeakerTap({
  required BuildContext context,
  required int index,
  required SpeakerEntity speakerItem,
  required AudioPlayer audioPlayer,
  required Set<int> selectedIndex,
  required Function(Set<int>) setSelectedIndex,
  required String selectedLanguage,
  required String selectedLanguageImage,
}) async {
  String audioURL = speakerItem.audio;

  Future<void> playAudio() async {
    try {
      if (audioPlayer.state == PlayerState.playing) {
        await audioPlayer.stop();
      }

      final response = await http.get(
        Uri.parse(audioURL),
        headers: {
          'Referer': 'https://voice.botnoi.ai/',
        },
      );

      if (response.statusCode == 200) {
        final audioBytes = response.bodyBytes;
        if (audioBytes.isNotEmpty) {
          final mimeType = response.headers['content-type'] ?? 'audio/wav';
          await audioPlayer.play(BytesSource(audioBytes, mimeType: mimeType));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading audio: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  String languageCode = Localizations.localeOf(context).languageCode;
  String speakerName;

  switch (languageCode) {
    case 'th':
      speakerName = speakerItem.thaiName;
      break;
    case 'en':
    case 'id':
      speakerName = speakerItem.engName;
      break;
    default:
      speakerName = speakerItem.engName;
      break;
  }

  final homeSpeakerProvider = context.read<HomeSpeakerDataManagement>();
  homeSpeakerProvider.setLanguage(speakerItem.language.toLowerCase());
  homeSpeakerProvider.setSpeakerId(speakerItem.speakerId);
  homeSpeakerProvider.setSpeakerName(speakerName);
  homeSpeakerProvider.setSpeakerAudio(speakerItem.audio);
  homeSpeakerProvider.setSpeakerImagePath(speakerItem.squareImage);
  homeSpeakerProvider.setNationalFlagPath(selectedLanguageImage);
  homeSpeakerProvider.setNationalFlagName(selectedLanguage);

  if (selectedIndex.contains(index)) {
    // ถ้าเคยกดแล้ว
    await audioPlayer.stop();
    selectedIndex.remove(index);
    setSelectedIndex(Set.from(selectedIndex));
  } else {
    // ถ้ายังกด
    await playAudio();
    selectedIndex.clear();
    selectedIndex.add(index);
    setSelectedIndex(Set.from(selectedIndex));
  }
}
