import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

/// Get the user ID from the provider
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

/// Get the current user ID from all providers
Future<String> getUserIdAll(BuildContext context) async {
  try {
    final lineProvider = Provider.of<LineLogin>(context, listen: false);
    if (lineProvider.isLoggedIn) {
      _logger.d(
          'User ID fetched from LINE provider: ${lineProvider.getLineUserId!}');
      return lineProvider.getLineUserId!;
    }

    final appleProvider = Provider.of<AppleLogin>(context, listen: false);
    if (appleProvider.isLoggedIn) {
      return _getUserIdFromProvider(context, appleProvider, 'apple.com');
    }

    final googleProvider = Provider.of<GoogleLogin>(context, listen: false);
    if (googleProvider.isLoggedIn) {
      return _getUserIdFromProvider(context, googleProvider, 'google.com');
    }

    final emailProvider = Provider.of<EmailLogin>(context, listen: false);
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
  final emailProvider = Provider.of<EmailLogin>(context, listen: false);
  return _getUserIdFromProvider(context, emailProvider, 'password');
}

/// Fetch User ID from Google Provider
Future<String> getUserIdGoogle(BuildContext context) async {
  final googleProvider = Provider.of<GoogleLogin>(context, listen: false);
  return _getUserIdFromProvider(context, googleProvider, 'google.com');
}

/// Fetch User ID from Line Provider
Future<String> getUserIdLine(BuildContext context) async {
  final lineProvider = Provider.of<LineLogin>(context, listen: false);
  if (lineProvider.isLoggedIn) {
    _logger.d(
        'User ID fetched from LINE provider: ${lineProvider.getLineUserId!}');
    return lineProvider.getLineUserId!;
  }
  throw Exception("User is not logged in.");
}

/// Fetch User ID from Apple Provider
Future<String> getUserIdApple(BuildContext context) async {
  final appleProvider = Provider.of<AppleLogin>(context, listen: false);
  return _getUserIdFromProvider(context, appleProvider, 'apple.com');
}
