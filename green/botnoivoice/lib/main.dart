import 'package:botnoivoice/domain/usecases/sign_in_out.dart';
import 'package:botnoivoice/data/managers/token_manager.dart';
import 'package:botnoivoice/domain/repositories/auth_checker.dart';
import 'package:botnoivoice/data/repositories/speaker_repository_impl.dart';
import 'package:botnoivoice/data/repositories/credits_repository_impl.dart';
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
        ChangeNotifierProvider(create: (_) => SignInOut()),
        ChangeNotifierProvider(create: (_) => TokenManager()),
        ChangeNotifierProvider(create: (context) => SpeakerRepositoryImpl()),
        ChangeNotifierProvider(create: (context) => CreditsRepositoryImpl()),
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
