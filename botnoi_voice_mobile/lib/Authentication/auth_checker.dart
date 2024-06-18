import 'package:botnoi_voice_mobile/Authentication/authentication_provider.dart';
import 'package:botnoi_voice_mobile/Screens/AuthScreen/auth_screen.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Authentication>(context).isAuthenticated) {
      return const HomeScreen();
    } else {
      return const AuthScreen();
    }
  }
}
