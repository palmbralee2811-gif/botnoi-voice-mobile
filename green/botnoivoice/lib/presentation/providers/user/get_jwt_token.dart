import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

Future<String?> _getTokenFromProvider(
    BuildContext context, dynamic loginProvider, dynamic tokenProvider) async {
  if (loginProvider.isLoggedIn) {
    final jwtToken = tokenProvider.getJwtToken;
    _logger.d('ID Token fetched from ${loginProvider.runtimeType}: $jwtToken');
    return jwtToken;
  }
  return null;
}

Future<String?> getJwtTokenAll(BuildContext context) async {
  try {
    _logger.d('Attempting to fetch ID Token from all providers.');

    final lineToken = await _getTokenFromProvider(
        context,
        Provider.of<LineLoginProvider>(context, listen: false),
        Provider.of<LineTokenProvider>(context, listen: false));
    if (lineToken != null) return lineToken;

    final googleToken = await _getTokenFromProvider(
        context,
        Provider.of<GoogleLoginProvider>(context, listen: false),
        Provider.of<GoogleTokenProvider>(context, listen: false));
    if (googleToken != null) return googleToken;

    final appleToken = await _getTokenFromProvider(
        context,
        Provider.of<AppleLoginProvider>(context, listen: false),
        Provider.of<AppleTokenProvider>(context, listen: false));
    if (appleToken != null) return appleToken;

    final emailToken = await _getTokenFromProvider(
        context,
        Provider.of<EmailLoginProvider>(context, listen: false),
        Provider.of<EmailTokenProvider>(context, listen: false));
    if (emailToken != null) return emailToken;

    _logger.d('No ID Token fetched from any provider.');
    return null;
  } catch (e) {
    _logger.e('Error fetching ID Token: $e');
    return null;
  }
}
