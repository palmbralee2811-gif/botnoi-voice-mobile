import 'package:flutter/material.dart';
import 'package:pricepackage/Homescreen.dart';
import 'package:pricepackage/package.dart';

void main() {
  runApp(const MaterialApp(
    home: Package(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
