import 'package:flow3/screen/home.dart';
import 'package:flow3/screen/homescreen.dart';
// import 'package:flow3/screen/tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Color.fromARGB(255, 253, 196, 153),
  ),
  textTheme: GoogleFonts.promptTextTheme().copyWith(),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    ScreenUtilInit(
      designSize: const Size(320, 684),
      splitScreenMode: true,
      builder: (context, child) => 
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme,
        home: HomePage(),
      ),
    );
  }
}