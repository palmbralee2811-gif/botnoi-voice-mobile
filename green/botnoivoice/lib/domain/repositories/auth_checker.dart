import 'package:botnoivoice/domain/repositories/init_screen.dart';
import 'package:botnoivoice/domain/usecases/sign_in_out.dart';
import 'package:botnoivoice/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    if (Provider.of<SignInOut>(context).isAuthenticated) {
      return const InitScreen();
    } else {
      return const LoginScreen();
    }
  }
}
