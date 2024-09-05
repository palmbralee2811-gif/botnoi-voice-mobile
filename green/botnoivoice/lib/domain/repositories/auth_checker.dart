import 'package:botnoivoice/data/repositories/auth_repository_impl.dart';
import 'package:botnoivoice/presentation/screens/home/home_screen.dart';
import 'package:botnoivoice/presentation/screens/login/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  var _isLoading = true;
  late AuthenticationRepositoryImpl auth;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    auth = Provider.of<AuthenticationRepositoryImpl>(context, listen: false);
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await auth.loadAuthStatus();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (Provider.of<AuthenticationRepositoryImpl>(context).isAuthenticated !=
        false) {
      return const HomeScreen();
    } else {
      return const AuthScreen();
    }
  }
}
