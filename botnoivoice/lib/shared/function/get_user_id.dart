import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// DO NOT REMOVE THIS LINE
/// Get User Id from all providers
/// Using in `revenuecat_config.dart`
/// Using in `fcm_token_service.dart`

final _logger = Logger();

Future<String> _getUserIdFromProvider(
  BuildContext context,
  dynamic provider,
  String providerId,
) async {
  if (provider.isLoggedIn &&
      provider.user?.providerData[0].providerId == providerId) {
    _logger
        .d('User ID fetched from $providerId provider: ${provider.user!.uid}');
    return provider.user!.uid;
  }
  throw Exception("User is not logged in.");
}

/// Fetch User ID from all providers
Future<String> getUserIdAll(WidgetRef ref) async {
  try {
    // final lineProvider = context.read<LineLogin>();
    final lineProvider = ref.read(lineLoginNotifierProvider);
    if (lineProvider.isLoggedIn) {
      if (lineProvider.userId == null) {
        _logger.e("Get User ID All from LINE is null");
        return "";
      }
      _logger.d('User ID fetched from LINE provider: ${lineProvider.userId}');
      return lineProvider.userId ?? "";
    }

    final appleProvider = ref.read(appleLoginNotifierProvider);
    if (appleProvider.isLoggedIn) {
      return _getUserIdFromProvider(ref.context, appleProvider, 'apple.com');
    }

    final googleProvider = ref.read(googleLoginNotifierProvider);
    if (googleProvider.isLoggedIn) {
      return _getUserIdFromProvider(ref.context, googleProvider, 'google.com');
    }

    final emailProvider = ref.read(emailLoginNotifierProvider);
    if (emailProvider.isLoggedIn) {
      return _getUserIdFromProvider(ref.context, emailProvider, 'password');
    }

    throw Exception("User is not logged in.");
  } catch (error) {
    _logger.e('Failed to fetch user ID: $error');
    throw Exception("Failed to fetch user ID.");
  }
}

/// Fetch User ID from Email Provider
Future<String> getUserIdEmail(WidgetRef ref) async {
  final emailProvider = ref.read(emailLoginNotifierProvider);
  return _getUserIdFromProvider(ref.context, emailProvider, 'password');
}

/// Fetch User ID from Google Provider
Future<String> getUserIdGoogle(WidgetRef ref) async {
  final googleProvider = ref.read(googleLoginNotifierProvider);
  return _getUserIdFromProvider(ref.context, googleProvider, 'google.com');
}

/// Fetch User ID from Line Provider
Future<String> getUserIdLine(WidgetRef ref) async {
  final lineProvider = ref.read(lineLoginNotifierProvider);
  if (lineProvider.isLoggedIn) {
    if (lineProvider.userId == null) {
      _logger.e("Get User ID Line is null");
      return "";
    }

    _logger.d('User ID fetched from LINE provider: ${lineProvider.userId!}');
    return lineProvider.userId ?? "";
  }
  throw Exception("User is not logged in.");
}

/// Fetch User ID from Apple Provider
Future<String> getUserIdApple(WidgetRef ref) async {
  final appleProvider = ref.read(appleLoginNotifierProvider);
  return _getUserIdFromProvider(ref.context, appleProvider, 'apple.com');
}
