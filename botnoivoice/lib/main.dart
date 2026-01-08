import 'package:botnoivoice/config/api_key_config.dart';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/shared/function/app_language_function.dart';
import 'package:botnoivoice/routing.dart';
import 'package:botnoivoice/firebase_options.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LineSDK.instance.setup(lineSdkChannelId).then((_) {
    print("LineSDK Prepared");
  });

  // โหลดภาษาเริ่มต้นจาก LanguageHelper                 
  String localeCode = await loadSelectedLanguage();
  Locale initialLocale =
      localeCode.isNotEmpty ? Locale(localeCode) : const Locale('th');

  runApp(
    // ProviderScope is correctly set up here
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('th'),
          Locale('id'),
        ],
        path: 'assets/langs',
        fallbackLocale: const Locale('th'),
        startLocale: initialLocale,
        child: const BotnoiVoiceApp(),
      ),
    ),
  );
}

class BotnoiVoiceApp extends StatelessWidget {
  const BotnoiVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(320, 684),
      splitScreenMode: true,
      builder: (context, child) {
        // เรียก OrientationHelper.init ก่อนเริ่มแสดง UI
        ResponsiveDesignOrientation.init(context);
        return MaterialApp.router(
          debugShowCheckedModeBanner: isDebuggingMode,
          title: "Botnoi Voice",
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
            textTheme: GoogleFonts.promptTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: router,
        );
      },
    );
  }
}