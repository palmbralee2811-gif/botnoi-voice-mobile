import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Screens/HomeScreen/home.dart';
import 'package:botnoivoice/Screens/LoginScreen/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Authentication>(context).isAuthenticated!=false) {
      return const HomePage();
    } else {
      return const LoginScreen();
    }
  }
}
