import 'package:botnoivoice/domain/usecases/get_user_id.dart';
import 'package:botnoivoice/presentation/providers/email/email_change_username_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_delete_account_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_register_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_forget_password_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/domain/repositories/auth_checker.dart';
import 'package:botnoivoice/data/repositories/speaker_repository_impl.dart';
import 'package:botnoivoice/firebase_options.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:botnoivoice/presentation/providers/payment/payment_provider.dart';
import 'package:botnoivoice/presentation/providers/permission/permission_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LineSDK.instance.setup("1656375389").then((_) {
    print("LineSDK Prepared");
  });

  await configureRevenueCat();

  runApp(const BotnoiVoiceApp());
}

class BotnoiVoiceApp extends StatelessWidget {
  const BotnoiVoiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoogleLoginProvider()),
        ChangeNotifierProvider(create: (_) => GoogleTokenProvider()),
        ChangeNotifierProvider(create: (_) => SpeakerRepositoryImpl()),
        ChangeNotifierProvider(create: (_) => PermissionProvider()),
        ChangeNotifierProvider(create: (_) => LineLoginProvider()),
        ChangeNotifierProvider(create: (_) => LineTokenProvider()),
        ChangeNotifierProvider(create: (_) => EmailLoginProvider()),
        ChangeNotifierProvider(create: (_) => EmailRegisterProvider()),
        ChangeNotifierProvider(create: (_) => EmailForgetPasswordProvider()),
        ChangeNotifierProvider(create: (_) => EmailTokenProvider()),
        ChangeNotifierProvider(create: (_) => EmailUsernameApiProvider()),
        ChangeNotifierProvider(create: (_) => EmailDeleteAccountProvider()),
        ChangeNotifierProvider(create: (_) => EmailChangeUsernameProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
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
              textTheme: GoogleFonts.promptTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            home: AuthChecker(),
          );
        },
      ),
    );
  }
}
