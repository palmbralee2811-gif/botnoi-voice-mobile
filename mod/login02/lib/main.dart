import 'package:flutter/material.dart';
import 'package:login02/login02.dart';

void main() {
  runApp(const MaterialApp(
    home: Login(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BOTNOI Voice',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}
