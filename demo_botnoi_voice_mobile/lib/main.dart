import 'package:demo_botnoi_voice_mobile/screen/loginModal.dart';
import 'package:demo_botnoi_voice_mobile/screen/voiceScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const VoiceApp());
}

class VoiceApp extends StatelessWidget {
  const VoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice App',
      // home: VoiceScreen(),
      home: SignInPage(),
    );
  }
}
