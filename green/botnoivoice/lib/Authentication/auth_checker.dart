import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Screens/AuthScreen/auth_screen.dart';
import 'package:botnoivoice/Screens/HomeScreen/home_screen.dart';
import 'package:botnoivoice/Screens/HomeScreen/voiceScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Authentication>(context).isAuthenticated) {
      // return const HomeScreen();
      return const VoiceScreen();
    } else {
      return const AuthScreen();
    }
  }
}
