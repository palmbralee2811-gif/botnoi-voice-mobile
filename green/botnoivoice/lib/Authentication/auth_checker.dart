import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Model/speaker_model.dart';
import 'package:botnoivoice/Screens/AuthScreen/login_screen.dart';
import 'package:botnoivoice/Screens/HomeScreen/home.dart';
import 'package:botnoivoice/Screens/HomeScreen/voiceScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthChecker extends StatefulWidget {
  final String speakerId;

  const AuthChecker({super.key, required this.speakerId});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  List<Speaker> speakers = [];

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Authentication>(context).isAuthenticated) {
      
      return HomePage();

      // return VoiceScreen();

      // return const Homescreen();
    } else {
      return const LoginScreen();
    }
  }
}
