import 'package:flutter/material.dart';
import 'package:profilenavbar/home_screen.dart';

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Botnoi Voice',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
