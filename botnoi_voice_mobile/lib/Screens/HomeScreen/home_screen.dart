import 'package:botnoi_voice_mobile/Screens/AuthScreen/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:botnoi_voice_mobile/Authentication/authentication_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile Page'),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<Authentication>(context, listen: false)
                    .signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
              },
              child: const Text('Sign-out'),
            ),
          ],
        ),
      ),
    );
  }
}
