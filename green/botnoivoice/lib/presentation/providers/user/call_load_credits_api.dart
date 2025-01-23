import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:provider/provider.dart';

/// Call the load remaining credits API for all the providers
Future<void> callLoadCreditsApi(context) async {
  final appleProvider = Provider.of<AppleLoginProvider>(context, listen: false);
  final googleProvider = Provider.of<GoogleLoginProvider>(context, listen: false);
  final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
  final emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);

  if (appleProvider.isLoggedIn &&
      appleProvider.user?.providerData[0].providerId == 'apple.com') {
    await Provider.of<AppleTokenProvider>(context, listen: false)
        .loadRemainingCredits();
  }

  if (googleProvider.isLoggedIn &&
      googleProvider.user?.providerData[0].providerId == 'google.com') {
    await Provider.of<GoogleTokenProvider>(context, listen: false)
        .loadRemainingCredits();
  }

  if (lineProvider.isLoggedIn) {
    await Provider.of<LineTokenProvider>(context, listen: false)
        .loadRemainingCredits();
  }

  if (emailProvider.isLoggedIn &&
      emailProvider.user?.providerData[0].providerId == 'password') {
    await Provider.of<EmailTokenProvider>(context, listen: false)
        .loadRemainingCredits();
  }
}
