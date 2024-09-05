
import 'package:botnoivoice/domain/usecases/sign_in_out.dart';
import 'package:botnoivoice/data/managers/token_manager.dart';
import 'package:botnoivoice/presentation/screens/home/home_screen.dart';
import 'package:botnoivoice/presentation/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      debugPrint("Checking authentication status...");
      await Provider.of<TokenManager>(context, listen: false).loadAuthStatus();
    } catch (e) {
      debugPrint("Error loading auth status: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

    // Ensure isAuthenticated is properly checked
    bool isAuthenticated = Provider.of<SignInOut>(context).isAuthenticated;

    if (isAuthenticated) {
      debugPrint("User is authenticated. Navigating to HomeScreen.");
      return const HomeScreen();
    } else {
      debugPrint("User is not authenticated. Navigating to LoginScreen.");
      return const LoginScreen();
    }
  }
}