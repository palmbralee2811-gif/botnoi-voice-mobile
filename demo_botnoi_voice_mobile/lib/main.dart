import 'package:demo_botnoi_voice_mobile/function/voiceScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const VoiceApp());
}

class VoiceApp extends StatelessWidget {
  const VoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Voice App',
      home: VoiceScreen(),
    );
  }
}
