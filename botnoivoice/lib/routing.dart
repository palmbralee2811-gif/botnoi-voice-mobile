import 'package:botnoivoice/auth/app_language_checker.dart';
import 'package:botnoivoice/auth/auth_checker.dart';
import 'package:botnoivoice/auth/token_checker.dart';
import 'package:botnoivoice/screen/drawer/account/account_screen.dart';
import 'package:botnoivoice/screen/drawer/account/change_email_username_screen.dart';
import 'package:botnoivoice/screen/drawer/account/confirm_delete_account_screen.dart';
import 'package:botnoivoice/screen/drawer/account/delete_account_screen.dart';
import 'package:botnoivoice/screen/drawer/education/education_screen.dart';
import 'package:botnoivoice/screen/drawer/reward/reward_screen.dart';
import 'package:botnoivoice/screen/drawer/drawer_appbar.dart';
import 'package:botnoivoice/screen/drawer/email_permission/email_permission_screen.dart';
import 'package:botnoivoice/screen/email/email_login_screen.dart';
import 'package:botnoivoice/screen/email/forget_password/confirm_forget_password_screen.dart';
import 'package:botnoivoice/screen/email/forget_password/forget_password_screen.dart';
import 'package:botnoivoice/screen/email/forget_password/new_password_screen.dart';
import 'package:botnoivoice/screen/email/policy/privacy_policy_screen.dart';
import 'package:botnoivoice/screen/email/policy/terms_service_screen.dart';
import 'package:botnoivoice/screen/email/register_screen.dart';
import 'package:botnoivoice/screen/login/login_screen.dart';
import 'package:botnoivoice/screen/main/home/home_screen.dart';
import 'package:botnoivoice/screen/main/speaker/speaker_screen.dart';
import 'package:botnoivoice/screen/drawer/gensub/upload_rec_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      // First screen to show when the app is open
      path: '/',
      builder: (context, state) => const AppLanguageChecker(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => AuthChecker(),
    ),
    GoRoute(
      path: '/token',
      builder: (context, state) => const TokenChecker(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/email-login',
      builder: (context, state) => const EmailLoginScreen(),
    ),
    GoRoute(
      path: '/terms-service',
      builder: (context, state) => const TermsServiceScreen(),
    ),
    GoRoute(
      path: '/privacy-policy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/speaker',
      builder: (context, state) => const SpeakerScreen(),
    ),
    GoRoute(
      path: '/drawer',
      builder: (context, state) => const DrawerAppbar(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountScreen(),
    ),
    GoRoute(
      path: '/change-email-username',
      builder: (context, state) => const ChangeEmailUsernameScreen(),
    ),
    GoRoute(
      path: '/new-password/:code',
      builder: (context, state) {
        final code = state.pathParameters['code'] ?? '';
        return NewPasswordScreen(resetCode: code);
      },
    ),
    GoRoute(
      path: '/forget-password',
      builder: (context, state) => const ForgetPasswordScreen(),
    ),
    GoRoute(
      path: '/confirm-forget-password',
      builder: (context, state) => const ConfirmForgetPasswordScreen(),
    ),
    GoRoute(
      path: '/reward',
      builder: (context, state) => const RewardScreen(),
    ),
    GoRoute(
      path: '/education',
      builder: (context, state) => const EducationScreen(),
    ),
    GoRoute(
      path: '/email-permission',
      builder: (context, state) => const EmailPermissionScreen(),
    ),
    GoRoute(
      path: '/delete-account',
      builder: (context, state) => const DeleteAccountScreen(),
    ),
    // Enter Password and Finish Delete Account
    GoRoute(
      path: '/confirm-delete-account',
      builder: (context, state) => const ConfirmDeleteAccountScreen(),
    ),
    GoRoute(
  path: '/gensub',
  builder: (context, state) => const UploadRecScreen(),
),
  ],
);
