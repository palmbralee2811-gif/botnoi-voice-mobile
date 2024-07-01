import 'package:flutter/material.dart';
import 'package:botnoi_voice_mobile/Authentication/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/home_screen.dart';

// Sign-in Screen
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign-in with Google'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final user = await auth.signInWithGoogle(context);
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to sign in. Please try again.')),
              );
            }
          },
          child: const Text('Sign-in with Google'),
        ),
      ),
    );
  }
}


/*
return Scaffold(
      appBar: AppBar(
        title: const Text('Sign-in with Google'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              await Provider.of<Authentication>(context, listen: false)
                  .signInWithGoogle(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.add),
                  ),
                  Text(
                    'Sign-in with Google Account',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    */
