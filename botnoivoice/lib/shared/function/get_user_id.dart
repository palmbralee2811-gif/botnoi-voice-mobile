import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

/// DO NOT REMOVE THIS LINE
/// Get User Id from all providers
/// Using in `revenuecat_config.dart`
/// Using in `fcm_token_service.dart`

final _logger = Logger();

Future<String> _getUserIdFromProvider(
    BuildContext context, dynamic provider, String providerId) async {
  if (provider.isLoggedIn &&
      provider.user?.providerData[0].providerId == providerId) {
    _logger
        .d('User ID fetched from $providerId provider: ${provider.user!.uid}');
    return provider.user!.uid;
  }
  throw Exception("User is not logged in.");
}

/// Fetch User ID from all providers
Future<String> getUserIdAll(BuildContext context) async {
  try {
    final lineProvider = context.read<LineLogin>();
    if (lineProvider.isLoggedIn) {
      _logger.d(
          'User ID fetched from LINE provider: ${lineProvider.getLineUserId!}');
      return lineProvider.getLineUserId!;
    }

    final appleProvider = context.read<AppleLogin>();
    if (appleProvider.isLoggedIn) {
      return _getUserIdFromProvider(context, appleProvider, 'apple.com');
    }

    final googleProvider = context.read<GoogleLogin>();
    if (googleProvider.isLoggedIn) {
      return _getUserIdFromProvider(context, googleProvider, 'google.com');
    }

    final emailProvider = context.read<EmailLogin>();
    if (emailProvider.isLoggedIn) {
      return _getUserIdFromProvider(context, emailProvider, 'password');
    }

    throw Exception("User is not logged in.");
  } catch (error) {
    _logger.e('Failed to fetch user ID: $error');
    throw Exception("Failed to fetch user ID.");
  }
}

/// Fetch User ID from Email Provider
Future<String> getUserIdEmail(BuildContext context) async {
  final emailProvider = context.read<EmailLogin>();
  return _getUserIdFromProvider(context, emailProvider, 'password');
}

/// Fetch User ID from Google Provider
Future<String> getUserIdGoogle(BuildContext context) async {
  final googleProvider = context.read<GoogleLogin>();
  return _getUserIdFromProvider(context, googleProvider, 'google.com');
}

/// Fetch User ID from Line Provider
Future<String> getUserIdLine(BuildContext context) async {
  final lineProvider = context.read<LineLogin>();
  if (lineProvider.isLoggedIn) {
    _logger.d(
        'User ID fetched from LINE provider: ${lineProvider.getLineUserId!}');
    return lineProvider.getLineUserId!;
  }
  throw Exception("User is not logged in.");
}

/// Fetch User ID from Apple Provider
Future<String> getUserIdApple(BuildContext context) async {
  final appleProvider = context.read<AppleLogin>();
  return _getUserIdFromProvider(context, appleProvider, 'apple.com');
}
