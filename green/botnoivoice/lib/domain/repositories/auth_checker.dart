import 'package:botnoivoice/domain/repositories/init_screen.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Check if the user is authenticated
class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    if (Provider.of<GoogleLoginProvider>(context).isAuthenticated) {
      return const InitScreen();
    } else {
      return const LoginScreen();
    }
  }
}
