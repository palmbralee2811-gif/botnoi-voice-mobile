import 'package:botnoivoice/Authentication/auth_checker.dart';
import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Screens/AllSpeakerScreen/speaker_provider.dart';
import 'package:botnoivoice/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const BotnoiVoiceApp());
}

class BotnoiVoiceApp extends StatelessWidget {
  const BotnoiVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Authentication()),
        ChangeNotifierProvider(create: (context) => SpeakerProvider())
      ],
      child: ScreenUtilInit(
        designSize: const Size(320, 684),
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Botnoi Voice",
            theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
            home: const AuthChecker(),
          );
        },
      ),
    );
  }
}
