// import 'package:firebase_core/firebase_core.dart';
// import 'package:flow3/firebase/login_page.dart';
// import 'package:flow3/model/favoritemodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flow3/firebase_options.dart';
import 'package:flow3/screen/home.dart';
// import 'package:flow3/screen/home.dart';
import 'package:flow3/screen/login.dart';
// import 'package:flow3/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 253, 196, 153),
  ),
  textTheme: GoogleFonts.promptTextTheme().copyWith(),
);
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
    designSize: const Size(320, 684),
    splitScreenMode: true,
    builder: (context, child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme,
      home: const LoginPage(),
    ),
  );
}
