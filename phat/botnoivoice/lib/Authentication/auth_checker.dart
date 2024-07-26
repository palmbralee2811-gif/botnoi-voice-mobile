import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Screens/HomeScreen/home.dart';
import 'package:botnoivoice/Screens/LoginScreen/login.dart';
import 'package:botnoivoice/Screens/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

 @override
  State<AuthChecker> createState() => _AuthCheckerState();
}
class _AuthCheckerState extends State<AuthChecker> {
  var _isLoading = true;
  late Authentication auth;
  @override
  void initState() {
    super.initState();
    auth = Provider.of<Authentication>(context, listen: false);
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

    if (_isLoading){
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (Provider.of<Authentication>(context).isAuthenticated!=false) {
      return const HomePage();
      //  return const MyHomePage();
    } else {
      return const LoginScreen();
    }
  }
}
