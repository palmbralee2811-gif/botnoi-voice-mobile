import 'package:botnoivoice/config/api_key_config.dart';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/service/redeem_coupon/redeem_coupon_service.dart';
import 'package:botnoivoice/shared/function/app_language_function.dart';
import 'package:botnoivoice/routing.dart';
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/reward/reward_service.dart';
import 'package:botnoivoice/shared/function/call_reload_data.dart';
import 'package:botnoivoice/service/email/email_change_username.dart';
import 'package:botnoivoice/service/delete_account/delete_account_service.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/email/email_register.dart';
import 'package:botnoivoice/service/email/email_forget_password.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/service/email/email_username_api.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/screen/main/home_speaker_data_management.dart';
import 'package:botnoivoice/firebase_options.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/line_token.dart';
import 'package:botnoivoice/service/payment/payment_service.dart';
import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LineSDK.instance.setup(lineSdkChannelId).then((_) {
    print("LineSDK Prepared");
  });

  // โหลดภาษาเริ่มต้นจาก LanguageHelper
  String localeCode = await loadSelectedLanguage();
  Locale initialLocale = localeCode.isNotEmpty
      ? Locale(localeCode)
      : const Locale('th');

  runApp(
    // 1. REMOVE 'const' HERE
    ProviderScope( 
      // 2. REMOVE 'const' HERE
      child: EasyLocalization(
        supportedLocales: const [ // This array IS const, so we keep 'const' inside
          Locale('en'),
          Locale('th'),
          Locale('id')
        ],
        path: 'assets/langs',
        fallbackLocale: const Locale('th'),
        // 'initialLocale' is determined at runtime, so the constructor call cannot be 'const'
        startLocale: initialLocale, 
        child: const BotnoiVoiceApp(), // BotnoiVoiceApp can remain const
      ),
    ),
  );
}

class BotnoiVoiceApp extends StatelessWidget {
  const BotnoiVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. ใช้ provider.MultiProvider และ provider.ChangeNotifierProvider
    return provider.MultiProvider(
      providers: [
        provider.ChangeNotifierProvider(create: (_) => AppleLogin()),
        provider.ChangeNotifierProvider(create: (_) => AppleToken()),
        provider.ChangeNotifierProvider(create: (_) => GoogleLogin()),
        provider.ChangeNotifierProvider(create: (_) => GoogleToken()),
        provider.ChangeNotifierProvider(create: (_) => HomeSpeakerDataManagement()),
        provider.ChangeNotifierProvider(create: (_) => LineLogin()),
        provider.ChangeNotifierProvider(create: (_) => LineToken()),
        provider.ChangeNotifierProvider(create: (_) => EmailLogin()),
        provider.ChangeNotifierProvider(create: (_) => EmailRegister()),
        provider.ChangeNotifierProvider(create: (_) => EmailForgetPassword()),
        provider.ChangeNotifierProvider(create: (_) => EmailToken()),
        provider.ChangeNotifierProvider(create: (_) => EmailUsernameApi()),
        provider.ChangeNotifierProvider(create: (_) => DeleteAccountService()),
        provider.ChangeNotifierProvider(create: (_) => EmailChangeUsername()),
        provider.ChangeNotifierProvider(create: (_) => PaymentService()),
        provider.ChangeNotifierProvider(create: (_) => CheckUserIsShowEmail()),
        provider.ChangeNotifierProvider(create: (_) => RewardService()),
        provider.ChangeNotifierProvider(create: (_) => RedeemCouponService()),
        provider.ChangeNotifierProvider(create: (_) => CallReloadData()),
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