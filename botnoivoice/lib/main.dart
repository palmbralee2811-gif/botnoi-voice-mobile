import 'package:botnoivoice/config/api_key_config.dart';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/function/app_language_function.dart';
import 'package:botnoivoice/routing.dart';
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/reward/reward_service.dart';
import 'package:botnoivoice/function/call_reload_data.dart';
import 'package:botnoivoice/service/email/email_change_username.dart';
import 'package:botnoivoice/service/delete_account/delete_account_service.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/email/email_register.dart';
import 'package:botnoivoice/service/email/email_forget_password.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/service/email/email_username_api.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/ui/screen/main/home_speaker_data_management.dart';
import 'package:botnoivoice/firebase_options.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/line_token.dart';
import 'package:botnoivoice/service/payment/payment_service.dart';
import 'package:botnoivoice/service/permission/android_permission.dart';
import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LineSDK.instance.setup(lineSdkChannelId).then((_) {
    print("LineSDK Prepared");
  });

  // โหลดภาษาเริ่มต้นจาก LanguageHelper
  String localeCode = await loadSelectedLanguage();
  Locale initialLocale = localeCode.isNotEmpty
      ? Locale(localeCode) // ใช้ภาษาที่เลือกไว้
      : const Locale('th'); // ค่าเริ่มต้นเป็นภาษาไทย

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('th'),
        Locale('id')
      ], // Supported locales
      path: 'assets/langs', // Path to your localization files
      fallbackLocale: const Locale(
          'th'), // ตั้งภาษาเริ่มต้นเป็นภาษาไทย หากไม่มีการเลือกภาษา
      // startLocale: const Locale('th', 'TH'), //ภาษาเริ่มต้น
      // startLocale: const Locale('en', 'US'), //ภาษาเริ่มต้น
      startLocale: initialLocale, //ภาษาเริ่มต้น
      child: const BotnoiVoiceApp(),
    ),
  );
}

class BotnoiVoiceApp extends StatelessWidget {
  const BotnoiVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppleLogin()),
        ChangeNotifierProvider(create: (_) => AppleToken()),
        ChangeNotifierProvider(create: (_) => GoogleLogin()),
        ChangeNotifierProvider(create: (_) => GoogleToken()),
        ChangeNotifierProvider(create: (_) => HomeSpeakerDataManagement()),
        ChangeNotifierProvider(create: (_) => AndroidPermission()),
        ChangeNotifierProvider(create: (_) => LineLogin()),
        ChangeNotifierProvider(create: (_) => LineToken()),
        ChangeNotifierProvider(create: (_) => EmailLogin()),
        ChangeNotifierProvider(create: (_) => EmailRegister()),
        ChangeNotifierProvider(create: (_) => EmailForgetPassword()),
        ChangeNotifierProvider(create: (_) => EmailToken()),
        ChangeNotifierProvider(create: (_) => EmailUsernameApi()),
        ChangeNotifierProvider(create: (_) => DeleteAccountService()),
        ChangeNotifierProvider(create: (_) => EmailChangeUsername()),
        ChangeNotifierProvider(create: (_) => PaymentService()),
        ChangeNotifierProvider(create: (_) => CheckUserIsShowEmail()),
        ChangeNotifierProvider(create: (_) => RewardService()),
        ChangeNotifierProvider(create: (_) => CallReloadData()),
      ],
      child: ScreenUtilInit(
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
            // Home should be wrapped with the EasyLocalization
            // Add localization delegate
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
