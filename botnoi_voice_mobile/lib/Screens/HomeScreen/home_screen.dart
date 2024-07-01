import 'package:flutter/material.dart';
import 'package:botnoi_voice_mobile/Screens/AuthScreen/auth_screen.dart';
import 'package:botnoi_voice_mobile/Authentication/authentication_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<Authentication>(
              builder: (context, auth, child) {
                return auth.user != null
                    ? Text(
                        'Signed in as ${auth.user!.displayName}',
                        style: const TextStyle(fontSize: 20),
                      )
                    : const Text(''); // ถ้ายังไม่ได้ sign-in จะแสดงว่างเปล่า
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await auth.signOut();
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



/*
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
  */
