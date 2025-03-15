import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/line_token.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

/// DO NOT REMOVE THIS LINE
/// Get JWT Token from all providers
/// Using in `coupon_service.dart`

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
        Provider.of<LineLogin>(context, listen: false),
        Provider.of<LineToken>(context, listen: false));
    if (lineToken != null) return lineToken;

    final googleToken = await _getTokenFromProvider(
        context,
        Provider.of<GoogleLogin>(context, listen: false),
        Provider.of<GoogleToken>(context, listen: false));
    if (googleToken != null) return googleToken;

    final appleToken = await _getTokenFromProvider(
        context,
        Provider.of<AppleLogin>(context, listen: false),
        Provider.of<AppleToken>(context, listen: false));
    if (appleToken != null) return appleToken;

    final emailToken = await _getTokenFromProvider(
        context,
        Provider.of<EmailLogin>(context, listen: false),
        Provider.of<EmailToken>(context, listen: false));
    if (emailToken != null) return emailToken;

    _logger.d('No ID Token fetched from any provider.');
    return null;
  } catch (e) {
    _logger.e('Error fetching ID Token: $e');
    return null;
  }
}
