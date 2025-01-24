import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

Future<String?> getRemainingCredits(BuildContext context) async {
  final appleProvider = Provider.of<AppleLoginProvider>(context, listen: false);
  final googleProvider = Provider.of<GoogleLoginProvider>(context, listen: false);
  final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
  final emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);

  try {
    if (appleProvider.isLoggedIn && appleProvider.user?.providerData[0].providerId == 'apple.com') {
      _logger.d('User logged in with Apple');
      final credits = Provider.of<AppleTokenProvider>(context, listen: false).getRemainingCredits;
      _logger.d('Remaining credits from Apple: $credits');
      return credits;
    }

    if (googleProvider.isLoggedIn && googleProvider.user?.providerData[0].providerId == 'google.com') {
      _logger.d('User logged in with Google');
      final credits = Provider.of<GoogleTokenProvider>(context, listen: false).getRemainingCredits;
      _logger.d('Remaining credits from Google: $credits');
      return credits;
    }

    if (lineProvider.isLoggedIn) {
      _logger.d('User logged in with LINE');
      final credits = Provider.of<LineTokenProvider>(context, listen: false).getRemainingCredits;
      _logger.d('Remaining credits from LINE: $credits');
      return credits;
    }

    if (emailProvider.isLoggedIn && emailProvider.user?.providerData[0].providerId == 'password') {
      _logger.d('User logged in with Email');
      final credits = Provider.of<EmailTokenProvider>(context, listen: false).getRemainingCredits;
      _logger.d('Remaining credits from Email: $credits');
      return credits;
    }

    _logger.w('No valid login provider found');
    return "N/A";
  } catch (e) {
    _logger.e('Failed to get remaining credits', error: e);
    return "N/A";
  }
}