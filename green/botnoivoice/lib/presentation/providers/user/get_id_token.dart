import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

/// Get the ID token from the provider
Future<String?> _getIdTokenFromProvider(
    BuildContext context, dynamic provider, String providerId) async {
  if (provider.isLoggedIn &&
      provider.user?.providerData[0].providerId == providerId) {
    final idToken = await provider.user?.getIdToken();
    _logger.d('ID Token fetched from $providerId provider: $idToken');
    return idToken;
  }
  throw Exception("User is not logged in.");
}

/// Get the current ID token from all providers
Future<String?> getIdTokenAll(BuildContext context) async {
  try {
    final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    if (lineProvider.isLoggedIn) {
      final idToken = lineProvider.getIdTokenRaw;
      _logger.d('ID Token fetched from LINE provider: $idToken');
      return idToken;
    }

    final appleProvider =
        Provider.of<AppleLoginProvider>(context, listen: false);
    if (appleProvider.isLoggedIn) {
      return _getIdTokenFromProvider(context, appleProvider, 'apple.com');
    }

    final googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    if (googleProvider.isLoggedIn) {
      return _getIdTokenFromProvider(context, googleProvider, 'google.com');
    }

    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);
    if (emailProvider.isLoggedIn) {
      return _getIdTokenFromProvider(context, emailProvider, 'password');
    }

    throw Exception("User is not logged in.");
  } catch (error) {
    _logger.e('Failed to fetch ID token: $error');
    throw Exception("Failed to fetch ID token.");
  }
}

/// Fetch ID token from Email Provider
Future<String?> getIdTokenEmail(BuildContext context) async {
  final emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);
  return _getIdTokenFromProvider(context, emailProvider, 'password');
}

/// Fetch ID token from Google Provider
Future<String?> getIdTokenGoogle(BuildContext context) async {
  final googleProvider =
      Provider.of<GoogleLoginProvider>(context, listen: false);
  return _getIdTokenFromProvider(context, googleProvider, 'google.com');
}

/// Fetch ID token from Line Provider
Future<String?> getIdTokenLine(BuildContext context) async {
  final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
  if (lineProvider.isLoggedIn) {
    final idToken = lineProvider.getIdTokenRaw;
    _logger.d('ID Token fetched from LINE provider: $idToken');
    return idToken;
  }
  throw Exception("User is not logged in.");
}

/// Fetch ID token from Apple Provider
Future<String?> getIdTokenApple(BuildContext context) async {
  final appleProvider = Provider.of<AppleLoginProvider>(context, listen: false);
  return _getIdTokenFromProvider(context, appleProvider, 'apple.com');
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
<<<<<<< Updated upstream
}
=======
}
>>>>>>> Stashed changes
=======
}
>>>>>>> Stashed changes
=======
}
>>>>>>> Stashed changes
=======
}
>>>>>>> Stashed changes
=======
}
>>>>>>> Stashed changes
